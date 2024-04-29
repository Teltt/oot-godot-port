extends Node
class_name Switch
@export var actor:Actor
var prev_v = v
var v:
	set(value):
		if Save.data == null:
			v = value
			return
		if Save.data.has_meta(save_data_flag): 
			Save.data[save_data_flag] = value
	get:
		if Save.data == null:
			return v
		if Save.data.has_meta(save_data_flag): 
			return Save.data[save_data_flag]
		return v
@export var save_data_flag:StringName
signal send_initial_value(value)
func _ready() -> void:
	send_initial_value.emit(v)
