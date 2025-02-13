extends Node2D

# data
@onready var data: Node2D = $Data
@onready var score_display: RichTextLabel = $UI/Score_Display

# sounds
@onready var background_music: Node2D = $AudioManager
@onready var light_click: AudioStreamPlayer = $"Sound Effects/light click"
@onready var button_select: AudioStreamPlayer = $"Sound Effects/button select"

# animations
@onready var scene_transition: Node2D = $SceneTransition


## -------------------------------------------------------------------------------------------------
# initialization
func _ready() -> void:
	scene_transition.scene_fade_in()
	
	data.load_data()
	display_stats()
	
	background_music.set_song(data.all_data["current_song"], data)
	background_music.set_volume(data.all_data["current_volume"])

## menu button
func _on_menu_button_pressed() -> void:
	scene_transition.scene_fade_out()
	
	data.all_data["playback_pos"] = background_music.get_playback_pos()
	
	data.save_data()
	
	if (data.all_data["sound_modifiers"][1]):
		light_click.pitch_scale = randf() / 10 + 0.95
		light_click.play(0.1)
	# wait for scene transition animation to finish
	await get_tree().create_timer(scene_transition.WAIT_TIME).timeout
	
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

# resets stats
func _on_clear_stats_pressed() -> void:
	data.reset_score_data()
	display_stats()
	
	if (data.all_data["sound_modifiers"][1]):
		light_click.pitch_scale = randf() / 10 + 0.95
		light_click.play(0.1)


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
