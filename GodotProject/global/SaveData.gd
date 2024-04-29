@tool
extends Resource
class_name SaveData
var bomb_wall1:bool
func _init() -> void:
	if not resource_path.begins_with("user://"):
		_set("bomb_wall1",false)
	else:
		_set("bomb_wall1",bomb_wall1)
func _set(property: StringName, value: Variant) -> bool:
	self[property] = value
	if value == null:
		set_meta(property,"null")
	set_meta(property,value)
	return true
func _get(property: StringName) -> Variant:
	if get_meta(property) == "null":
		return null
	return get_meta(property)
