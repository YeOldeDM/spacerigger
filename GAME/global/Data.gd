
extends Node


class Profile:
	var name
	var creation_time
	var settings
	
	func _init(name, creation_time=OS.get_unix_time()):
		self.name = name
		self.creation_time = creation_time


	

class Pilot:
	var name
	var creation_time
	var profile
	
	var flight_time = 0
	
	var game_state
	
	func _init(profile,name):
		self.profile = profile
		self.name = name
		self.creation_time = OS.get_unix_time()
	





const PILOT_PATH = 'res://pilots/'
const PROFILE_PATH = 'res://profiles'

var current_profile
var current_pilot

func get_profile():
	return current_profile

func get_pilot():
	return current_pilot


func new_profile(name):
	var path = PROFILE_PATH+'/'+name
	var dir = Directory.new()
	if dir.open(path) == OK:
		return false
	else:
		dir.make_dir(path)
		dir.make_dir(path+'/pilots')

func new_pilot(profile, name):
	var path = PROFILE_PATH +'/'+ profile
	var dir = Directory.new()
	if dir.open(path) == OK:
		var pilot_path = path+'/pilots/'+name
		if dir.open(pilot_path) == OK:
			return false
		else:
			dir.make_dir(pilot_path)

func get_profile_names():
	var names = []
	var dir = Directory.new()
	if dir.open(PROFILE_PATH) == OK:
		dir.list_dir_begin()
		var file = dir.get_next()
		while file != "":
			if dir.current_is_dir():
				if !file.begins_with('.'):
					names.append(file)
			file = dir.get_next()
		
		return names
	else:
		return false
	



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


