extends Node
class_name Filter
@export var actor:Actor
@export var filter:StringName
@export var active = true
func on_match(filtermatch):
	matched.emit(filtermatch,self)
signal matched(_actor,me)
