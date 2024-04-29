extends Node3D
@export var actor:Actor
@onready var parent = get_parent()
var holding = false
var grabbed:GRABABLE:
	set(value):
		if grabbed != null:
			if grabbed != value:
				grabbed.on_release()
				grabbed.actor.global_transform = actor.world
				grabbed.actor.world = grabbed.actor.global_transform
				grabbed.actor.set_physics_process(true)
				grabbed.released.emit(self)
		if value != null:
			holding = true
			if value != grabbed:
				value.on_grab(self)
				value.actor.set_physics_process(false)
				value.grabbed.emit(self)
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
		grabbed.actor.world = grabbed.actor.global_transform

