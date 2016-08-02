
extends Node


var DEFAULT_PROFILE = {
	'DATA':	{
	'creation time':	OS.get_unix_time(),
	'play time':		0,
		},
	'SETTINGS':	{
	'start_maximized':	true,
		},
	}



class Profile:
	var name
	var creation_time
	var settings
	
	var playtime = 0
	
	func _init(name, creation_time=OS.get_unix_time()):
		self.name = name
		self.creation_time = creation_time

	func get_package():
		var file = ConfigFile.new()
		
		return file

	

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


#
#	PROFILE MANAGEMENT
#

func new_profile(name):
	var path = PROFILE_PATH+'/'+name
	var data = ConfigFile.new()
	for key in DEFAULT_PROFILE:
		for set in DEFAULT_PROFILE[key]:
			data.set_value(key,set,DEFAULT_PROFILE[key][set])
	
	
	var dir = Directory.new()
	if dir.open(path) == OK:
		return FAILED
	else:
		dir.make_dir(path)
		dir.make_dir(path+'/pilots')
		data.save(path+'/profile.ini')
		return OK



func save_profile(profile):
	var name = profile.name
	var path = PROFILE_PATH+'/'+name+'/'+name+'.profile'
	var data = profile.get_package()
	data.save(path)
	print("Saved Profile to "+path)




func load_profile(name):
	var path = PROFILE_PATH+'/'+name+'/profile.ini'
	var file = ConfigFile.new()
	if !file.load(path) == OK:
		return null
	return file


#
#	PILOT MANAGEMENT
#


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
	return dict2inst(data)


