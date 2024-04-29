@tool
extends Node
var data:SaveData = SaveData.new()

func _ready() -> void:
	if FileAccess.file_exists("user://save.tres"):
		data = load("user://save.tres")
	else:
		data = SaveData.new()
