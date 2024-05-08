@tool
extends Node
var sorted_dict:Dictionary = {}
var object_to_sorter:Dictionary = {}
var sorters
var reverse_mode = false
func _process(_delta):
	sorters = get_tree().get_nodes_in_group("ysort")
	var i = 0
	while i <sorters.size():
		if not is_instance_valid(sorters[i]) or not sorters[i].parent.is_visible_in_tree():
			
			sorters.remove_at(i)
			continue
		else:
			
			i+=1
#	sorters.sort_custom(
#		func(a,b):
#		return a.id > b.id
#		)
	
	for s in sorters.size():
		sorters[s].up_neighbors = []
		sorters[s].down_neighbors = []
	for s in sorters.size():
		sorters[s].update_neighbors()
		sorters[s].parent.z_index = sorters[s].default_depth
	for s in sorters:
		if not s.visited_up:
			s.up_depth_search()
		if not s.visited_down:
			s.down_depth_search()
		
	sorters.sort_custom(func(a,b):
		return (a.total_down_neighbors) > (b.total_down_neighbors))
	for s in sorters.size():
			sorters[s].parent.z_index = sorters[s].default_depth+ (s)
	
	pass
