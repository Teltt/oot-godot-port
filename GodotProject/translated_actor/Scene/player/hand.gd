extends Node3D
@export var skel:Skeleton3D
func _process(_delta: float) -> void:
	var idx = skel.find_bone("limb_15")
	global_transform = skel.global_transform*skel.get_bone_global_pose(idx)
