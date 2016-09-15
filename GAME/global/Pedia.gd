
extends Node

#
#	PEDIA SINGLETON
#

# Path to pedia file
const PEDIA_PATH = 'res://ref/pedia.ini'

# Working pedia library
# Set by load_pedia()
var ref = null




# Load the pedia file
func load_pedia(path=PEDIA_PATH):
	prints('Loading Pedia file', path)
	var file = ConfigFile.new()
	var loaded = file.load(path)
	if loaded==OK:
		ref = file
	return loaded

# Save changes to the pedia file
func save_pedia(path=PEDIA_PATH):
	var saved = ref.save(path)
	return saved




# Return the pedia file text referred to by 'entry'
func ref(entry):
	if ref.has_section(entry):
		var text = ref.get_value(entry, 'text')
		return text
	else:
		print("!! No such entry in Pedia: "+entry+" !!")
		return null

# Add a new entry to the pedia.
func add_entry(entry, text):
	ref.set_value(entry, 'text', text)
	save_pedia()










# Called once on game's first run to generate a new Pedia file.
# Do not call this method for any reason.
func make_pedia():
	var file = ConfigFile.new()
	var data = {'welcome':
		"Welcome to the SpaceRigger 'Pedia!\nHere you will find all the information you need to know about everything about the game's world.\n[url=test]TEST[/url]",
				'test':
		"This is a test page! \n\n [center][url=welcome]Go Back[/url][/center]"
		}
	for key in data:
		file.set_value(key, 'text', data[key])
	ref = file
	print(ref.get_sections())
	var check = File.new()
	check = check.file_exists(PEDIA_PATH)
	if not check:
		save_pedia()
	else:
		OS.alert("Pedia file already exists!", "The fuq you tryin' ta do??")