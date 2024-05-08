extends Node
class_name MultiplayerSpawn
@export var parent:Node

@export var multiplayer_spawner:MultiplayerSpawner
var object_path:String
var id = 0
@export var to_free = false:
	set(value):
		to_free = value
		if parent:
			parent.visible= not value
@rpc("call_remote","any_peer")
func set_to_free():
	if Glb.object_spawns.has(object_path):
		Glb.object_spawns.erase(object_path)
	to_free = true
	parent.queue_free()
func set_to_free_local():
	to_free = true
	if Glb.object_spawns.has(object_path):
		Glb.object_spawns.erase(object_path)
func _process(_delta):
	if to_free:
		
		if Glb.object_spawns.has(object_path):
			Glb.object_spawns.erase(object_path)
	if is_multiplayer_authority():
		if to_free and not parent.is_queued_for_deletion():
			set_to_free_local()
			parent.queue_free()
func spawn1() -> void:
	var is_prime= multiplayer_spawner.get_multiplayer_authority()
	if is_prime:
			set_to_free_local()
	if not is_prime:
			set_to_free_local()
			set_to_free.rpc()
func free_me():
	if not to_free:
		
		spawn1()
