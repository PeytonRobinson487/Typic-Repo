extends Node2D

### VARIABLES --------------------------------------------------------------------------------------

## button variables

# array item indexes
# 0 - easy
# 1 - medium
# 2 - hard
# 3 - pro
@onready var sensitivity: ItemList = $Node/Sensitivity

# 0 - lowercase
# 1 - uppercase
# 2 - numbers
# 3 - symbols
@onready var text: ItemList = $Node/Text

# 0 - Music
# 1 - Sound
@onready var sound: ItemList = $Node/Sound

# 0 - current char
# 1 - missed char
# 2 - correct char
# 3 - hard char
# 4 - Accuracy
@onready var score_display: ItemList = $"Node/Score Display"


## other variables
@onready var data = $Data


## Color
const COLOR_ON: Color = Color("AQUAMARINE")
const COLOR_OFF: Color = Color("MAROON")


### FUNCTIONS --------------------------------------------------------------------------------------
# initializer
func _ready():
	# read from file
	data.load_data()
	
	# initialize button colors
	update_all_buttons()


# menu button
# brings the player back to the menu page
func _on_menu_button_pressed() -> void:
	data.save_data()
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

# resets settings
func _on_reset_settings_pressed() -> void:
	data.reset_settings()
	update_all_buttons()


## settings buttons --------------------------------------------------------------------------------
# score list
# changes the scores displayed - descritpion found in data.gd - using the clicked item index.
func _on_score_display_multi_selected(index: int, selected: bool) -> void:
	data.all_data["score_modifiers"][index] = !data.all_data["score_modifiers"][index]
	update_button(index, data.all_data["score_modifiers"], score_display)

# text
# changes the text modifier array - description found in data.gd - using the clicked item index.
func _on_text_item_clicked(index, at_position, mouse_button_index):
	var text_mods: Array = data.all_data["text_modifiers"]
	
	# prevent the player from turning all options off
	var number_false: int = 0
	for state in text_mods:
		if state == false:
			number_false += 1
	if (text_mods[index] && number_false == text_mods.size() - 1):
		text.set_focus_mode(0)
		text.deselect_all()
		return
	
	text_mods[index] = !text_mods[index]
	update_button(index, text_mods, text)
	
	# update data
	data.all_data["text_modifiers"] = text_mods

# difficulty
# changes the difficulty using the clicked item index.
func _on_sensitivity_item_clicked(index, at_position, mouse_button_index):
	match index:
		0: data.all_data["sensitivity"] = data.Sensitivity.LOW
		1: data.all_data["sensitivity"] = data.Sensitivity.MEDIUM
		2: data.all_data["sensitivity"] = data.Sensitivity.HIGH
		3: data.all_data["sensitivity"] = data.Sensitivity.DELICATE
	
	update_sensitivity_button()

# sound
# changes the sound options array - description found in data.gd - using the cilcked item index
func _on_sound_item_clicked(index, at_position, mouse_button_index):
	data.all_data["sound_modifiers"][index] = !data.all_data["sound_modifiers"][index]
	update_button(index, data.sound_modifiers, sound)


## Button colors ---------------------------------------------------------------
# updates either score, sound, or text modifier buttons
func update_button(index: int, option_array: Array, item_list: ItemList) -> void:
	# colors
	print(index)
	if (option_array[index]):
		item_list.set_item_custom_fg_color(index, COLOR_ON)
	else:
		item_list.set_item_custom_fg_color(index, COLOR_OFF)
	
	# removes user focus
	item_list.set_focus_mode(0)
	item_list.deselect_all()

# updates difficulty buttons
func update_sensitivity_button() -> void:
	# colors
	for i in data.Sensitivity.size():
		sensitivity.set_item_custom_fg_color(i, COLOR_OFF)
	
	match data.all_data["sensitivity"]:
		data.Sensitivity.LOW: sensitivity.set_item_custom_fg_color(0, COLOR_ON)
		data.Sensitivity.MEDIUM: sensitivity.set_item_custom_fg_color(1, COLOR_ON)
		data.Sensitivity.HIGH: sensitivity.set_item_custom_fg_color(2, COLOR_ON)
		data.Sensitivity.DELICATE: sensitivity.set_item_custom_fg_color(3, COLOR_ON)
	
	# removes user focus
	sensitivity.set_focus_mode(0)
	sensitivity.deselect_all()

# updates all buttons according to scene variable data: score, text, sound, sensitivity
func update_all_buttons():
	for i in data.score_modifiers.size():
		update_button(i, data.all_data["score_modifiers"], score_display)
	for i in data.text_modifiers.size():
		update_button(i, data.all_data["text_modifiers"], text)
	for i in data.sound_modifiers.size():
		update_button(i, data.all_data["sound_modifiers"], sound)
	update_sensitivity_button()
