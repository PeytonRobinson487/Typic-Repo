## CLASS DESCRIPTION
# the settings page allows the player to make modifications about the game
# the player can modifiy the following game variables:
# + displayed score
# + relevant text - what characters are allowed to be shown in game
# + sensitivity - how sensitive the game is at reacting to player mistakes
# + music - player can choose a background song
# + sound - player can choose to turn sounds off or on 

extends Node2D

## Variables -------------------------------------------------------------------
## OnReady
# data - - -
@onready var data: Node2D = $Data

# sound - - -
@onready var audio_manager_tool: Node2D = $"Audio Manager Tool"

# graphics - - -
@onready var scene_transition_tool: Node2D = $"Graphics/Scene Transition Tool"

# list buttons - - -
# button list for controls what scores are displayed in game
@onready var score_display_options: ItemList = $"Buttons/Score Display Options"
# button list for controls the sensitivity to player mistakes in game
@onready var sensitivity_options: ItemList = $"Buttons/Sensitivity Options"
# button list for what character types are allowed in game
@onready var text_options: ItemList = $"Buttons/Text Options"

# sound buttons - - -
# contains the song list choices
@onready var song_control: ScrollContainer = $"Buttons/Song control"
# toggles music on or off
@onready var master_music: CheckButton = $"Buttons/Sound control/Master Music"
# toggles sound on or off
@onready var master_sound: CheckButton = $"Buttons/Sound control/Master Sound"
# controls how loud the sound is
@onready var music_volume: HSlider = $"Buttons/Sound control/VBoxContainer/volume"
# button for selecting a random song
@onready var choose_random: Button = $"Buttons/Sound control/Choose Random"


## Constants
# color - - -
const COLOR_ON: Color = Color("AQUAMARINE")
const COLOR_OFF: Color = Color("MAROON")


## Functions -------------------------------------------------------------------
## Initialization
# constructor
func _ready():
	# load data
	data.load_data()
	update_all_buttons()
	
	
	# initialize sound and scene transition
	var volume: float = linear_to_db(data.all_data["current_volume"] / 100.0)
	audio_manager_tool.set_volume(volume)
	audio_manager_tool.play_music(data.all_data["current_song_index"], data.all_data["sound_modifiers"][0], data.all_data["music_playback_pos"])
	$"Graphics/Background/Animation Player".play("pop_in")
	$"Graphics/Transition/Animation Player".play_backwards("fade")

# deconstructor
func _on_menu_button_pressed() -> void:
	# play sound and scene transition
	audio_manager_tool.play_sound(1, data.all_data["sound_modifiers"][1])
	$"Graphics/Background/Animation Player".play_backwards("pop_in")
	$"Graphics/Transition/Animation Player".play("fade")
	await get_tree().create_timer(0.3).timeout
	
	# save data
	data.all_data["music_playback_pos"] = audio_manager_tool.get_music_playback_pos()
	data.save_data()
	
	get_tree().change_scene_to_file("res://Scenes/Menu Page.tscn")


## Reset Button
# resets settings
func _on_reset_settings_pressed() -> void:
	audio_manager_tool.play_sound(1, data.all_data["sound_modifiers"][1])
	
	data.reset_settings()
	_ready()


## Settings Buttons
# toggles options in the scores displayed - description found in data.gd
func _on_score_display_multi_selected(index: int, _selected: bool) -> void:
	audio_manager_tool.play_sound(2, data.all_data["sound_modifiers"][1])
	data.all_data["score_modifiers"][index] = !data.all_data["score_modifiers"][index]
	update_button(index, data.all_data["score_modifiers"], score_display_options)

# toggles options in the text modifier array - description found in data.gd
func _on_text_item_clicked(index, _at_position, _mouse_button_index):
	audio_manager_tool.play_sound(2, data.all_data["sound_modifiers"][1])	
	
	# check if there is at least one button on
	var number_false: int = 0
	var text_mods: Array = data.all_data["text_modifiers"]
	for state in text_mods:
		if state == false:
			number_false += 1
	# cancel if the player attempts to turn off the last on button
	if (text_mods[index] && number_false == text_mods.size() - 1):
		text_options.set_focus_mode(0)
		text_options.deselect_all()
		return
	
	text_mods[index] = !text_mods[index]
	update_button(index, text_mods, text_options)
	
	data.all_data["text_modifiers"] = text_mods

# sets the sensitivity
func _on_sensitivity_item_clicked(index, _at_position, _mouse_button_index):
	audio_manager_tool.play_sound(2, data.all_data["sound_modifiers"][1])
	
	# toggle all button colors to off
	for i in data.Sensitivity.size():
		sensitivity_options.set_item_custom_fg_color(i, COLOR_OFF)
	sensitivity_options.set_item_custom_fg_color(index, COLOR_ON)
	
	# update sensitivity in data
	match index:
		0: data.all_data["sensitivity"] = data.Sensitivity.LOW
		1: data.all_data["sensitivity"] = data.Sensitivity.MEDIUM
		2: data.all_data["sensitivity"] = data.Sensitivity.HIGH
		3: data.all_data["sensitivity"] = data.Sensitivity.DELICATE
	
	# remove user focus
	sensitivity_options.set_focus_mode(0)
	sensitivity_options.deselect_all()


## Sound Buttons
# sets a random song from the list as the background music
func _on_choose_random_pressed() -> void:
	audio_manager_tool.play_sound(2, data.all_data["sound_modifiers"][1])
	
	audio_manager_tool.play_random_music(data.all_data["sound_modifiers"][0])
	data.all_data["music_playback_pos"] = 0.0
	data.all_data["current_song_index"] = audio_manager_tool.get_current_song()
	
	choose_random.focus_mode = Control.FOCUS_NONE

# sets bg music to button pressed in the song list
func _on_biscuit_pressed() -> void:
	update_song_button(0)
func _on_boba_tea_pressed() -> void:
	update_song_button(1)
func _on_bread_pressed() -> void:
	update_song_button(2)
func _on_butter_pressed() -> void:
	update_song_button(3)
func _on_chocolate_pressed() -> void:
	update_song_button(4)
func _on_imagine_pressed() -> void:
	update_song_button(5)
func _on_marshmallow_pressed() -> void:
	update_song_button(6)
func _on_onion_pressed() -> void:
	update_song_button(7)
func _on_rose_pressed() -> void:
	update_song_button(8)
func _on_sunset_pressed() -> void:
	update_song_button(9)
func _on_start_up_pressed() -> void:
	update_song_button(10)

# updates the song - for the 11 functions above
func update_song_button(index: int) -> void:
	audio_manager_tool.play_sound(2, data.all_data["sound_modifiers"][1])
	
	audio_manager_tool.play_music(index, data.all_data["sound_modifiers"][0], 0.0)
	data.all_data["current_song_index"] = audio_manager_tool.get_current_song()


## Sound Toggles and Volume
# toggles music on and off
func _on_master_music_toggled(toggled_on: bool) -> void:
	audio_manager_tool.play_sound(2, data.all_data["sound_modifiers"][1])
	
	data.all_data["sound_modifiers"][0] = toggled_on
	if (!toggled_on):
		data.all_data["music_playback_pos"] = audio_manager_tool.get_music_playback_pos()
	audio_manager_tool.play_music(data.all_data["current_song_index"], data.all_data["sound_modifiers"][0], data.all_data["music_playback_pos"])
	
	master_music.focus_mode = Control.FOCUS_NONE

# sets the background music volume to the HSlider value
func _on_volume_value_changed(value: float) -> void:
	audio_manager_tool.set_volume(linear_to_db(value / 100.0))
	data.all_data["current_volume"] = value
	
	music_volume.focus_mode = Control.FOCUS_NONE

# toggles sound effects on and off
func _on_master_sound_toggled(toggled_on: bool) -> void:
	audio_manager_tool.play_sound(2, true)
	data.all_data["sound_modifiers"][1] = toggled_on
	
	master_sound.focus_mode = Control.FOCUS_NONE


## Button UI
# updates either score, sound, or text modifier buttons
func update_button(index: int, option_array: Array, item_list: ItemList) -> void:
	# set button colors
	if (option_array[index]):
		item_list.set_item_custom_fg_color(index, COLOR_ON)
	else:
		item_list.set_item_custom_fg_color(index, COLOR_OFF)
	
	# removes user focus
	item_list.set_focus_mode(0)
	item_list.deselect_all()

# updates all buttons according to data:
# 	score, text, sensitivity
# 	master sound, master music, music volume
func update_all_buttons():
	# music and sound toggle buttons and volume slider
	master_music.set_pressed_no_signal(data.all_data["sound_modifiers"][0])
	music_volume.set_value_no_signal(data.all_data["current_volume"])
	master_sound.set_pressed_no_signal(data.all_data["sound_modifiers"][1])
	
	# temporaraly turn off sound to prevent settings buttons from creating sound
	var sound_temp: bool = data.all_data["sound_modifiers"][1]
	data.all_data["sound_modifiers"][1] = false
	
	# score, text, and sensitivity
	for i in data.score_modifiers.size():
		update_button(i, data.all_data["score_modifiers"], score_display_options)
	for i in data.text_modifiers.size():
		update_button(i, data.all_data["text_modifiers"], text_options)
	
	var index: int = 0
	match data.all_data["sensitivity"]:
		#0: index = 0
		2: index = 1
		4: index = 2
		8: index = 3
	_on_sensitivity_item_clicked(index, 0, 0)
	
	data.all_data["sound_modifiers"][1] = sound_temp
