@tool
class_name Interface
extends Node
var before_init =true
@export var keys:Array[String]:
	set(value):
		if before_init:
			keys = value
		return
@export var translations:Dictionary:
	set(value):
		for key in value.keys():
			if key not in keys:
				value.erase(key)
		if value.values().size()> keys.size():
			return
		translations = value
func _ready():
	for key in keys:
		if not translations.has(key):
			translations[key] = ""
	before_init = false
		
