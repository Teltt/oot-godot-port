extends Node
class_name IFilterMatch
@export var actor:Actor
signal matched
signal matched_specific
@export var filter:StringName
func on_hit(hitter,hitspot):
	var is_matchable = false
	for _child in hitter.actor.get_children():
		if _child is Filter:
			if _child.filter == filter:
				is_matchable = true
				matched_specific.emit(self,_child)
	if is_matchable:
		matched.emit()
