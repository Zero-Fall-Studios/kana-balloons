extends Node

signal show_main_menu
signal show_game_mode_menu
signal show_game_mode_info
signal show_options_menu
signal show_credits_menu
signal start_game
signal toggle_game_mode
signal default

func get_signal(signal_name: String):
	match signal_name:
		"show_game_mode_menu":
			return show_game_mode_menu
		"show_game_mode_info":
			return show_game_mode_info
		"show_options_menu":
			return show_options_menu
		"show_main_menu":
			return show_main_menu
		"show_credits_menu":
			return show_credits_menu
		"start_game":
			return start_game
		"toggle_game_mode":
			return toggle_game_mode
	return default
