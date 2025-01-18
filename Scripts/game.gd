extends Node2D


@onready var user_input = $Text/user_input
@onready var text_maker = $Text/TextMaker
@onready var data: Node2D = $Scripts/Data


# initialization
func _ready() -> void:
	data.load_data()
	text_maker.text = text_maker.generate_text(25, data)
	user_input.grab_focus()


## menu button
# takes the player back to the home page
func _on_button_pressed() -> void:
	data.save_data()
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")


# checks computer displayed text with submitted player text
func _on_user_input_text_changed(new_text: String) -> void:
	var c_text: String = text_maker.text
	
	# check if it matches computer text (c_text)
	var user_letter: String = new_text.substr(0, 1)
	if (c_text.substr(0, 1).similarity(user_letter)):
		print("Right")
		c_text = correct_input(c_text, user_letter, data)
	else:
		print("Wrong")
		wrong_input(user_letter, data)
	
	user_input.text = ""
	update_c_text(c_text)

# scenario where the user inputs a correct character
# returns updated computer text with first letter ommited
func correct_input(computer_text: String, user_letter: String, data: Node2D) -> String:
	# decrement hard character
	if (data.hard_characters.has(user_letter)):
		data.hard_characters[user_letter] -= 1.0
		
		# if below zero, remove hard character and decrement magnitude
		if (data.hard_characters.get(user_letter) < 0.0):
			data.hard_character_magnitude -= data.hard_characters.get(user_letter)
			data.hard_characters.erase(user_letter)
	
	return computer_text.substr(1, computer_text.length())

# scenario where the user inputs an incorrect character
func wrong_input(user_letter: String, data: Node2D) -> void:
	if (data.hard_characters.has(user_letter)):
		# update hard character
		var character_value: float = data.hard_characters.get(user_letter)
		var rand_1 = randf()
		character_value += (character_value * 0.1) + rand_1
		character_value = (character_value * 1.1) + rand_1
		data.hard_characters[user_letter] = character_value
	else:
		# new hard character
		data.hard_characters[user_letter] = 1.0
		data.hard_character_magnitude += 1.0


# updates TextMaker text
func update_c_text(c_text: String) -> void:
	text_maker.text = c_text
	
	const C_TEXT_LENGTH: int = 20
	if (c_text.length() < C_TEXT_LENGTH):
		text_maker.text += text_maker.generate_text(C_TEXT_LENGTH, data)


# keeps user focus on
func _on_user_input_focus_exited() -> void:
	user_input.grab_focus()
