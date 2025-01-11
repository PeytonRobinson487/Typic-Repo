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


### FUNCTIONS --------------------------------------------------------------------------------------
## menu button
func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")


## settings buttons
# score list
# changes the scores displayed - descritpion found in data.gd - using the clicked item index.
func _on_score_display_multi_selected(index: int, selected: bool) -> void:
	data.display_scores[index] = !data.display_scores[index]
	pass


# text
# changes the text modifier array - description found in data.gd - using the clicked item index.
func _on_text_item_clicked(index, at_position, mouse_button_index):
	data.text_modifiers[index] = !data.text_modifiers[index]
	print(data.text_modifiers)


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


# sound
# changes the sound options array - description found in data.gd - using the cilcked item index
func _on_sound_item_clicked(index, at_position, mouse_button_index):
	data.sound_modifiers[index] = !data.sound_modifiers[index]
