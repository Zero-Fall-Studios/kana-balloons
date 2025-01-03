class_name Balloon extends Node2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var label: Label = $Sprite2D/Label
@onready var area_2d: Area2D = $Area2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var speed: float = 100
@export var has_gravity: bool = false
@export var default_label: String = "あ"
@export var rise_limit: Node2D

var current_color: Color
var current_text: String
var current_character
var is_correct: bool
var time_risen: float = 0

func _ready() -> void:
	current_color = GameManager.get_random_color()
	sprite.modulate = current_color
	label.text = default_label

func spawn(correct: bool, gravity: bool = false) -> void:
	is_correct = correct
	has_gravity = gravity
	current_color = GameManager.get_random_color()
	sprite.modulate = current_color
	if is_correct:
		current_character = GameManager.current_character
	else:
		current_character = GameManager.get_random_character()
	if current_character:
		label.text = current_character["front"]
	else:
		label.text = "あ"

func pop() -> void:
	animation_player.play("pop")
	await animation_player.animation_finished
	AudioManager.play_random(["BalloonPop", "BalloonPop2", "BalloonPop3"])
	GameManager.pop(is_correct)
	queue_free()

func _on_area_2d_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property(sprite, "modulate", current_color.lightened(0.3), 0.2)


func _on_area_2d_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property(sprite, "modulate", current_color, 0.2)


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		pop()


func _physics_process(delta: float) -> void:
	if has_gravity:
		position.y -= speed * delta

	if rise_limit:
		if global_position.y < rise_limit.global_position.y:
			has_gravity = false
			speed = 0
