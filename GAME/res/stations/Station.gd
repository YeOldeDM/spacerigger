
extends RigidBody2D

export var name = "Godot Station"
export var station_class = "Civilian"
export var station_type = "Habitat"

export var designation = "ST-GOD-A01"



func _ready():
	config()


func config():
	var file = ConfigFile.new()
	file.set_value("SUPPLY", 'energy', 1000)
	var saved = file.save('res://station_template.ini')
	print(saved)
