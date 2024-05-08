extends Node3D
@export var remote:Node3D
@export var outer:Node3D
@export var cam:PhysicsBody3D
@onready var player:PhysicsBody3D:
	set(value):
		if value != null and value != player:
			var playe = value
			parent.add_excluded_object(playe.get_rid())
			ray.add_exception(playe)
			ray2.add_exception(playe)
			ray3.add_exception(playe)
			ray4.add_exception(playe)
			ray5.add_exception(playe)
			player = playe
		
var follow:Node3D:
	get:
		return get_parent().get_parent().target
@onready var parent:SpringArm3D = get_parent()
@onready var ray:ShapeCast3D = $RayCast3D5/RayCast3D
var collision1_frame = 0.0
@onready var ray2 = $RayCast3D5/RayCast3D2
var collision2_frame = 0.0
@onready var ray3 = $RayCast3D5/RayCast3D3
var collision3_frame = 0.0
@onready var ray4= $RayCast3D5/RayCast3D4
var collision4_frame = 0.0
@onready var ray5 = $RayCast3D5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent().get_parent().player
	ray.add_exception(cam)
	ray2.add_exception(cam)
	ray3.add_exception(cam)
	ray4.add_exception(cam)
	ray5.add_exception(cam)
	pass # Replace with function body.
func _process(_delta: float) -> void:
	player = get_parent().get_parent().player
	if follow != player and follow != null:
		var flat_follow = follow.global_position*Vector3(1,0,1)
		var flat_player = player.global_position*Vector3(1,0,1)
		flat_player = Vector2(-flat_player.x,flat_player.z)
		flat_follow= Vector2(-flat_follow.x,flat_follow.z)
		if Vector3.UP.distance_to(parent.global_position.direction_to(follow.global_position)) > 0.015:
			var old_global = parent.global_transform
			parent.look_at(follow.global_position,Vector3.UP)
			parent.global_transform = old_global.interpolate_with(parent.global_transform,0.125)
	parent.global_position = parent.global_position.lerp(remote.global_position,0.25)
	outer.global_position = parent.spring_length*parent.global_basis.z+parent.global_position
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var add_to_rotation = Input.get_vector("a","d","s","w")
	if follow == player:
		if ray.is_colliding():
			collision1_frame+= delta
			if collision1_frame > 0.0:
				parent.rotation.y -= delta*1.0
				
		else:
			collision1_frame = 0.0
		if ray2.is_colliding():
			collision2_frame+= delta
			if collision2_frame >0.0:
				parent.rotation.y += delta*1.0
		else:
			collision2_frame = 0.0
	if ray5.is_colliding():
		parent.rotation.x= clamp(parent.rotation.x-delta*3.0,deg_to_rad(-35),deg_to_rad(35))
	else:
		if parent.rotation.x <= deg_to_rad(-35):
			parent.rotation.x = move_toward(parent.rotation.x,deg_to_rad(-35),delta*3.0)

	if ray3.is_colliding():
		collision3_frame+= delta
		if collision3_frame > 3.0:
			parent.rotation.x += delta*6.0
	else:
		collision3_frame = 0.0
	if ray4.is_colliding():
		collision4_frame+= delta
		if collision4_frame > 3.0:
			parent.rotation.x -= delta*6.0
	else:
		collision4_frame = 0.0
	parent.rotation.x = min(parent.rotation.x+add_to_rotation.y*1.5*delta,deg_to_rad(25))
	parent.rotation.y = parent.rotation.y+add_to_rotation.x*1.5*delta
	pass
