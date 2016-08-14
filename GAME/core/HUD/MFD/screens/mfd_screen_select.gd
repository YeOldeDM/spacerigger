
extends PanelContainer

var mfd

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func function0():
	mfd.set_screen('loc')
	mfd.selecting = false

func function1():
	mfd.set_screen('linang')
	mfd.selecting = false

func function2():
	mfd.set_screen('docking')
	mfd.selecting = false