extends Node2D



## menu button
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

## stats display
# displays all stats
func display_stats() -> void:
	pass

# Maybe there should be buttons where you can disable tracking stats. Yeah...
