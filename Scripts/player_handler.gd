extends Node


@onready var data = $Data


func update_level(experience: float) -> float:
	# equation: sqrt(x)
	if (experience > sqrt(data.all_data["player_level"])):
		experience -= sqrt(data.all_data["player_level"] * 1.0)
		data.all_data["player_level"] += 1
	return experience
