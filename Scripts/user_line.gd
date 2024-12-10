extends LineEdit


# constructor
func _ready():
	self.text = ""


# set's the user text to a string
func set_user_text(text: String):
	self.text = text
