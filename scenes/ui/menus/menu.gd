class_name Menu extends Node2D

@export var animation_name_in: String = "fade_in"
@export var animation_name_out: String = "fade_out"

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func show_menu():
	animation_player.play(animation_name_in)
	await animation_player.animation_finished

func hide_menu():
	animation_player.play(animation_name_out)
	await animation_player.animation_finished
