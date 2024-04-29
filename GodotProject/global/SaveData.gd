@tool
extends Resource
class_name SaveData
var bomb_wall1:bool
func _init() -> void:
	if not resource_path.begins_with("user://"):
		_set("bomb_wall1",false)
func _set(property: StringName, value: Variant) -> bool:
	self[property] = value
	set_meta(property,value)
	return true
func _get(property: StringName) -> Variant:
	return get_meta(property)
