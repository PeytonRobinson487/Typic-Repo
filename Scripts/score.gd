extends Node2D

@onready var data: Node2D = $Data
@onready var score_display: RichTextLabel = $Score_Display


## -------------------------------------------------------------------------------------------------
# initialization
func _ready() -> void:
	data.load_data()
	display_stats()

## menu button
func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

# resets stats
func _on_clear_stats_pressed() -> void:
	data.reset_score_data()
	display_stats()


### Stats functions --------------------------------------------------------------------------------
## stats display
# displays all stats
func display_stats() -> void:
	var text: String = ""
	text += "Total score: " + str(data.all_data["total_score"]) + "\n"
	text += "Total wrong: " + str(data.all_data["total_wrong"]) + "\n"
	text += "Total correct: " + str(data.all_data["total_correct"]) + "\n"
	text += "Average accuracy: " + str(round(data.all_data["average_accuracy"] * 10) / 10) + "%\n"
	text += "Longest streak: " + str(data.all_data["longest_streak"]) + "\n"
	text += "Player level: " + str(data.all_data["player_level"]) + "\n"
	text += "Hard lowercase: " + str(data.all_data["hard_library"][0].keys()) + "\n"
	text += "Hard uppercase: " + str(data.all_data["hard_library"][1].keys()) + "\n"
	text += "Hard number: " + str(data.all_data["hard_library"][2].keys()) + "\n"
	text += "Hard symbol: " + str(data.all_data["hard_library"][3].keys()) + "\n"
	
	score_display.text = text
