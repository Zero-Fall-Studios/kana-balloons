class_name SceneTransition extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var animation_name: String

func play():
	animation_player.play(animation_name)
	await animation_player.animation_finished
	animation_player.play("RESET")