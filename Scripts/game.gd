# Right now, I am fixing how the wrong_answer adds new letters. It adds all characters into the first array right now.
# I need to change it to check if it is in the correct library first, then add it
# I may need to create for functions, or four dictionaries, bruh why.

extends Node2D

@onready var user_input = $Text/user_input
@onready var text_maker = $Text/TextMaker
@onready var data: Node2D = $Scripts/Data
@onready var score_display: RichTextLabel = $"Text/Score Display"


## Variables ---------------------------------------------------------------------------------------

var total_score: int = 0
var current_score: int = 0
var current_accuracy: float = 100.0
var current_wrong: int = 0
var current_correct: int = 0
var current_streak: int = 0

## Functions ---------------------------------------------------------------------------------------
# initialization
func _ready() -> void:
	data.load_data()
	text_maker.text = text_maker.generate_text(24, data)
	display_stats()
	user_input.grab_focus()


## menu button
# takes the player back to the home page
func _on_button_pressed() -> void:
	# update more data variables
	# update average accuracy
	if (data.all_data["total_wrong"] > 0):
		data.all_data["average_accuracy"] = (data.all_data["total_score"] + data.all_data["total_wrong"])
		data.all_data["average_accuracy"] /= data.all_data["total_score"] * 100.0
	
	data.save_data()
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")


# checks computer displayed text with submitted player text
func _on_user_input_text_changed(new_text: String) -> void:
	var c_text: String = text_maker.text
	
	# check if it matches computer text (c_text)
	var user_letter: String = new_text.substr(0, 1)
	if (c_text.substr(0, 1).similarity(user_letter)):
		c_text = correct_input(c_text, user_letter, data)
	else:
		wrong_input(user_letter, data)
	
	display_stats()
	user_input.text = ""
	update_c_text(c_text)

# user inputs a correct character
# returns updated computer text with first letter ommited
func correct_input(computer_text: String, user_letter: String, data: Node2D) -> String:
	# decrement hard character
	var index: int = 0
	for hard_chars in data.all_data["hard_library"]:
		if (hard_chars.has(user_letter) && hard_chars[user_letter] <= 0.0):
			hard_chars.erase(user_letter)
		elif (hard_chars.has(user_letter)):
			hard_chars[user_letter] -= 1.0
		
		data.all_data["hard_library"][index] = hard_chars
		index += 1
	
	# score
	data.all_data["total_correct"] += 1
	data.all_data["total_score"] += 1
	
	total_score += 1
	current_score += 1
	current_streak += 1
	
	if (current_streak > data.all_data["longest_streak"]):
		data.all_data["longest_streak"] = current_streak
	if (current_wrong > 0):
		current_accuracy = (current_correct + current_wrong) / total_score * 100.0
	
	return computer_text.substr(1, computer_text.length())

# user inputs an incorrect character
func wrong_input(user_letter: String, data: Node2D) -> void:
	var index: int = 0
	for hard_chars in data.all_data["hard_library"]:
		if (hard_chars.has(user_letter)):
			hard_chars[user_letter] += 1.0 + randf() / 2.0
		else:
			hard_chars[user_letter] = 1.0
	
	# score
	data.all_data["total_score"] += 1
	data.all_data["total_wrong"] += 1
	
	total_score += 1
	current_wrong += 1
	current_streak = 0
	
	if (current_wrong > 0):
		current_accuracy = (current_correct + current_wrong) / (total_score * 100.0)


# updates TextMaker text
func update_c_text(c_text: String) -> void:
	text_maker.text = c_text
	
	const C_TEXT_LENGTH: int = 20
	if (c_text.length() < C_TEXT_LENGTH):
		text_maker.text += text_maker.generate_text(C_TEXT_LENGTH, data)


# keeps user focus on
func _on_user_input_focus_exited() -> void:
	user_input.grab_focus()


# displays stats about the user
func display_stats():
	var score_mods = data.all_data["score_modifiers"]
	
	var new_text: String = ""
	if (score_mods[0]): new_text += "Correct: " + str(current_score) + "\n"
	if (score_mods[1]): new_text += "Missed: " + str(current_wrong) + "\n"
	if (score_mods[2]): new_text += "Accuracy: " + str(current_accuracy) + "%\n"
	if (score_mods[3]): new_text += "Streak: " + str(current_streak) + "\n"
	if (score_mods[4]): new_text += display_hard_chars()
	
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
	var sorted_hard_chars: Array
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
		var index: int = 1
		while (index < new_array.size() - 3 && new_array[index] > hard_chars[key]):
			index += 2
		
		new_array.insert(index - 1, hard_chars[key])
		new_array.insert(index - 1, key)
	
	return new_array
