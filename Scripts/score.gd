extends Node2D

@onready var data: Node2D = $Data

## -------------------------------------------------------------------------------------------------
# initialization
func _ready() -> void:
	data.load_data()

# deconstructor
func _exit_tree() -> void:
	data.save_data()

## menu button
func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

# resets stats
func _on_clear_stats_pressed() -> void:
	data.reset_data()
	data.load_data()


### Stats functions --------------------------------------------------------------------------------
## stats display
# displays all stats
func display_stats() -> void:
	pass

# Maybe there should be buttons where you can disable tracking stats. Yeah...
