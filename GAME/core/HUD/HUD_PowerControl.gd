
extends Panel

const RED = Color(1,0,0)
const GREEN = Color(0,1,1)

onready var source = get_node('Source')
onready var gen_button = get_node('GEN/Switch')
onready var apu_button = get_node('APU/Switch')
onready var ext_button = get_node('EXT/Switch')

var thrusters_on = false


var gen_power = 0
var gen_power_full = 2.5


var apu_capacity = 50
var apu_charge = 50
var apu_output = 0.25

var has_external_power = false

var ext_output = 0.02

func is_gen_on():
	var on = gen_button.is_pressed()
	set_light('GEN',on)
	return on



func is_gen_running():
	if gen_power >= gen_power_full:
		return true
	return false

func is_on_ext_power():
	return source.is_pressed()

func is_ext_on():
	var on = ext_button.is_pressed()
	set_light('EXT',on)
	return on

func is_apu_on():
	var on = apu_button.is_pressed()
	set_light('APU',on)
	return on

func is_apu_powered():
	if apu_charge > 0.0:
		return false
	return true

func is_apu_charged():
	if apu_charge >= apu_capacity:
		return true
	return false

func get_power_output():
	var output = 0.0
	if is_on_ext_power():
		if has_external_power:
			if is_ext_on():
				output = ext_output
	else:
		if is_apu_on():
			output = apu_output
	return output

func drain_apu(power):
	var new_value = apu_charge - power
	apu_charge = clamp(new_value, 0.0, apu_capacity)
	var value = (apu_charge*1.0)/(apu_capacity*1.0)
	draw_element(get_element('APU','Tank'), value)


func get_element(container, element):
	return get_node(container+'/'+element)

func draw_element(element, value):
	if element extends Polygon2D:
		element.set_color(value)
	if element extends ProgressBar:
		element.set_value(value)
	if element extends Label:
		var text = str(value).pad_decimals(2)+'w'

func set_light(container, on):
	var light = get_element(container,'Light')
	if on:
		if light.get_color() != GREEN:
			draw_element(light, GREEN)
	else:
		if light.get_color() != RED:
			draw_element(light, RED)

func _ready():
	set_process(true)

func _process(delta):
	var charging = is_gen_on()
	if not is_gen_running():
		# try transfering power output to gen_power
		var pwr = get_power_output()
		
		if pwr > 0:
			if is_gen_on():
				gen_power += pwr*delta
				charging = true
			if !is_on_ext_power():
				if is_gen_on():
					drain_apu(pwr*delta)

			
			var value = (gen_power*1.0)/(gen_power_full*1.0)
			
			draw_element(get_element('GEN', 'Tank'), value)
		else:
			charging = false
	# Discharge generator power if not running and not charging
	prints(charging, is_gen_running())
	if not charging:
		if gen_power > 0.0:
			var new_pwr = gen_power - (1.0*delta)
			gen_power = max(new_pwr, 0.0)
			var value = (gen_power*1.0)/(gen_power_full*1.0)
			draw_element(get_element('GEN', 'Tank'), value)
	# Clamp gen power to full if it overflows
	if gen_power > gen_power_full:
		gen_power = gen_power_full


