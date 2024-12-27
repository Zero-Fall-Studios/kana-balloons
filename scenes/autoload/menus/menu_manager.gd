extends Node

@export var default_menu: String = "MainMenu"

var menus: Dictionary[String, Node] = {}

func _ready() -> void:
	for child in get_children():
		if child is Menu:
			menus[child.name] = child
	show_menu(default_menu)

func show_menu(menu_name: String):
	if not menus.has(menu_name):
		return
	await menus[menu_name].show_menu()

func hide_menu(menu_name: String):
	if not menus.has(menu_name):
		return
	await menus[menu_name].hide_menu()
