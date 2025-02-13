extends Node2D


@onready var user_input: LineEdit = $Buttons/user_input
@onready var page_list = $"Buttons/page list"
@onready var background_music: Node2D = $AudioManager
@onready var data: Node2D = $Data


# init
func _ready() -> void:
	data.load_data()
	user_input.grab_focus()
	
	background_music.set_volume(0)
	background_music.set_song(data.all_data["current_song"], data)
	background_music.set_volume(data.all_data["current_volume"])


# user enters text
func _on_user_input_text_submitted(new_text: String) -> void:
	# main scenes
	var two_letters: String = new_text.substr(0, 2).to_lower()
	if (two_letters == "pl"):
		_on_page_list_item_clicked(0, 0, 0)
	elif (two_letters == "se"):
		_on_page_list_item_clicked(1, 0, 0)
	elif (two_letters == "sc"):
		_on_page_list_item_clicked(2, 0, 0)
	elif (two_letters == "qu"):
		_on_page_list_item_clicked(3, 0, 0)
	else:
		# custom input
		custom_input(new_text)

# responds to various inputs from the user
func custom_input(new_text: String) -> void:
	user_input.text = ""
	if (new_text == "TYPIC"):
		user_input.placeholder_text = "YES. THIS IS TYPIC."
	elif (new_text == "HI"):
		user_input.placeholder_text = "HEY"
	elif (new_text.to_lower() == "typic"):
		user_input.placeholder_text = "You are playing as we speak."
	elif (new_text.to_lower() == "hi" ||
			new_text.to_lower() == "hello" ||
			new_text.to_lower() == "hoi" ||
			new_text.to_lower() == "hey" ||
			new_text.to_lower() == "yo"):
		
		var rand: int = randi() % 3
		if (rand == 0):
			user_input.placeholder_text = "Hi! How are you?"
		elif (rand == 1):
			user_input.placeholder_text = "Hey! How have you been?"
		elif (rand == 2):
			user_input.placeholder_text = "Greetings, Sire. The desert--awaits."
	elif (new_text.to_lower() == "no"):
		user_input.placeholder_text = "Yes"
	elif (new_text.to_lower() == "yes"):
		user_input.placeholder_text = "No"
	elif (new_text.to_lower() == "whats up" ||
			new_text.to_lower() == "what's up" ||
			new_text.to_lower() == "wut up" ||
			new_text.to_lower() == "wuz up" ||
			new_text.to_lower() == "what up"):
		
		var rand: int = randi() % 100
		if (rand <= 50):
			user_input.placeholder_text = "How's it goin?"
		elif (rand > 50):
			user_input.placeholder_text = "Yo. How's it goin?"
	elif (new_text.substr(0, 1).to_lower() == "r"):
		for i in randi() % 10:
			user_input.placeholder_text = data.libraries[randi() % 4].pick_random()
	elif (new_text.length() == 0):
		user_input.placeholder_text = "You did not even type anything."
	elif (new_text.substr(0, 3).to_lower() == "who"):
		user_input.placeholder_text = "I am the sub-machine."
	elif (new_text.substr(0, 1) == "?"):
		for i in new_text.length():
			user_input.placeholder_text += "!"
	elif (new_text.substr(0, 1) == "!"):
		for i in new_text.length():
			user_input.placeholder_text += "?"
	elif (new_text.substr(0, 1) == " "):
		user_input.placeholder_text = ". . ."
	elif (new_text == ":)"):
		user_input.placeholder_text = "=]"
	else:
		var rand: int = randi() % 13
		if (rand >= 3):
			user_input.placeholder_text = "Unknown page."
		elif (rand == 0):
			user_input.placeholder_text = "What?"
		elif (rand == 1):
			user_input.placeholder_text = "Huh?"
		elif (rand == 2):
			user_input.placeholder_text = "Try again."
	
	user_input.placeholder_text = " " + user_input.placeholder_text


# changes placeholder text if the user types
func _on_user_input_text_changed(_new_text: String) -> void:
	user_input.placeholder_text = " Type the page here"


func _on_page_list_item_clicked(index, _at_position, _mouse_button_index):
	data.all_data["playback_pos"] = background_music.get_playback_pos()
	data.save_data()
	match index:
		0:
			get_tree().change_scene_to_file("res://Scenes/game.tscn")
		1:
			get_tree().change_scene_to_file("res://Scenes/settings.tscn")
		2: 
			get_tree().change_scene_to_file("res://Scenes/score.tscn")
		3:
			data.all_data["playback_pos"] = 0.0
			data.save_data()
			get_tree().quit()
		'_':
			print("Did not click any buttons.");
			get_tree().quit()
