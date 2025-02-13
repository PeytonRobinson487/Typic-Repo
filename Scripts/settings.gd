extends Node2D

### VARIABLES --------------------------------------------------------------------------------------

## button variables

# array item indexes
# 0 - easy
# 1 - medium
# 2 - hard
# 3 - pro
@onready var sensitivity: ItemList = $Buttons/Sensitivity


# 0 - lowercase
# 1 - uppercase
# 2 - numbers
# 3 - symbols
@onready var text: ItemList = $Buttons/Text

# sound
# controls the songs
# + true or false for each of the 11 songs
@onready var song_control: ScrollContainer = $"Buttons/Song control"

# controls the sound
# music toggle
# sound effect toggle
# volume
# choosing random song
@onready var sound_control: GridContainer = $"Buttons/Sound control"
@onready var master_music: CheckButton = $"Buttons/Sound control/Master Music"
@onready var master_sound: CheckButton = $"Buttons/Sound control/Master Sound"
@onready var volume: HSlider = $"Buttons/Sound control/VBoxContainer/volume"
@onready var choose_random: Button = $"Buttons/Sound control/Choose Random"


# 0 - current char
# 1 - missed char
# 2 - correct char
# 3 - hard char
# 4 - Accuracy
@onready var score_display: ItemList = $"Buttons/Score Display"


## other variables
@onready var data: Node2D = $Data
@onready var background_music: Node2D = $background_music


## Color
const COLOR_ON: Color = Color("AQUAMARINE")
const COLOR_OFF: Color = Color("MAROON")


### FUNCTIONS --------------------------------------------------------------------------------------
# initializer
func _ready():
	data.load_data()
	
	background_music.set_volume(0)
	background_music.set_song(data.all_data["current_song"], data)
	background_music.set_volume(data.all_data["current_volume"])
	
	update_all_buttons()


# menu button
# brings the player back to the menu page
func _on_menu_button_pressed() -> void:
	data.all_data["playback_pos"] = background_music.get_playback_pos()
	
	data.save_data()
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

# resets settings
func _on_reset_settings_pressed() -> void:
	data.reset_settings()
	_ready()


## settings buttons --------------------------------------------------------------------------------
# score list
# changes the scores displayed - descritpion found in data.gd - using the clicked item index.
func _on_score_display_multi_selected(index: int, _selected: bool) -> void:
	data.all_data["score_modifiers"][index] = !data.all_data["score_modifiers"][index]
	update_button(index, data.all_data["score_modifiers"], score_display)

# text
# changes the text modifier array - description found in data.gd - using the clicked item index.
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
	
	# update data
	data.all_data["text_modifiers"] = text_mods

# difficulty
# changes the difficulty using the clicked item index.
func _on_sensitivity_item_clicked(index, _at_position, _mouse_button_index):
	match index:
		0: data.all_data["sensitivity"] = data.Sensitivity.LOW
		1: data.all_data["sensitivity"] = data.Sensitivity.MEDIUM
		2: data.all_data["sensitivity"] = data.Sensitivity.HIGH
		3: data.all_data["sensitivity"] = data.Sensitivity.DELICATE
	
	# colors
	for i in data.Sensitivity.size():
		sensitivity.set_item_custom_fg_color(i, COLOR_OFF)
	
	match data.all_data["sensitivity"]:
		data.Sensitivity.LOW: sensitivity.set_item_custom_fg_color(0, COLOR_ON)
		data.Sensitivity.MEDIUM: sensitivity.set_item_custom_fg_color(1, COLOR_ON)
		data.Sensitivity.HIGH: sensitivity.set_item_custom_fg_color(2, COLOR_ON)
		data.Sensitivity.DELICATE: sensitivity.set_item_custom_fg_color(3, COLOR_ON)
	
	# removes user focus
	sensitivity.set_focus_mode(0)
	sensitivity.deselect_all()

## sound buttons ---------------------------------------------------------------
# song buttons
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

# updates the song
func update_song_button(index: int) -> void:
	var new_song: String = data.SONGS[index]
	background_music.set_song(new_song, data)
	data.all_data["current_song"] = new_song

# music
func _on_master_music_toggled(toggled_on: bool) -> void:
	print("Toggle: " + str(toggled_on))
	
	if (!toggled_on):
		data.all_data["playback_pos"] = background_music.get_playback_pos()
		background_music.set_song("", data)
		data.all_data["sound_modifiers"][0] = toggled_on
	else:
		data.all_data["sound_modifiers"][0] = toggled_on
		background_music.set_song(data.all_data["current_song"], data)
	
	master_music.focus_mode = Control.FOCUS_NONE

# random button is pressed
func _on_choose_random_pressed() -> void:
	var new_song: String = data.SONGS.pick_random()
	background_music.set_song(new_song, data)
	data.all_data["current_song"] = new_song
	choose_random.focus_mode = Control.FOCUS_NONE

# volume slider
func _on_volume_value_changed(value: float) -> void:
	background_music.set_volume(value)
	data.all_data["current_volume"] = value
	volume.focus_mode = Control.FOCUS_NONE

# sound
func _on_master_sound_toggled(toggled_on: bool) -> void:
	
	data.all_data["sound_modifiers"][1] = toggled_on
	master_sound.focus_mode = Control.FOCUS_NONE





## Button colors ---------------------------------------------------------------
# updates either score, sound, or text modifier buttons
func update_button(index: int, option_array: Array, item_list: ItemList) -> void:
	# colors
	print(index)
	if (option_array[index]):
		item_list.set_item_custom_fg_color(index, COLOR_ON)
	else:
		item_list.set_item_custom_fg_color(index, COLOR_OFF)
	
	# removes user focus
	item_list.set_focus_mode(0)
	item_list.deselect_all()


# updates all buttons according to scene variable data: score, text, sound, sensitivity
func update_all_buttons():
	for i in data.score_modifiers.size():
		update_button(i, data.all_data["score_modifiers"], score_display)
	for i in data.text_modifiers.size():
		update_button(i, data.all_data["text_modifiers"], text)
	_on_sensitivity_item_clicked(data.all_data["sensitivity"], 0, 0)
	
	master_music.set_pressed_no_signal(data.all_data["sound_modifiers"][0])
	master_sound.set_pressed_no_signal(data.all_data["sound_modifiers"][1])
	volume.set_value_no_signal(data.all_data["current_volume"])
