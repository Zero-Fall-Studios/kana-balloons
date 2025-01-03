extends Node

@export var initial_menu: String = "MainMenu"
@export var initial_menu_start_time: float = 0.0

@export var game_mode_button: Button
@export var game_mode_label: Label
@export var game_mode_description: Label

@export var hiragana_check_button: CheckButton
@export var katakana_check_button: CheckButton

var menus: Dictionary[String, Node] = {}
var menu_stack: Array[String] = []

func _ready() -> void:
	for child in get_children():
		if child is Menu:
			menus[child.name] = child
	if initial_menu:
		await get_tree().create_timer(initial_menu_start_time).timeout
		push(initial_menu)
	if game_mode_button:
		game_mode_button.text = GameManager.game_data.get_game_mode_name()
	if hiragana_check_button and GameManager.game_data.character_set["Hiragana"]:
		hiragana_check_button.set_pressed_no_signal(true)
	if katakana_check_button and GameManager.game_data.character_set["Katakana"]:
		katakana_check_button.set_pressed_no_signal(true)
	disable_check_buttons()

func push(menu_name: String):
	if menu_stack.size() > 0:
		await transition_away_out(menu_stack.back())
	menu_stack.append(menu_name)
	await transition_in(menu_name)

func pop():
	var prev_menu_size = menu_stack.size()
	var menu_name = menu_stack.pop_back()
	await transition_out(menu_name)
	if prev_menu_size > 1:
		await transition_away_in(menu_stack.back())
		
func pop_all():
	var menu_name = menu_stack.pop_back()
	await transition_out(menu_name)
	menu_stack.clear()

func transition_in(menu_name: String):
	await menus[menu_name].transition_in()

func transition_out(menu_name: String):
	await menus[menu_name].transition_out()

func transition_away_in(menu_name: String):
	await menus[menu_name].transition_away_in()

func transition_away_out(menu_name: String):
	await menus[menu_name].transition_away_out()

func _on_back_button_pressed() -> void:
	pop()

func _on_credits_button_pressed() -> void:
	push("CreditsMenu")

func _on_play_button_pressed() -> void:
	push("GameModeMenu")

func _on_start_game_button_pressed() -> void:
	var scene_path = ""
	match GameManager.game_data.current_game_mode:
		GameData.GameMode.BALLOON_BLAST:
			scene_path = "res://scenes/game_modes/balloon_blast.tscn"
		GameData.GameMode.BALLOON_POP:
			scene_path = "res://scenes/game_modes/balloon_pop.tscn"
		GameData.GameMode.SIMILAR:
			scene_path = "res://scenes/game_modes/similar.tscn"
		GameData.GameMode.STUDY:
			scene_path = "res://scenes/game_modes/study.tscn"
	await pop_all()
	await SceneManager.goto_scene(scene_path)

func _on_settings_button_pressed() -> void:
	push("SettingsMenu")

func _on_game_mode_button_pressed() -> void:
	GameManager.game_data.toggle_game_mode()
	if game_mode_button:
		game_mode_button.text = GameManager.game_data.get_game_mode_name()


func _on_info_button_pressed() -> void:
	game_mode_label.text = GameManager.game_data.get_game_mode_name()
	game_mode_description.text = GameManager.game_data.get_game_mode_description()
	push("GameModeInfoMenu")


func _on_hiragana_check_button_toggled(_toggled_on: bool) -> void:
	GameManager.toggle_character_set("Hiragana")
	disable_check_buttons()
	

func _on_katakana_check_button_toggled(_toggled_on: bool) -> void:
	GameManager.toggle_character_set("Katakana")
	disable_check_buttons()

func disable_check_buttons():
	hiragana_check_button.disabled = GameManager.game_data.character_set["Hiragana"] and not GameManager.game_data.character_set["Katakana"]
	katakana_check_button.disabled = GameManager.game_data.character_set["Katakana"] and not GameManager.game_data.character_set["Hiragana"]
