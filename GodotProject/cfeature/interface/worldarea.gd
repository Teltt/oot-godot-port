extends Area3D
@export_file var scene:String
var active = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority():
		return
	var bodies = get_overlapping_bodies()
	var player_found = false
	for b in bodies:
		if b is Player:
			player_found = true
	if player_found and not active:
		active = true
		Glb.main.spawner.remote_spawn({
			"path"=scene+"]"+name,
			"id"=1})
	if not player_found and active:
		active = false
		var spawn = Glb.object_spawns[scene+"]"+name]
		if not is_instance_valid(spawn):
			Glb.object_spawns.erase(scene+"]"+name)
			return
		for child in spawn.get_children():
			if child is MultiplayerSpawn:
				child.free_me()
				break
	pass
