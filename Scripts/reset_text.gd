extends Button

@onready var computer_text = %computer_text


# resets the user textbox
func _on_pressed():
	computer_text.reset_text()
