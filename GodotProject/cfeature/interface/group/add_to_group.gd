extends Node
@export var group_name:StringName = "None"
@export var actor:Actor
func _ready():
	actor.add_to_group("Parent"+group_name)
	add_to_group(group_name)
