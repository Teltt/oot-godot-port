class_name Main
extends Node3D
var world
var multiplayer_peer = ENetMultiplayerPeer.new()

const PORT = 9999
const ADDRESS = "127.0.0.1"

var connected_peer_ids = []
var local_player_character
@onready var spawner = $Spawner
@onready var menu = $Menu
enum PlayerRole {
	Prime,
	Metroid,
	ALL,
	MetroidPrime
}
var role = PlayerRole.Metroid
func _ready():
	var world = get_tree().get_first_node_in_group("world")
	Glb.main = self
func _on_join_pressed():
	var port = str(PORT).to_int()
	multiplayer_peer.create_client("localhost", port)
	multiplayer.multiplayer_peer = multiplayer_peer
	menu.visible = false
	


func _on_host_pressed():
	var port = str(PORT).to_int()
	multiplayer_peer.create_server(port)
	multiplayer.multiplayer_peer = multiplayer_peer
	connected_peer_ids.push_back(1)
	role = PlayerRole.Prime
	multiplayer_peer.peer_connected.connect(
		func(id): 
		
		rpc("iready",id)
		add_newly_connected_player_character(id)
		connected_peer_ids.push_back(id)
		add_player_character(1)
		)
	menu.visible = false


@rpc("call_remote")
func add_player_character(id=1):
	var path = "res://translated_actor/Scene/player/player.tscn"+"]"+str(id)
	if role == PlayerRole.Prime and id == 1:
		spawner.remote_spawn({"path"=path,"id"=id,"pos" = Vector3(2,1,1) if id == 1 else Vector3(0,1,0)})
	
	

@rpc("call_remote")
func add_newly_connected_player_character(new_peer_id):
	add_player_character(new_peer_id)
	return
	
	
@rpc
func add_previously_connected_player_characters(peer_ids):
	for peer_id in peer_ids:
		add_player_character(peer_id)
		


# The game starts in this map. Note that it's scene name only, just like MetSys refers to rooms.
var starting_map: String = "Room1.tscn"
# Player node, bruh.
var player

# The current map scene instance.
var prime_map: Node2D
@export var prime_map_path:String
var metroid_map:Node2D

@export var metroid_map_path:String
@export var prime_map_path2:String
@export var metroid_map_path2:String

# The coordinates of generated rooms. MetSys does not keep this list, so it needs to be done manually.
var generated_rooms: Array[Vector3i]
# The typical array of game events. It's supplementary to the storable objects.
var events: Array[String]
@rpc("call_local")
func iready(id=1) -> void:
	if FileAccess.file_exists("user://save_data.sav"):
		# If save data exists, load it.
		pass
	else:
		# If no data exists, reset MetSys.
		pass
	if role == PlayerRole.Prime:
		spawner.set_multiplayer_authority(1)
	# Go to the starting point.
	
	## Find the save point and teleport the player to it, to start at the save point.
	#var start := MetSys.current_room.get_node_or_null(^"SavePoint")
	#if start:
		#player.position = start.position
	
	# Connect the room_changed signal to handle room transitions.
	#MetSys.room_changed.connect(on_room_changed, CONNECT_DEFERRED)
	# Reset position tracking (feature specific to this project).
