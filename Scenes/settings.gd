extends Node2D


## menu button
func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")


## settings buttons
