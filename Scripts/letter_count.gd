extends Label

var total_letter_count: int
var correct_letter_count: int
var wrong_letter_count: int


# public constructor
func initialize_counts(text_parameter: String = "", total_count_parameter: int = 0, correct_count_parameter: int = 0, wrong_count_parameter: int = 0):
	self.text = text_parameter
	total_letter_count = total_count_parameter
	correct_letter_count = correct_count_parameter
	wrong_letter_count = wrong_count_parameter


# adds the count to one of the following types of counts: total, correct, and wrong
func add_count(count_type: String, amount: int):
	if count_type == "total":
		total_letter_count += amount
	elif count_type == "correct":
		correct_letter_count += amount
	elif count_type == "wrong":
		wrong_letter_count += amount
	else:
		print("Error. Did not enter correct count_type. Please enter:\n\"total\"\n\"correct\"\n\"wrong\"")


# displays the letter counts at the bottom of the screen
func display_letter_counts():
	self.text = str(total_letter_count) + ": Total\n"
	self.text += str(correct_letter_count) + ": Correct\n"
	self.text += str(wrong_letter_count) + ": Wrong"
