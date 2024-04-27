extends Node3D
class_name GRABABLE
@export var actor:Actor
enum Enum {
	ARROW = 1,
	HOOK =2
}
@export var my_flags:Enum
@onready var parent = get_parent()
var held = false
func _is(flags):
	return (flags &my_flags) != 0
