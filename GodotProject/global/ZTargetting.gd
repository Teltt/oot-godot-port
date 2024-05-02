extends Node
var camera:Camera3D
var list:Array[Node]
var cur_pos:int
var current_target:ZTarget = null
func _ready() -> void:
	list = get_tree().get_nodes_in_group("ZTarget")
	
func _process(delta: float) -> void:
	var player = get_tree().get_first_node_in_group("player")
	camera = get_tree().get_first_node_in_group("camera")
	list = get_tree().get_nodes_in_group("ZTarget")
	list = list.filter(func(ele):
		var is_in_view = camera.is_position_in_frustum( ele.global_position)
		return is_in_view)
	list.sort_custom(func(a,b):
		return a.global_position.distance_to(player.global_position) < b.global_position.distance_to(player.global_position))
	cur_pos = list.find(current_target,0)
	if cur_pos == -1:
		untarget()
func change_by_num(num):
	var new_cur_pos = wrapi(cur_pos+num,0,list.size())
	untarget()
	cur_pos =new_cur_pos
	if cur_pos == list.size():
		return
	current_target = list[cur_pos]
	current_target.get_node("CSGCylinder3D").visible = true
func change_to_first():
	untarget()
	cur_pos = 0
	if cur_pos == list.size():
		return
	current_target = list[cur_pos]
	current_target.get_node("CSGCylinder3D").visible = true
func untarget():
		if current_target:
			current_target.get_node("CSGCylinder3D").visible = false
		cur_pos = -1 
		current_target = null
		return
