extends Node2D

## Variables ------------------------------------------------------------------
## OnReady
# data - - -
@onready var data: Node2D = $Data

# sound - - -
@onready var audio_manager_tool: Node2D = $"Audio Manager Tool"

# graphics - - -
@onready var scene_transition_tool: Node2D = $"Graphics/Scene Transition Tool"


## Functions ------------------------------------------------------------------
## Initialization
# constructor
func _ready() -> void:
	data.load_data()
	
	# initialize sound and play scene transition
	$"Graphics/Background/Animation Player".play("pop_in")
	$"Graphics/Transition/Animation Player".play_backwards("fade")
	audio_manager_tool.play_music(data.all_data["current_song_index"], data.all_data["sound_modifiers"][0], data.all_data["music_playback_pos"])
	var volume: float = linear_to_db(data.all_data["current_volume"] / 100.0)
	audio_manager_tool.set_volume(volume)

# deconstructor - exits to the menu
func _on_menu_button_pressed() -> void:
	# play sound and scene transition
	$"Graphics/Background/Animation Player".play_backwards("pop_in")
	$"Graphics/Transition/Animation Player".play("fade")
	audio_manager_tool.play_sound(1, data.all_data["sound_modifiers"][1])
	await get_tree().create_timer(0.3).timeout
	
	data.all_data["music_playback_pos"] = audio_manager_tool.get_music_playback_pos()
	data.save_data()
	
	get_tree().change_scene_to_file("res://Scenes/Menu Page.tscn")
