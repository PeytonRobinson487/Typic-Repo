extends Node2D

## Variables ------------------------------------------------------------------
# data - - -
@onready var data: Node2D = $Data

# sound - - -
@onready var audio_manager: Node2D = $"Sound/Audio Manager"
# sound effect when the menu button is clicked
@onready var light_click: AudioStreamPlayer = $"Sound/Light Click"

# graphics - - -
# scene transition for going in and out of the scene
@onready var scene_transition: Node2D = $"Graphics/Scene Transition"


## Functions ------------------------------------------------------------------
# constructor
func _ready() -> void:
	# scene animation
	scene_transition.scene_fade_in()
	
	# initialize music
	background_music.set_song(data.all_data["current_song"], data)
	background_music.set_volume(data.all_data["current_volume"])


# deconstructor - exits to the menu
func _on_menu_button_pressed() -> void:
	scene_transition.scene_fade_out()
	# play sound if allowed
	if (data.all_data["sound_modifiers"][1]):
		light_click.pitch_scale = randf() / 10 + 0.95
		light_click.play(0.1)
	# wait for scene transition animation to finish
	await get_tree().create_timer(scene_transition.WAIT_TIME).timeout
	
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
