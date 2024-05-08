extends MultiplayerSpawner


# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_function=spawninge
	pass # Replace with function body.
static var id = 1
func spawninge(data1):
		var data = data1["path"].split("]")
		var ret = load(data[0])
		if data.size() >1:
			if Glb.object_spawns.has(data1["path"]):
				var prev_object = Glb.object_spawns[data1["path"]]
				if not is_instance_valid(prev_object):
					Glb.object_spawns[data1["path"]] = ret.instantiate()
					ret = Glb.object_spawns[data1["path"]] 
				else:
					return null
			else:
				Glb.object_spawns[data1["path"]] = ret.instantiate()
				ret = Glb.object_spawns[data1["path"]] 
		else:
			ret = ret.instantiate()
		ret.set_multiplayer_authority(data1["id"],true)
		var children = ret.get_children()
		for child in children:
			if child is MultiplayerSpawn:
				child.id = id
				child.multiplayer_spawner = self
				child.object_path = data1["path"]
				child.parent = ret
				break
		if data1.has("pos"):
			ret.position = data1["pos"]
		id+=1
		return ret

@rpc("any_peer")
func remote_spawn(data):
	spawn(data)
	return
@rpc("call_remote","any_peer")
func spawn1(data):
	spawn(data)
