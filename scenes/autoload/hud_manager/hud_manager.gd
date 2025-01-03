extends Node2D

@export var character_label: Label

func _ready() -> void:
	GameManager.character_chosen.connect(on_character_chosen)

func on_character_chosen(character):
	print("HUD Manager: ", character)
	if character:
		character_label.text = character["back"]

func _on_pause_button_pressed() -> void:
	print("pause button")
