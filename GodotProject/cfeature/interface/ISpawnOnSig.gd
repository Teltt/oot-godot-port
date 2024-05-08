@tool
extends Node3D
@export var obj_spawn_params:ObjectSpawnParams

@export var parent:Node
@rpc("call_remote","any_peer")
func spawn1() -> void:
	if not is_multiplayer_authority():
		return 
	if not Engine.is_editor_hint():
			Glb.main.spawner.remote_spawn({
			"pos"= global_position,
			"path"=obj_spawn_params.scene+"]"+parent.room_path+"/"+name,
			"id"=1})
