extends Node3D
class_name GRABABLE
@export var actor:Node
enum Enum {
	ARROW = 1,
	HOOK =2
}
@export var my_flags:Enum
@onready var parent = get_parent()
signal grabbed(grabber)
signal released(grabber)
var grabber
func _is(flags):
	return (flags==my_flags)
func on_grab(value):
	if grabber:
		grabber.grabbed = null
	grabber = value
func on_release():
	grabber = null
