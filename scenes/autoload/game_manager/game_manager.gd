extends Node

var save_file_path = "user://save/"
var save_file_name = "GameData.tres"

var game_data: GameData = GameData.new()

var character_sets = {
	"Hiragana": {
		"items": []
	},
	"Katakana": {
		"items": []
	}
}

var current_character

signal character_chosen(character)
signal balloon_popped(correct: bool)

func _ready():
	verify_save_dir(save_file_path)
	if not FileAccess.file_exists(save_file_path + save_file_name):
		save_game_data()
	load_game_data()
	load_character_sets()

func verify_save_dir(path):
	DirAccess.make_dir_absolute(path)
	
func save_game_data():
	var file = FileAccess.open(save_file_path + save_file_name, FileAccess.WRITE)
	var json_string = JSON.stringify(game_data.save())
	file.store_string(json_string)
	file.close()

func load_game_data():
	if FileAccess.file_exists(save_file_path + save_file_name):
		var file = FileAccess.open(save_file_path + save_file_name, FileAccess.READ)
		var json_string = file.get_as_text()
		var parse_res = JSON.parse_string(json_string)
		if parse_res:
			game_data = GameData.new()
			game_data.load(parse_res)
		else:
			print("Failed to parse game data")
		file.close()
	else:
		print("Failed to load game data")

func toggle_character_set(character_set_name: String):
	game_data.toggle_character_set(character_set_name)
	save_game_data()

func get_random_color():
	return game_data.colors.values().pick_random()

func get_random_character():
	var random_hiragana
	var random_katakana
	if game_data.character_set["Hiragana"]:
		random_hiragana = character_sets["Hiragana"]["items"].pick_random()
	if game_data.character_set["Katakana"]:
		random_katakana = character_sets["Katakana"]["items"].pick_random()

	# Return early if no character sets are enabled
	if not game_data.character_set["Hiragana"] and not game_data.character_set["Katakana"]:
		return ""
		
	# Create weighted array based on enabled character sets
	var choices = []
	if game_data.character_set["Hiragana"]:
		choices.append(random_hiragana)
	if game_data.character_set["Katakana"]:
		choices.append(random_katakana)
		
	# Pick random character from enabled sets
	return choices.pick_random() if choices.size() > 0 else ""

func get_json_from_file(path: String):
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		var json_string = file.get_as_text()
		file.close()
		var parse_res = JSON.parse_string(json_string)
		return parse_res
	else:
		return null

func load_character_sets():
	var hiragana_json = get_json_from_file("res://data/Hiragana.json")
	if hiragana_json:
		character_sets["Hiragana"]["items"] = hiragana_json["Items"]
	var katakana_json = get_json_from_file("res://data/Katakana.json")
	if katakana_json:
		character_sets["Katakana"]["items"] = katakana_json["Items"]

func choose_next_character():
	current_character = get_random_character()
	print(current_character)
	character_chosen.emit(current_character)

func pop(correct: bool):
	balloon_popped.emit(correct)
