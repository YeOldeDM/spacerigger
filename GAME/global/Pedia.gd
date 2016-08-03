
extends Node

#
#	PEDIA SINGLETON
#

const PEDIA_PATH = 'res://ref/pedia.ini'

var ref = null

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
	save_pedia()
	var loaded = load_pedia()
	print(loaded)
	print(ref.get_sections())





func load_pedia(path=PEDIA_PATH):
	print(path)
	var file = ConfigFile.new()
	var loaded = file.load(path)
	if loaded==OK:
		ref = file
	return loaded


func save_pedia(path=PEDIA_PATH):
	var saved = ref.save(path)
	return saved





func ref(entry):
	if ref.has_section(entry):
		prints("keys",ref.get_section_keys(entry))
		var text = ref.get_value(entry, 'text')
		return text
	else:
		print("!! No such entry in Pedia: "+entry+" !!")
		return null


