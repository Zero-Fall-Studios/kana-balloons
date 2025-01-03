extends Node2D

@export var MenuManager: Node

func _ready():
	await SceneManager.play_transition("Brand")
	await MenuManager.push("MainMenu")
