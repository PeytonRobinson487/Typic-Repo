extends Node


@onready var data = $Data


func update_level(experience: float) -> float:
	# equation: sqrt(x)
	if (experience > sqrt(data.player_level)):
		experience -= sqrt(data.player_level)
		data.player_level += 1
	return experience
