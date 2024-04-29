extends Actor
class_name BgBreakWall
@onready var collision = $Collision
@export var play_discovery_jingle:bool
@onready var switch = $Switch
@export var broken_collision:Shape3D
@export var broken_mesh:Mesh
@export var full_collision:Shape3D
@export var full_mesh:Mesh
var mesh:
	set(value):
		$MeshInstance3D.mesh = value
	get:
		return $MeshInstance3D.mesh
func _ready():
	super()
	if Engine.is_editor_hint():
		return
	var is_broken =switch.v
	if is_broken:
		set_broken()
	else:
		set_full()
func _exit_tree() -> void:
	if is_queued_for_deletion():
		pass
func set_full():
	switch.v = false
	mesh = full_mesh
	collision.shape = full_collision
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		
			if switch.v:
				set_broken()
			else:
				set_full()
	super(_delta)
func set_broken(_unused=null,_unused2=null):
	switch.v = true
	collision.shape = broken_collision
	mesh = broken_mesh
	if play_discovery_jingle:
		$discover_sfx.play()
