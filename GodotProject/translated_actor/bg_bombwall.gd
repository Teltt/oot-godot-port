#extends Meshinstance3D
extends Actor
class_name BgBreakWall

@onready var collision = $Collision
@export var play_discovery_jingle:bool
var prev_is_broken = is_broken
var is_broken:bool = true:
	set(value):
		if Save.data == null:
			is_broken = value
			return
		if Save.data.has_meta(save_data_flag): 
			Save.data[save_data_flag] = value
	get:
		if Save.data == null:
			return is_broken
		if Save.data.has_meta(save_data_flag): 
			return Save.data[save_data_flag]
		return is_broken
@export var broken_collision:Shape3D
@export var broken_mesh:Mesh
@export var full_collision:Shape3D
@export var full_mesh:Mesh
@export var save_data_flag:StringName
var mesh:
	set(value):
		$MeshInstance3D.mesh = value
	get:
		return $MeshInstance3D.mesh
func _ready():
	super()
	$Ihitable.connect("hit",on_hit)
	if Engine.is_editor_hint():
		return
	if is_broken:
		set_broken()
	else:
		set_full()
func _exit_tree() -> void:
	if is_queued_for_deletion():
		pass
func set_full():
	is_broken = false
	mesh = full_mesh
	collision.shape = full_collision
func on_hit(hitter,hitspot):
	var is_bombable = false
	for _child in hitter.actor.get_children():
		if _child is BombHit:
			is_bombable = true
	if is_bombable:
		set_broken()
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		if prev_is_broken != is_broken:
			prev_is_broken = is_broken
			if is_broken:
				set_broken()
			else:
				set_full()
	super(_delta)
func set_broken():
	is_broken = true
	collision.shape = broken_collision
	mesh = broken_mesh
#	if play_discovery_jingle:
#		Sfx.play_sfx_centered(NA_SE_SY_CORRECT_CHIME)
	#Flags.set_switch(play, self.dyna.actor.params & 0x3F)
