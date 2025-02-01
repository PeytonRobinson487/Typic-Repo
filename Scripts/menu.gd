extends Node2D


@onready var user_input: LineEdit = $Buttons/user_input
@onready var page_list = $"Buttons/page list"


# init
func _ready() -> void:
	user_input.grab_focus()


# user enters text
func _on_user_input_text_submitted(new_text: String) -> void:
	# main scenes
	var two_letters: String = new_text.substr(0, 2).to_lower()
	if (two_letters == "pl"):
		get_tree().change_scene_to_file("res://Scenes/game.tscn")
	elif (two_letters == "se"):
		get_tree().change_scene_to_file("res://Scenes/settings.tscn")
	elif (two_letters == "sc"):
		get_tree().change_scene_to_file("res://Scenes/score.tscn")
	elif (two_letters == "qu"):
		get_tree().quit()
	else:
		# custom input
		user_input.text = ""
		if (new_text == "TYPIC"):
			user_input.placeholder_text = "YES. THIS IS TYPIC."
		elif (new_text.to_lower() == "typic"):
			user_input.placeholder_text = "You are playing as we speak."
		else:
			user_input.placeholder_text = "Unknown page."


# changes placeholder text if the user types
func _on_user_input_text_changed(new_text: String) -> void:
	user_input.placeholder_text = "Type the page here"


func _on_page_list_item_clicked(index, at_position, mouse_button_index):
	match index:
		0: get_tree().change_scene_to_file("res://Scenes/game.tscn")
		1: get_tree().change_scene_to_file("res://Scenes/settings.tscn")
		2: get_tree().change_scene_to_file("res://Scenes/score.tscn")
		3: get_tree().quit()
		'_':
			print("Did not click any buttons.");
			get_tree().quit()
