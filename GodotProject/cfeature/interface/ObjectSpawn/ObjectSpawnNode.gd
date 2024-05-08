@tool
extends Node3D
@export var parent:MultiplayerRoom
@export var obj_spawn_params:ObjectSpawnParams:
	set(value):
		obj_spawn_params = value
# Called when the node enters the scene tree for the first time.
var spawn = null
func spawn1() -> void:
	if not is_multiplayer_authority():
		return 
	if not Engine.is_editor_hint():
			Glb.main.spawner.remote_spawn({
			"pos"= global_position,
			"path"=obj_spawn_params.scene+"]"+parent.room_path+"/"+name,
			"id"=1})
			
		


		
