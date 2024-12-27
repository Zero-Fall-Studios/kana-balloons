extends Node2D

var current_menu: String = "MainMenu"
var previous_menu: String = "MainMenu"

enum GameMode {
	STUDY,
	SIMILAR,
	BALLOON_BLAST,
	BALLOON_POP
}

var current_game_mode: GameMode = GameMode.STUDY

func _ready():
	await SceneManager.play_transition("Brand")
	await MenuManager.show_menu("MainMenu")
	SignalBus.show_main_menu.connect(_on_show_main_menu)
	SignalBus.show_game_mode_menu.connect(_on_show_game_mode_menu)
	SignalBus.show_game_mode_info.connect(_on_show_game_mode_info)
	SignalBus.show_options_menu.connect(_on_show_options_menu)
	SignalBus.show_credits_menu.connect(_on_show_credits_menu)
	SignalBus.start_game.connect(_on_start_game)
	SignalBus.toggle_game_mode.connect(_on_toggle_game_mode)
	
func _goto_menu(menu: String):
	previous_menu = current_menu
	current_menu = menu
	await MenuManager.hide_menu(previous_menu)
	await MenuManager.show_menu(current_menu)

func _on_show_main_menu():
	_goto_menu("MainMenu")

func _on_show_game_mode_menu():
	_goto_menu("GameModeMenu")

func _on_show_game_mode_info():
	_goto_menu("GameModeInfoMenu")

func _on_show_options_menu():
	_goto_menu("OptionsMenu")

func _on_show_credits_menu():
	_goto_menu("CreditsMenu")

func _on_start_game():
	await MenuManager.hide_menu(current_menu)
	await SceneManager.goto_scene("res://scenes/game_modes/balloon_blast.tscn", "BalloonRising")

func _on_toggle_game_mode():
	if current_game_mode == GameMode.STUDY:
		current_game_mode = GameMode.SIMILAR
	elif current_game_mode == GameMode.SIMILAR:
		current_game_mode = GameMode.BALLOON_BLAST
	elif current_game_mode == GameMode.BALLOON_BLAST:
		current_game_mode = GameMode.BALLOON_POP
	elif current_game_mode == GameMode.BALLOON_POP:
		current_game_mode = GameMode.STUDY
