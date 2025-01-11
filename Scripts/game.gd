extends Node2D


## menu button
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")


## game functions
func _process(delta):
	pass;


# initialization - more than just "_ready()"
func _enter_tree():
	pass
