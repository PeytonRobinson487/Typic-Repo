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
	text_maker.text = text_maker.generate_text(25, data)
	display_stats()
	user_input.grab_focus()


## menu button
# takes the player back to the home page
func _on_button_pressed() -> void:
	# update more data variables
	if (data.total_wrong > 0): data.average_accuracy = (data.total_score + data.total_wrong) / data.total_score * 100
	
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
	if (data.hard_characters.has(user_letter)):
		data.update_hard_char_magnitude(user_letter, -1.0)
		
		# if below zero, remove hard character and decrement magnitude
		if (data.get_hard_char_magnitude(user_letter) <= 0.0):
			var char_index: int = data.return_hard_char_index(user_letter)
			data.hard_characters.remove_at(char_index)
			data.hard_characters.remove_at(char_index)
	
	# score
	data.total_correct += 1
	data.total_score += 1
	
	total_score += 1
	current_score += 1
	current_streak += 1
	
	if (current_streak > data.longest_streak): data.longest_streak = current_streak
	if (current_wrong > 0): current_accuracy = (current_correct + current_wrong) / total_score * 100
	
	return computer_text.substr(1, computer_text.length())

# user inputs an incorrect character
func wrong_input(user_letter: String, data: Node2D) -> void:
	if (data.hard_characters.has(user_letter)):
		# update hard character
		var character_value: float = data.get_hard_char_magnitude(user_letter)
		var magnitude = 1 + randf() / 5
		data.update_hard_char_magnitude(user_letter, magnitude);
	else:
		# new hard character
		data.hard_characters.push_back(user_letter)
		data.hard_characters.push_back(1.0)
	
	# score
	data.total_score += 1
	data.total_wrong += 1
	
	total_score += 1
	current_wrong += 1
	current_streak = 0
	
	if (current_wrong > 0): current_accuracy = (current_correct + current_wrong) / total_score * 100


# updates TextMaker text
func update_c_text(c_text: String) -> void:
	text_maker.text = c_text
	
	const C_TEXT_LENGTH: int = 20
	if (c_text.length() < C_TEXT_LENGTH):
		text_maker.text += text_maker.generate_text(C_TEXT_LENGTH, data)


# keeps user focus on
func _on_user_input_focus_exited() -> void:
	user_input.grab_focus()


func display_stats():
	# Display
	# 0 - current_score_displayed
	# 1 - missed_characters_displayed
	# 2 - correct_characters_displayed
	# 3 - hard_text_displayed
	
	var new_text: String = ""
	if (data.score_modifiers[0]): new_text += "Correct: " + str(current_score) + "\n"
	if (data.score_modifiers[1]): new_text += "Missed: " + str(current_wrong) + "\n"
	if (data.score_modifiers[2]): new_text += "Accuracy: " + str(current_accuracy) + "%\n"
	if (data.score_modifiers[3]): new_text += "Streak: " + str(current_streak) + "\n"
	if (data.score_modifiers[4] && data.hard_characters.size() > 0):
		new_text += "Hard text: ["
		var index: int = 0
		while ((index <= 6) && (index < data.hard_characters.size() - 3)):
			new_text += str(data.hard_characters[index]) + ", "
			index += 2
		
		# only display 5 characters
		if (index < 8): new_text += data.hard_characters[data.hard_characters.size() - 2] + "]\n"
		elif (index == 8): new_text += data.hard_characters[index] + "...]\n"
	elif (data.score_modifiers[4] && data.hard_characters.size() == 0):
		new_text += "Hard text: []\n"
	
	if (new_text.length() > 0):
		score_display.text = new_text
		pass
