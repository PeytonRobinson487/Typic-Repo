extends Label

var character_frequency: Dictionary

# initializes the text display
func _ready():
	visible = true


# sorts dictionaries
func sort_dict(dict: Dictionary) -> Dictionary:
	var pairs = dict.keys().map(func (key): return [dict[key], key])
	pairs.sort()
	dict.clear()
	for p in pairs:
		dict[p[1]] = p[0]
	return dict


func add_key(_key: String, _value: int):
	character_frequency[_key] = _value


func increment_key_value(_key: String, new_value: int):
	character_frequency[_key] += new_value


func divide_key_value(_key: String, denominator: int):
	character_frequency[_key] /= denominator


func has_character(user_text: String):
	if character_frequency.has(user_text):
		return true
	return false


func display_hard_char():
	self.text = ""
	
	character_frequency = sort_dict(character_frequency)
	var pairs = character_frequency.keys().map(func (key): return [key, character_frequency[key]])
	
	var i: int = pairs.size() - 1
	while i >= 0:
		self.text += str(pairs[i][0])
		i -= 1
