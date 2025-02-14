extends Node2D

### VARIABLES --------------------------------------------------------------------------------------
# list buttons - - -
@onready var score_display: ItemList = $"Buttons/Score Display Options"
@onready var sensitivity: ItemList = $"Buttons/Sensitivity Options"
@onready var text: ItemList = $"Buttons/Text Options"

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

# data - - -
# contains the saved variables between scenes
@onready var data: Node2D = $Data

# sound - - -
@onready var background_music: Node2D = $"Sound/Background Music"
# click sound for the reset and menu button
@onready var light_click: AudioStreamPlayer = $"Sound/Light Click"
# click sound for selecting a button
@onready var select_button: AudioStreamPlayer = $"Sound/Select Button"

# scene animation - - -
# for transitions in and out of the scene
@onready var scene_transition: Node2D = $"Graphics/Scene Transition"

# color - - -
const COLOR_ON: Color = Color("AQUAMARINE")
const COLOR_OFF: Color = Color("MAROON")


### FUNCTIONS --------------------------------------------------------------------------------------
# initializer
func _ready():
	scene_transition.scene_fade_in()
	
	data.load_data()
	update_all_buttons()
	
	background_music.set_song(data.all_data["current_song"], data)
	background_music.set_volume(data.all_data["current_volume"])

# deconstructor
# brings the player back to the menu page
func _on_menu_button_pressed() -> void:
	scene_transition.scene_fade_out()
	
	data.all_data["playback_pos"] = background_music.get_playback_pos()
	
	data.save_data()
	
	play_sound(light_click)
	# wait for scene transition animation to finish
	await get_tree().create_timer(scene_transition.WAIT_TIME).timeout
	
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

# resets settings
func _on_reset_settings_pressed() -> void:
	play_sound(light_click)
	
	data.reset_settings()
	_ready()


## settings buttons --------------------------------------------------------------------------------
# toggles options in the scores displayed - description found in data.gd
func _on_score_display_multi_selected(index: int, _selected: bool) -> void:
	data.all_data["score_modifiers"][index] = !data.all_data["score_modifiers"][index]
	update_button(index, data.all_data["score_modifiers"], score_display)
	
	play_sound(select_button)

# toggles options in the text modifier array - description found in data.gd
func _on_text_item_clicked(index, _at_position, _mouse_button_index):
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
	
	data.all_data["text_modifiers"] = text_mods
	
	play_sound(select_button)

# sets the sensitivity
func _on_sensitivity_item_clicked(index, _at_position, _mouse_button_index):
	# update sensitivity in data
	match index:
		0: data.all_data["sensitivity"] = data.Sensitivity.LOW
		1: data.all_data["sensitivity"] = data.Sensitivity.MEDIUM
		2: data.all_data["sensitivity"] = data.Sensitivity.HIGH
		3: data.all_data["sensitivity"] = data.Sensitivity.DELICATE
	
	# toggle all button colors to off
	for i in data.Sensitivity.size():
		sensitivity.set_item_custom_fg_color(i, COLOR_OFF)
	
	# toggle one button color to on
	match data.all_data["sensitivity"]:
		data.Sensitivity.LOW: sensitivity.set_item_custom_fg_color(0, COLOR_ON)
		data.Sensitivity.MEDIUM: sensitivity.set_item_custom_fg_color(1, COLOR_ON)
		data.Sensitivity.HIGH: sensitivity.set_item_custom_fg_color(2, COLOR_ON)
		data.Sensitivity.DELICATE: sensitivity.set_item_custom_fg_color(3, COLOR_ON)
	
	# remove user focus
	sensitivity.set_focus_mode(0)
	sensitivity.deselect_all()
	
	play_sound(select_button)


## sound buttons ---------------------------------------------------------------
# song buttons
# sets bg music to button pressed
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
	var new_song: String = data.SONGS[index]
	background_music.set_song(new_song, data)
	data.all_data["current_song"] = new_song
	
	play_sound(select_button)


# toggles music on and off
func _on_master_music_toggled(toggled_on: bool) -> void:
	# toggle music on or off
	# music was off, now turning on
	if (!toggled_on):
		data.all_data["playback_pos"] = background_music.get_playback_pos()
		background_music.set_song("", data)
		data.all_data["sound_modifiers"][0] = toggled_on
	# music was on, now turning off
	else:
		data.all_data["sound_modifiers"][0] = toggled_on
		background_music.set_song(data.all_data["current_song"], data)
	
	master_music.focus_mode = Control.FOCUS_NONE
	
	play_sound(select_button)

# sets a random song from the list as the background music
func _on_choose_random_pressed() -> void:
	var new_song: String = data.SONGS.pick_random()
	background_music.set_song(new_song, data)
	data.all_data["current_song"] = new_song
	
	choose_random.focus_mode = Control.FOCUS_NONE
	
	play_sound(select_button)

# sets the background music volume to the HSlider value
func _on_volume_value_changed(value: float) -> void:
	background_music.set_volume(value)
	data.all_data["current_volume"] = value
	
	music_volume.focus_mode = Control.FOCUS_NONE

# toggles sound effects on and off
func _on_master_sound_toggled(toggled_on: bool) -> void:
	data.all_data["sound_modifiers"][1] = toggled_on
	
	master_sound.focus_mode = Control.FOCUS_NONE
	
	play_sound(select_button)


# plays a sound
func play_sound(sound: AudioStreamPlayer) -> void:
	# check if sounds are allowed to be played
	var sound_on: bool = data.all_data["sound_modifiers"][1]
	if (sound_on):
		sound.pitch_scale = randf() / 10 + 0.95
		sound.play(0.1)


## Button colors ---------------------------------------------------------------
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
	# score, text, and sensitivity
	for i in data.score_modifiers.size():
		update_button(i, data.all_data["score_modifiers"], score_display)
	for i in data.text_modifiers.size():
		update_button(i, data.all_data["text_modifiers"], text)
	_on_sensitivity_item_clicked(data.all_data["sensitivity"], 0, 0)
	
	# master sound, master music, music volume
	master_music.set_pressed_no_signal(data.all_data["sound_modifiers"][0])
	master_sound.set_pressed_no_signal(data.all_data["sound_modifiers"][1])
	music_volume.set_value_no_signal(data.all_data["current_volume"])
