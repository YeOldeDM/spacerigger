
extends WindowDialog

onready var show = get_node('box/panel/Show')
onready var entry_box = show.get_node('Entry')
onready var edit = get_node('box/panel/Edit')
onready var edit_box = edit.get_node('Entry')

var history = []
var history_position = 0

var current_entry

func _goto(entry):
	# Beep!
	SoundMan.play('beep')
	# Display entry Category:Entry in window title
	var subject = entry.replace('_',':')
	set_title("Pedia -- "+subject)
	prints("Pedia entry selected--",entry)
	
	# Get text for new entry from Pedia
	var text = Pedia.ref(entry)
	
	# Append current entry to history
	if current_entry:	history.insert(0,current_entry)
	
	# Set and display new entry
	current_entry = entry
	if Pedia.ref.has_section(entry):
		entry_box.set_bbcode(text)
	
	# or create new Pedia entry and go to Edit mode.
	else:
		Pedia.add_entry(current_entry, "[color=red]THIS PAGE HAS NOT BEEN CREATED YET![/color]")
		_on_Edit_pressed()
	

func _ready():
	Pedia.load_pedia()
	edit_box.set_wrap(true)






func _on_PediaWindow_about_to_show():
	if current_entry:
#		var subject = current_entry.replace('_',':')
#		set_title("Pedia -- "+subject)
		_goto(current_entry)
	else:
		_goto('welcome')


func _on_Show_pressed():
	if !is_visible():
		popup_centered()


func _on_hide():
	SoundMan.play('beep')
	if get_tree().is_paused():
		get_tree().set_pause(false)


func _on_Edit_pressed():
	get_tree().set_pause(true)
	edit_box.set_text(Pedia.ref(current_entry))
	show.hide()
	edit.show()
	


func _on_Cancel_pressed():
	edit.hide()
	show.show()
	get_tree().set_pause(false)


func _on_Submit_pressed():
	Pedia.add_entry(current_entry, edit_box.get_text())
	Pedia.save_pedia()
	edit.hide()
	show.show()
	_goto(current_entry)
	get_tree().set_pause(false)
