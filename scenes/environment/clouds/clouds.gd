extends Sprite2D

@export var speed: = 200  # Adjust the speed value as needed
@export  var start_position_node: Node2D
@export  var end_position_node: Node2D

var start_position: Vector2
var end_position: Vector2
var distance: float
var direction: Vector2
var velocity: Vector2

func _ready():
	start_position = start_position_node.position
	end_position = end_position_node.position

func _physics_process(delta: float):

	if global_position.x < end_position.x:
		global_position.x = start_position.x
		
	global_position.x = global_position.x + speed * delta
