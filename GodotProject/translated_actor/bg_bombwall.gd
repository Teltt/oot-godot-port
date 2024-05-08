@tool
extends Actor
class_name BgBreakWall
var is_broken
@onready var collision = $Collision
@export var play_discovery_jingle:bool
@export var switch:Switch
@export var broken_collision:Shape3D
@export var broken_mesh:Mesh
@export var full_collision:Shape3D
@export var full_mesh:Mesh
@export var broken_in_editor:bool= false
var mesh:
	set(value):
		$MeshInstance3D.mesh = value
	get:
		return $MeshInstance3D.mesh
func _ready():
	super()
	if Engine.is_editor_hint():
		return
	is_broken =switch.v
	if is_broken:
		collision.shape = broken_collision
		mesh = broken_mesh
	else:
		mesh = full_mesh
		collision.shape = full_collision
func _exit_tree() -> void:
	if is_queued_for_deletion():
		pass
func set_full():
	if Engine.is_editor_hint():
		
		return
	$IZtarget.can_target = true
	if is_broken != switch.v:
		switch.v = false
		mesh = full_mesh
		collision.shape = full_collision
func _process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		if switch.v:
			set_broken()
		else:
			set_full()
		is_broken  = switch.v
	super(_delta)
func set_broken(_unused=null,_unused2=null):
	
	if Engine.is_editor_hint():
		return
	$IZtarget.can_target = false
	if is_broken != switch.v:
		switch.v = true
		collision.shape = broken_collision
		mesh = broken_mesh
		if play_discovery_jingle:
			$discover_sfx.play()
