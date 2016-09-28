
extends Particles2D

const TYPE_MAIN = 0
const TYPE_REACTION = 1
const DIRECTION_PROGRADE = 0
const DIRECTION_RETROGRADE = 1
const DIRECTION_PORT = 2
const DIRECTION_STARBOARD = 3
const PLACEMENT_NIL = 0
const PLACEMENT_FORE = 1
const PLACEMENT_PORT = 1
const PLACEMENT_STARBOARD = 2
const PLACEMENT_AFT = 2

export var max_parts = 16
export var max_life = 1.0

export(int, "Main", "Reaction") var thrust_type
export(int, "Prograde", "Retrograde", "Port", "Starboard") var thrust_direction
export(int, "Nil", "Fore/Port", "Aft/Starboard") var thrust_placement

const ACCEL = 8

var rate = 1		#1= rising, -1=falling

var power = 0.0 setget _set_power

func turn_on():
	rate = 1
	#set_emitting(true)


func turn_off():
	rate = -1
	#set_emitting(false)


func _set_power( per ):
	per = clamp(per, 0.0, 1.0)
	#set_lifetime(lerp(0.0, max_life, per))
	set_amount(lerp(1, max_parts, per))
	power = per
	if per <= 0.1:
		if is_emitting():
			set_emitting(false)
	else:
		if not is_emitting():
			set_emitting(true)
		#print(get_name())


func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	var P = power
	P += delta*ACCEL*rate
	
	set('power', P)

	