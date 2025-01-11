extends Node2D


@onready var rich_text_label = $Text/RichTextLabel
@onready var user_input = $Text/user_input


## menu button
# takes the player back to the home page
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")


# checks computer displayed text with submitted player text
func _on_user_input_text_changed(new_text: String) -> void:
	var c_text: String = rich_text_label.text
	
	# check if it matches computer text (c_text)
	if (c_text.substr(0, 1).similarity(new_text.substr(0, 1))):
		c_text.erase(0, 1)
	
	update_c_text(c_text)
	pass


func update_c_text(c_text: String) -> void:
	
	rich_text_label.text = c_text


# initialization - reusable unlike "_ready()"
func _enter_tree() -> void:
	pass
