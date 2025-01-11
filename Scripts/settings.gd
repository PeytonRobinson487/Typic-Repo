extends Node2D

### VARIABLES --------------------------------------------------------------------------------------

## button variables
# array item indexes
# 1 - easy
# 2 - medium
# 3 - hard
# 4 - pro
@onready var difficulty: ItemList = $Node/Difficulty

# 1 - lowercase
# 2 - uppercase
# 3 - numbers
# 4 - symbols
@onready var text: ItemList = $Node/Text

# 1 - Music
# 2 - Sound
@onready var sound: ItemList = $Node/Sound

# 1 - current char
# 2 - missed char
# 3 - correct char
# 4 - hard char
# 5 - Accuracy
@onready var score_display: ItemList = $"Node/Score Display"

## other variables
@onready var data: Node2D = $Data


### FUNCTIONS --------------------------------------------------------------------------------------
## menu button
func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")


## settings buttons
# score list
func _on_score_display_multi_selected(index: int, selected: bool) -> void:
	data.display_scores[index] = !data.display_scores[index]
	print(data.display_scores)
	pass


# difficulty
func _on_difficulty_item_selected(index: int) -> void:
	pass # Replace with function body.


# text
func _on_text_item_selected(index: int) -> void:
	pass # Replace with function body.


# sound
func _on_sound_item_selected(index: int) -> void:
	pass # Replace with function body.
