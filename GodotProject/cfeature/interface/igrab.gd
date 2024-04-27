extends Node3D
@export var actor:Actor
@onready var parent = get_parent()
var holding
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
	for child in _actor.get_children():
		if child is GRABABLE:
			if child._is(my_flags):
				grabbed = child
				return
func release():
	grabbed = null
func process_grab():
	if holding:
		grabbed.parent.global_transform = global_transform*grabbed.transform
