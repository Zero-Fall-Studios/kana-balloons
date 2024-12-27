extends Node2D

@export var color : Color
@export var text : String

@onready var sprite : Sprite2D = $Sprite2D
@onready var label : Label = $Sprite2D/Label

func _ready():
	sprite.modulate = color
	label.text = text
