extends Node
class_name IFilterMatch
@export var actor:Actor
signal matched
signal matched_specific(this,child)
@export var filter:StringName
func on_hit(hitter,hitspot):
	var is_matchable = false
	for _child in hitter.actor.get_children():
		if _child is Filter:
			if _child.filter == filter and _child.active:
				is_matchable = true
				_child.matched.emit(self,_child)
				matched_specific.emit(self,_child)
	if is_matchable:
		matched.emit()
func on_hitspot(hitter,hitspot):
	var is_matchable = false
	for _child in hitspot.actor.get_children():
		if _child is Filter:
			if _child.filter == filter and _child.active:
				is_matchable = true
				_child.matched.emit(self,_child)
				matched_specific.emit(self,_child)
	if is_matchable:
		matched.emit()
func nullfunc():
	return
func second_actor (actor2,tru_callable:Callable=nullfunc,fals_callable:Callable=nullfunc):
	var is_matchable = false
	for _child in actor2.get_children():
		if _child is Filter:
			if _child.filter == filter and _child.active:
				is_matchable = true
				_child.matched.emit(self,_child)
				matched_specific.emit(self,_child)
	if is_matchable:
		tru_callable.call()
		matched.emit()
	else:
		fals_callable.call()
