
extends RigidBody2D

export var Name = "Godot Station"
export var ID = "GS-A1"



func _ready():
	config()


func config():
	var file = ConfigFile.new()
	file.set_value("SUPPLY", 'energy', 1000)
	var saved = file.save('res://station_template.ini')
	print(saved)
