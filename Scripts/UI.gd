extends Control


func _process(delta):
	if Input.is_action_just_pressed("Escape Game"):
		get_tree().quit()
