class_name GameData extends Resource

@export var game_name: String = ""

enum GameMode {
	STUDY,
	SIMILAR,
	BALLOON_BLAST,
	BALLOON_POP
}

@export var current_game_mode: GameMode = GameMode.STUDY


@export var character_set: Dictionary[String, bool] = {
	"Hiragana": true,
	"Katakana": false
}

enum GameCharacterSetMode {
	JAPANESE_TO_ENGLISH,
	ENGLISH_TO_JAPANESE
}

@export var game_character_set_mode: GameCharacterSetMode = GameCharacterSetMode.ENGLISH_TO_JAPANESE

@export var colors: Dictionary[String, Color] = {
	"Red": Color.RED,
	"Blue": Color.BLUE,
	"Green": Color.GREEN,
	"Yellow": Color.YELLOW,
	"Purple": Color.PURPLE,
	"Orange": Color.ORANGE,
	"Pink": Color.PINK,
	"Brown": Color.BROWN
}

func get_game_mode_name():
	match current_game_mode:
		GameMode.STUDY:
			return "Study"
		GameMode.SIMILAR:
			return "Similar"
		GameMode.BALLOON_BLAST:
			return "Balloon Blast"
		GameMode.BALLOON_POP:
			return "Balloon Pop"

func toggle_game_mode():
	if current_game_mode == GameMode.STUDY:
		current_game_mode = GameMode.SIMILAR
	elif current_game_mode == GameMode.SIMILAR:
		current_game_mode = GameMode.BALLOON_BLAST
	elif current_game_mode == GameMode.BALLOON_BLAST:
		current_game_mode = GameMode.BALLOON_POP
	elif current_game_mode == GameMode.BALLOON_POP:
		current_game_mode = GameMode.STUDY

func get_game_mode_description():
	match current_game_mode:
		GameMode.STUDY:
			return "Study mode is when you want to study each kana in order. There are no penalties in Study mode so you can view each kana and memorize the romaji sound that goes with it without a time limit."
		GameMode.SIMILAR:
			return "You will be shown similar looking kana. You must match the correct kana to move to the next round. If you are wrong three times then it will be game over. However you may continue as many times as you want."
		GameMode.BALLOON_BLAST:
			return "Balloon Blast is a game that will release many balloons on each round. Each round you must match the corrent kana a certain amount of times before starting the next round. If you are wrong three times the it will be game over. However you may continue as many times as you want."
		GameMode.BALLOON_POP:
			return "Balloon Pop is a multiple choice game where you must match all the same kana every round. Kana is chosen in order and at the end you will be shown a percentage of how many you got correct. Make a mistake and it will go onto the next kana."
		_:
			return "Unknown game mode."

func toggle_character_set(character_set_name: String):
	character_set[character_set_name] = not character_set[character_set_name]


func save():
	var save_dict = {
		"game_name": game_name,
		"current_game_mode": current_game_mode,
		"character_set": {
			"Hiragana": character_set["Hiragana"],
			"Katakana": character_set["Katakana"]
		}
	}
	return save_dict

func load(save_dict):
	if save_dict.has("game_name"):
		game_name = save_dict["game_name"]
	if save_dict.has("current_game_mode"):
		current_game_mode = save_dict["current_game_mode"]
	if save_dict.has("character_set"):
		character_set["Hiragana"] = save_dict["character_set"]["Hiragana"]
		character_set["Katakana"] = save_dict["character_set"]["Katakana"]
