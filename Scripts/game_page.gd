## CLASS DESCRIPTION
# the game where the player enters text based on the
#	output generated from the computer
# The score is displayed in the top left corner
# the text is generated using text_maker_tool.gd

extends Node2D

## Variables ---------------------------------------------------------------------------------------
## OnReady
# data - - -
@onready var data: Node2D = $Data

# audio - - -
@onready var audio_manager_tool: Node2D = $"Audio Manager Tool"

# graphics - - -
@onready var scene_transition_tool: Node2D = $"Graphics/Scene Transition Tool"

# gameplay - - -
# where the user inputs text
@onready var user_input: LineEdit = $"Graphics/User Input"
# the computer generated text
@onready var text_maker: RichTextLabel = $"Graphics/Text Maker"
# displays live player stats
@onready var score_display: RichTextLabel = $"Graphics/Score Display"


## Dynamic
# correct and wrong score combined
var total_score: int = 0
# total wrong character count
var current_wrong: int = 0
# total correct character count
var current_correct: int = 0
# accuracy based on correct and total scores
var current_accuracy: float = 100.0
# current correct character count streak
var current_streak: int = 0
# longest correct character count streak in this game
var current_longest_streak: int = 0


## Functions ---------------------------------------------------------------------------------------
## Initialization
# constructor
func _ready() -> void:
	data.load_data()
	text_maker.text = text_maker.generate_text(24, data)
	display_stats()
	user_input.grab_focus()
	
	# initialize sound and play scene transition
	audio_manager_tool.play_music(data.all_data["current_song_index"], data.all_data["sound_modifiers"][0], data.all_data["music_playback_pos"])
	audio_manager_tool.set_volume(linear_to_db(data.all_data["current_volume"] / 100.0))
	$"Graphics/Background/Animation Player".play("pop_in")
	$"Graphics/Transition/Animation Player".play_backwards("fade")
	
	$"Graphics/User Input/GPUParticles2D".amount = 1

# deconstructor
func _on_menu_button_pressed() -> void:
	# play sound and scene transition
	$"Graphics/Background/Animation Player".play_backwards("pop_in")
	$"Graphics/Transition/Animation Player".play("fade")
	audio_manager_tool.play_sound(1, data.all_data["sound_modifiers"][1])
	await get_tree().create_timer(0.3).timeout
	
	# update more data variables
	if (data.all_data["total_wrong"] > 0):
		data.all_data["average_accuracy"] = (float(data.all_data["total_correct"]) / float(data.all_data["total_score"])) * 100.0
	data.update_level()
	data.all_data["music_playback_pos"] = audio_manager_tool.get_music_playback_pos()
	data.save_data()
	
	get_tree().change_scene_to_file("res://Scenes/Menu Page.tscn")


## gameplay interaction
# checks computer displayed text with submitted player text
func _on_user_input_text_changed(new_text: String) -> void:
	# check if it matches computer text (c_text)
	var user_letter: String = new_text.substr(0, 1)
	var c_text: String = text_maker.text
	if (c_text.substr(0, 1).similarity(user_letter)):
		c_text = correct_input(c_text, user_letter, data)
	else:
		wrong_input(c_text.substr(0, 1), data)
	
	# update accuracy
	if (current_wrong > 0):
		current_accuracy = (float(current_correct) / float(total_score)) * 100.0
	
	display_stats()
	user_input.text = ""
	
	text_maker.text = c_text
	const C_TEXT_LENGTH: int = 20
	if (text_maker.text.length() < C_TEXT_LENGTH):
		text_maker.text += text_maker.generate_text(C_TEXT_LENGTH, data)

# user inputs a correct character
# returns updated computer text with first letter ommited
func correct_input(computer_text: String, user_letter: String, data: Node2D) -> String:
	$"Graphics/User Input/GPUParticles2D".amount = 5
	$"Graphics/Text Maker/Animation Player".play("correct")
	
	# decrement hard character
	var index: int = 0
	for hard_chars in data.all_data["hard_library"]:
		if (hard_chars.has(user_letter) && hard_chars[user_letter] <= 0.0):
			hard_chars.erase(user_letter)
		elif (hard_chars.has(user_letter)):
			hard_chars[user_letter] -= 1.0
		
		data.all_data["hard_library"][index] = hard_chars
		index += 1
	
	# update score
	data.all_data["total_correct"] += 1
	data.all_data["total_score"] += 1
	
	total_score += 1
	current_correct += 1
	current_streak += 1
	
	if (current_streak > current_longest_streak):
		current_longest_streak = current_streak
	if (current_streak > data.all_data["longest_streak"]):
		data.all_data["longest_streak"] = current_streak
	
	return computer_text.substr(1, computer_text.length())

# user inputs an incorrect character
func wrong_input(c_text: String, data: Node2D) -> void:
	$"Graphics/User Input/GPUParticles2D".amount = 1
	$"Graphics/Text Maker/Animation Player".play("wrong")
	
	# update the hard character libraries
	var index: int = 0
	while (index < data.libraries.size()):
		var hard_chars = data.all_data["hard_library"][index]
		if (hard_chars.has(c_text)):
			hard_chars[c_text] += data.all_data["sensitivity"] + randf() / 2.0
			if (hard_chars[c_text] > data.CHAR_MAGNITUDE_CAP):
				hard_chars[c_text] = data.CHAR_MAGNITUDE_CAP
		elif (data.libraries[index].has(c_text)):
			hard_chars[c_text] = 1.0
		
		data.all_data["hard_library"][index] = hard_chars
		index += 1
	
	# score
	data.all_data["total_score"] += 1
	data.all_data["total_wrong"] += 1
	
	total_score += 1
	current_wrong += 1
	current_streak = 0

# keeps user focus on
func _on_user_input_focus_exited() -> void:
	user_input.grab_focus()


## Text UI
# displays stats about the user
func display_stats():
	var score_mods = data.all_data["score_modifiers"]
	
	var new_text: String = ""
	if (score_mods[0]): new_text += "Total: " + str(total_score) + "\n"
	if (score_mods[1]): new_text += "Correct: " + str(current_correct) + "\n"
	if (score_mods[2]): new_text += "Missed: " + str(current_wrong) + "\n"
	if (score_mods[3]): new_text += "Accuracy: " + str(round(current_accuracy * 10) / 10.0) + "%\n"
	if (score_mods[4]):
		new_text += "Streak: " + str(current_streak) + "\n"
		new_text += "Current longest: " + str(current_longest_streak) + "\n"
	if (score_mods[5]): new_text += display_hard_chars()
	
	score_display.text = new_text

# displays the hard text to the screen
func display_hard_chars() -> String:
	# extract all relevant characters
	var all_hard_chars: Dictionary = {}
	for index in data.all_data["hard_library"].size():
		if (data.all_data["text_modifiers"][index]):
			all_hard_chars.merge(data.all_data["hard_library"][index])
	
	if (all_hard_chars.size() == 0):
		return "Hard text: []\n"
	
	# sort chars
	var sorted_hard_chars: Array = []
	for key in all_hard_chars:
		sorted_hard_chars = insertion_sort(all_hard_chars)
	
	# get only characters out of the array
	var new_text: String = "Hard text: ["
	var index: int = 0
	while (index < sorted_hard_chars.size() - 2 && index < 8):
		new_text += sorted_hard_chars[index] + ", "
		index += 2
	
	return new_text + sorted_hard_chars[index] + "]\n"

# insertion sort using an array and dictionary
func insertion_sort(hard_chars: Dictionary) -> Array:
	var new_array: Array = []
	for key in hard_chars:
		new_array.push_back(key)
		new_array.push_back(hard_chars[key])
		
		var index: int = new_array.size() - 1
		while (index > 1 && new_array[index] > new_array[index - 2]):
			# swap
			var value_temp: float = new_array[index]
			var key_temp: String = new_array[index - 1]
			new_array[index] = new_array[index - 2]
			new_array[index - 1] = new_array[index - 3]
			new_array[index - 2] = value_temp
			new_array[index - 3] = key_temp
			index -= 2
	
	return new_array
