class_name SaveData
extends Resource

const SAVE_PATH: String = "user://high_score.tres"

@export var high_score: int = 0


func save() -> void:
	ResourceSaver.save(self, SAVE_PATH)


static func load_or_create() -> SaveData:
	var res: SaveData
	if FileAccess.file_exists(SAVE_PATH):
		res = load(SAVE_PATH) as SaveData
	else:
		res = SaveData.new()
	return res 
