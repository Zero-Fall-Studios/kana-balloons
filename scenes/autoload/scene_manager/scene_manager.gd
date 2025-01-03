extends Node2D

@export var initial_transition: String = "Brand"
@export var default_transition: String = "Fade"

var current_scene = null
var scene_transitions: Dictionary[String, SceneTransition] = {}

func _ready():
	var root = get_tree().root
	current_scene = root.get_child(-1)
	for child in get_children():
		if child is SceneTransition:
			scene_transitions[child.name] = child
	if initial_transition:
		var transition = scene_transitions[initial_transition]
		if transition:
			await transition.play()
	
func goto_scene(path: String, transition_name: String = default_transition):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:
	call_deferred("_deferred_goto_scene", path, transition_name)

func _deferred_goto_scene(path, transition_name):
	var transition = scene_transitions[transition_name]
	if transition:
		await transition.transition_in()
	
	# It is now safe to remove the current scene
	current_scene.free()

	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instantiate()

	# Add it to the active scene, as child of root.
	get_tree().root.add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene_to_file() API.
	get_tree().current_scene = current_scene

	if transition:
		await transition.transition_out()
