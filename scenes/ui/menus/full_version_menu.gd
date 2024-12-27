extends Control
class_name FullVersionMenu

@onready var animation_player : AnimationPlayer = $AnimationPlayer

func _ready():
	hide()
	
func fade_in():
	animation_player.play("MoveIn")

func fade_out():
	animation_player.play("MoveOut")

func _on_button_back_pressed():
	fade_out()
