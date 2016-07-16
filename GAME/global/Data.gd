
extends Node

class Pilot:
	var ID
	var name
	var creation_time
	
	func _init(ID,name):
		self.ID = ID
		self.name = name
		self.creation_time = OS.get_unix_time()
	

const PILOT_PATH = 'res://pilots/'

func save_pilot(pilot):
	var file = File.new()
	var path = PILOT_PATH+str(pilot.ID)+'.pilot'
	file.open(path, File.WRITE)
	var data = inst2dict(pilot)
	file.store_line(data.to_json())
	file.close()

func load_pilot(id):
	var file = File.new()
	var path = PILOT_PATH+str(id)+'.pilot'
	file.open(path, File.READ)
	var data = {}
	while not file.eof_reached():
		data.parse_json(file.get_line())
	file.close()
	return data


