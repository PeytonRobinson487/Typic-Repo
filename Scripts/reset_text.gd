extends Button

@onready var computer_text = %computer_text

func _on_pressed():
	computer_text.reset_text()
