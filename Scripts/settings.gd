extends Node2D

### VARIABLES --------------------------------------------------------------------------------------

## button variables
# array item indexes
# 0 - easy
# 1 - medium
# 2 - hard
# 3 - pro
@onready var difficulty: ItemList = $Node/Difficulty

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


## settings buttons ------------------------------------------------------------
# score list
# changes the scores displayed - descritpion found in data.gd - using the clicked item index.
func _on_score_display_multi_selected(index: int, selected: bool) -> void:
	data.score_modifiers[index] = !data.score_modifiers[index]
	update_button(index, data.score_modifiers, score_display)
# text
# changes the text modifier array - description found in data.gd - using the clicked item index.
func _on_text_item_clicked(index, at_position, mouse_button_index):
	data.text_modifiers[index] = !data.text_modifiers[index]
	update_button(index, data.text_modifiers, text)
# difficulty
# changes the difficulty using the clicked item index.
func _on_difficulty_item_clicked(index, at_position, mouse_button_index):
	match index:
		0:
			data.difficulty = data.Difficulty.EASY
		1:
			data.difficulty = data.Difficulty.MEDIUM
		2:
			data.difficulty = data.Difficulty.HARD
		3:
			data.difficulty = data.Difficulty.PRO
	update_difficulty_button(index)
# sound
# changes the sound options array - description found in data.gd - using the cilcked item index
func _on_sound_item_clicked(index, at_position, mouse_button_index):
	data.sound_modifiers[index] = !data.sound_modifiers[index]
	update_button(index, data.sound_modifiers, sound)


## Button colors ---------------------------------------------------------------
# updates either score, sound, or text modifier buttons
func update_button(index: int, option_array: Array, item_list: ItemList) -> void:
	# colors
	var button_state: bool = option_array[index]
	if (button_state):
		item_list.set_item_custom_fg_color(index, COLOR_ON)
	else:
		item_list.set_item_custom_fg_color(index, COLOR_OFF)
	
	# removes user focus
	item_list.set_focus_mode(0)
	item_list.deselect_all()
# updates difficulty buttons
func update_difficulty_button(index: int) -> void:
	# colors
	for i in data.Difficulty.size():
		difficulty.set_item_custom_fg_color(i, COLOR_OFF)
	
	match data.difficulty:
		data.Difficulty.EASY:
			difficulty.set_item_custom_fg_color(0, COLOR_ON)
		data.Difficulty.MEDIUM:
			difficulty.set_item_custom_fg_color(1, COLOR_ON)
		data.Difficulty.HARD:
			difficulty.set_item_custom_fg_color(2, COLOR_ON)
		data.Difficulty.PRO:
			difficulty.set_item_custom_fg_color(3, COLOR_ON)
	
	# removes user focus
	difficulty.set_focus_mode(0)
	difficulty.deselect_all()
# updates all buttons according to scene variable data: score, text, sound, difficulty
func update_all_buttons():
	for i in data.score_modifiers.size():
		update_button(i, data.score_modifiers, score_display)
	for i in data.text_modifiers.size():
		update_button(i, data.text_modifiers, text)
	for i in data.sound_modifiers.size():
		update_button(i, data.sound_modifiers, sound)
	for i in data.Difficulty.size():
		update_difficulty_button(i)
