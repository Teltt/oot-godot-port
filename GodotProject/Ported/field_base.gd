extends Node2D
@export var reverse_sorting = false
@export var field_name = "Default"
var children
var previous = false
# Called when the node enters the scene tree for the first time.
func _ready():
	
	await get_tree().process_frame
	previous = SorterGlobal.reverse_mode
	SorterGlobal.reverse_mode = reverse_sorting
	sort_children_into_z_layers()

func sort_children_into_z_layers():
	children = get_children()
	for child in children:
		var layer = 0
		if child.has_node("ZSort"):
			var zsort = child.get_node("ZSort")
			layer = zsort.z_index
		remove_child(child)
		#get_node("z"+str(layer)).add_child(child)
		pass
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
func _exit_tree():
	for child in children:
		child.queue_free()
	SorterGlobal.reverse_mode = previous
