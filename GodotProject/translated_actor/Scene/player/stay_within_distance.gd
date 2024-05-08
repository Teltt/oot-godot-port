extends CharacterBody3D
@onready var raycast =$RayCast3D
@export var following:Node3D
@export var outer_following:Node3D
@export var player_cam:Node3D
@export var cam:PhantomCamera3D
func _ready() -> void:
	
	var player = player_cam.player
	if player.is_multiplayer_authority():
		cam.priority = 1
	else:
		cam.priority = 0
func _process(_delta: float) -> void:
	var fllow = player_cam.follow
	if fllow == null:
		fllow = player_cam.player
	var player = player_cam.player
	if player == null:
		return
	var is_colliding = raycast.is_colliding()
	var col_point = following.global_position
	var col_normal :Vector3= Vector3.ZERO
	if is_colliding:
		col_point=  raycast.get_collision_point(0)
		col_normal=raycast.get_collision_normal(0)
	raycast.target_position = raycast.to_local(following.global_position)
	raycast.force_shapecast_update()
	cam.position = following.global_basis.z*0.5
	velocity = -(global_position-following.global_position)+player.my_velocity*0.1
	collision_mask = 1
	if ((fllow.global_position)*Vector3(1,0,1)).distance_to((cam.global_position*Vector3(1,0,1)))< 1.0:
		cam.look_at_offset=cam.look_at_offset.lerp(player.my_velocity*0.1,0.025)-following.global_basis.z*0.5
	else:
		cam.look_at_offset=cam.look_at_offset.lerp(player.my_velocity.normalized()*0.75,0.025)
		
	var length = velocity.length()
	if length <= 0.5:
		velocity = velocity*6.0
		move_and_slide()
	elif raycast.is_colliding() and  global_position.distance_to(outer_following.global_position) <= length:
		velocity = -(global_position-outer_following.global_position)+player.my_velocity*0.1
		velocity = Vector3.ZERO.lerp(velocity*6.0,0.95)
		velocity = velocity.normalized() * clamp(velocity.length(),0.0,25.0)
		move_and_slide()
	elif length <= 3.15 or global_position.distance_to(outer_following.global_position) > length and not is_colliding :
		velocity = Vector3.ZERO.lerp(velocity*6.0,0.95)
		velocity = velocity.normalized() * clamp(velocity.length(),0.0,25.0)
		move_and_slide()
	if fllow == player_cam.player:
			
		if (global_position*Vector3(1,0,1)).distance_to(fllow.global_position*Vector3(1,0,1)) >= 3.15:
			global_position = global_position.lerp(following.global_position,0.025)
		if (global_position*Vector3(1,0,1)).distance_to(fllow.global_position*Vector3(1,0,1)) >= 4.15:
			global_position = global_position.lerp(following.global_position,0.95)
	else:
		velocity = Vector3.ZERO.lerp(velocity*6.0,0.95)
		velocity = velocity.normalized() * clamp(velocity.length(),0.0,25.0)
		move_and_slide()
		
