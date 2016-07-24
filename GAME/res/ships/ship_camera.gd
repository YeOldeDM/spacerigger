
extends Camera2D

var shake_amp = 0

export var shake_magnitude = 0.4
export var shake_falloff = 0.92

func _process(delta):
	shake_amp = max(shake_amp*(shake_falloff),0)
	if shake_amp <= 0.0:
		set_offset(Vector2(0,0))
		set_process(false)
	else:
		_shake()

func apply_shake(amt):
	if shake_amp < amt:
		shake_amp += amt
	if not is_processing():
		set_process(true)

func _shake():
	var amt = shake_amp * shake_magnitude
	var Rx = rand_range(-amt,amt)
	var Ry = rand_range(-amt,amt)
	set_offset(Vector2(Rx,Ry))

