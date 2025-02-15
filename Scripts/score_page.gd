## CLASS DESCRIPTION
# Displays the player's stats from data.gd
# Stats can be reset by the player

extends Node2D

## Variables -------------------------------------------------------------------
## OnReady
# data - - -
@onready var data: Node2D = $Data

# audio - - -
@onready var audio_manager_tool: Node2D = $"Audio Manager Tool"

# graphics  - - -
@onready var scene_transition_tool: Node2D = $"Graphics/Scene Transition Tool"


## Functions ------------------------------------------------------------------
## Initialization
# constructor
func _ready() -> void:
	# load data
	data.load_data()
	display_stats()
	
	# sound and transition
	var volume: float = linear_to_db(data.all_data["current_volume"] / 100.0)
	audio_manager_tool.set_volume(volume)
	audio_manager_tool.play_music(data.all_data["current_song_index"], data.all_data["sound_modifiers"][0], data.all_data["music_playback_pos"])
	$"Graphics/Background/Animation Player".play("pop_in")
	$"Graphics/Transition/Animation Player".play_backwards("fade")

# deconstructor
func _on_menu_button_pressed() -> void:
	# sound and transition
	audio_manager_tool.play_sound(1, data.all_data["sound_modifiers"][1])
	$"Graphics/Background/Animation Player".play_backwards("pop_in")
	$"Graphics/Transition/Animation Player".play("fade")
	await get_tree().create_timer(0.3).timeout
	
	# save data
	data.all_data["music_playback_pos"] = audio_manager_tool.get_music_playback_pos()
	data.save_data()
	
	get_tree().change_scene_to_file("res://Scenes/Menu Page.tscn")


## Reset button
# resets stats in data
func _on_clear_stats_pressed() -> void:
	audio_manager_tool.play_sound(1, data.all_data["sound_modifiers"][1])
	
	data.reset_score_data()
	display_stats()


## Text UI
# displays all stats from data
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
	
	$Graphics/Score_Display.text = text
