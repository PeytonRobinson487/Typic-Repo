extends Node2D

# Reference to the AnimationPlayer node
@onready var anim_player: AnimationPlayer = $SceneTransitionRect/anim_player
const WAIT_TIME: float = 0.175

# fades out of the scene
func scene_fade_out() -> void:
	anim_player.play("fade_transition")
	await anim_player.animation_finished

# fades into the scene
func scene_fade_in() -> void:
	anim_player.play_backwards("fade_transition")
	await anim_player.animation_finished
