extends Node3D
@export var actor:Actor
@onready var parent = get_parent()
var holding = false
var grabbed:GRABABLE:
	set(value):
		if grabbed != null:
			grabbed.held = false
		if value != null:
			value.held = true
			holding = true
		else:
			holding = false
		grabbed = value

@export var my_flags:GRABABLE.Enum
func grab(_actor:Actor):
	for _child in _actor.get_children():
		if _child is GRABABLE:
			if _child._is(my_flags):
				grabbed = _child
				return
func release():
	grabbed = null
func process_grab():
	if holding:
		grabbed.actor.global_transform = global_transform*grabbed.transform
