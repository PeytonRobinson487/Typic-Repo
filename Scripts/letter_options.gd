extends ItemList

@onready var computer_text = %computer_text

# holds index and value for each button
var items: Array = [true, true, true, true, false]
const GREEN: Color = Color(0, 0.25, 0.1)
const RED: Color = Color(0.25, 0, 0.1)

func _ready():
	for i in items.size() - 1:
		self.set_item_custom_bg_color(i, GREEN)
	self.set_item_custom_bg_color(4, RED)


func _on_multi_selected(index, selected):
	# check that not all buttons are false
	if get_buttons_false() == 3 && items[index] == true:
		return
	# change button state
	items[index] = !items[index]
	
	# change button color
	if items[index]:
		self.set_item_custom_bg_color(index, GREEN)
	elif !items[index]:
		self.set_item_custom_bg_color(index, RED)
	
	# reset computer text
	if items[4] == true:
		computer_text.reset_text()


func get_item_value(item_index: int) -> bool:
	return items[item_index]


func get_buttons_false() -> int:
	var buttons_false: int = 0
	for button in items.size():
		if items[button] == false && button != 4:
			buttons_false += 1
	return buttons_false
