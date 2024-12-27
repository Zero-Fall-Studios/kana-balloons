extends Node2D

@export var default_transition_out: String = "FadeOut"
@export var default_transition_in: String = "FadeIn"

var current_scene = null
var scene_transitions: Dictionary[String, SceneTransition] = {}

func _ready():
	var root = get_tree().root
	current_scene = root.get_child(-1)
	for child in get_children():
		if child is SceneTransition:
			scene_transitions[child.name] = child

func play_transition(transition_name: String):
	var transition = scene_transitions[transition_name]
	if transition:
		await transition.play()
	
func goto_scene(path: String, transition_out: String = default_transition_out, transition_in: String = default_transition_in):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:
	call_deferred("_deferred_goto_scene", path, transition_out, transition_in)

func _deferred_goto_scene(path, transition_out, transition_in):
	var transition_out_node = scene_transitions[transition_out]
	if transition_out_node:
		await transition_out_node.play()
	
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

	var transition_in_node = scene_transitions[transition_in]
	if transition_in_node:
		await transition_in_node.play()
