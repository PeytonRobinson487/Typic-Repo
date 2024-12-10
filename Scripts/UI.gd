extends Control


# exits the game if the escape key is pressed
func _process(delta):
	if Input.is_action_just_pressed("Escape Game"):
		get_tree().quit()
