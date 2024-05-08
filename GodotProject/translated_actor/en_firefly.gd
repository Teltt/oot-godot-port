class_name EnFirefly
extends Actor
var player:Actor
@export var is_lit:bool
@export var perched:bool
@export var max_altitude:float
@export var fire_filter:Filter
@export var ice_filter:Filter
@export var floorcast:RayCast3D
var floor_height
var timer:float:
	set(value):
		timer = value
	get:
		return timer
var target_pitch:float
var state:Callable
enum ELEMENT {
	NONE,
	ICE,
	FIRE,
}
@export_enum("None","Ice","Fire") var element:String
func _ready() -> void:
	var area:Area3D = $Area3D
	world = global_transform
	home = global_transform
	player = get_tree().get_first_node_in_group("player")
	if is_lit and element == "Ice":
		ice_filter.active = true
	elif is_lit and element == "Fire":
		fire_filter.active = true
	if perched:
		setup(perch)
	else:
		setup(flyidle)
	pass
func _physics_process(_delta: float) -> void:
	if is_queued_for_deletion():
		return
	player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	floorcast.target_position = (Vector3(0,-9999,0))*global_basis.inverse()
	floor_height = 0
	floorcast.force_raycast_update()
	if floorcast.is_colliding():
		floor_height=floorcast.get_collision_point().distance_to( floorcast.global_position)
	#if collider.base.at_flags & AT_HIT:
		#collider.base.at_flags &= ~AT_HIT
		#_sfx(NA_SE_EN_FFLY_ATTACK)


	state.call(_delta)

	if state != die:
		if state == stunned:
			MoveXZGravity(_delta)
		else:
			global_rotation.x =  global_rotation.x
			MoveXYZ(_delta)

			#_sfx(NA_SE_EN_FFLY_FLY)

	#collision_check_set_oc( collider.base)
	focus.origin = world.origin + Vector3(sin(global_rotation.x) * sin(global_rotation.y), cos(global_rotation.x), sin(global_rotation.x) * cos(global_rotation.y)) * 10.0

func setup(_state):
	if _state == flyidle:
		timer = randi() % 70 + 30
		speed = randf_range(1.5, 3.0)
		var traget_yaw = Vector2(world.origin.x,world.origin.z).angle_to(Vector2(home.origin.x,home.origin.z))
		global_rotation.y = deltastep(1/60.0,angle_difference(0,global_rotation.y),traget_yaw , redo_angle(0x300))
		target_pitch = redo_angle((  0xC00 if (max_altitude < world.origin.y) else -0xC00) + 0x1554)
		state = _state
		return
	if _state == fall:
		timer = 40
		my_velocity.y = 0.0
		#_sfx(NA_SE_EN_FFLY_DEAD)
		#set_color_filter(COLORFILTER_COLORFLAG_RED, 255, COLORFILTER_BUFFLAG_OPA, 40)
		state = _state
	if _state == die:
		timer = 15
		speed = 0.0
		state = _state
	if _state == rebound:
		global_rotation.x = redo_angle(0x7000)
		timer = 18
		speed = 2.5
		state = _state
	if _state == diveattack:
		
		timer = randi() % 70 + 60
		target_pitch = redo_angle(( -0xC00 if (player.world.origin.y-world.origin.y > 0.0)   else 0xC00) + 0x1554)
		state = diveattack
	if _state == flyaway:
			
		timer = 150
		target_pitch = redo_angle(-0x954)
		state = _state
	if _state == stunned:
		timer = 80
		#set_color_filter(COLORFILTER_COLORFLAG_BLUE, 255, COLORFILTER_BUFFLAG_OPA, 80)
		ice_filter.active = false
		fire_filter.active = false
		my_velocity.y = 0.0
		#skel_anime._speed = 3.0
		#_sfx(NA_SE_EN_GOMA_JR_FREEZE)
		state =_state
	if _state == frozen_fall:
		#flags |= ACTOR_FLAG_4
		ice_filter.active = false
		fire_filter.active = false
		speed = 0.0
		#set_color_filter(COLORFILTER_COLORFLAG_BLUE, 255, COLORFILTER_BUFFLAG_OPA, 255)
		#_sfx(NA_SE_EN_FFLY_DEAD)
		state = _state
	if _state == perch:
		
		timer = 1
		speed = 0.0
		state = _state
	if _state == disturbdive:
		global_rotation.x = redo_angle(0x1554)
		global_rotation.y =  Vector2(world.origin.x,world.origin.z).angle_to(Vector2(player.world.origin.x,player.world.origin.z))
		timer = 50
		speed = 3.0
		state = _state
func return_to_perch(_delta):
	if not perched:
		return false
	var dist_to_player_xz = Vector2(world.origin.x,world.origin.z).distance_to(Vector2(player.world.origin.x,player.world.origin.z))
	if dist_to_player_xz > 300.0:
		var dist_from_home = world.origin.distance_to(home.origin)
		if dist_from_home < 5.0:
			setup(perch)
			return  true

		dist_from_home *= 0.05
		if dist_from_home < 1.0:
			speed *= dist_from_home
		var dist_y = world.origin.y - home.origin.y
		var dist_xz= Vector2(world.origin.x,world.origin.z).distance_to(Vector2(home.origin.x,home.origin.z))
		global_rotation.y = deltastep(_delta,angle_difference(0,global_rotation.y), Vector2(world.origin.x,world.origin.z).angle_to(Vector2(home.origin.x,home.origin.z)), redo_angle(0x300))
		global_rotation.x = deltastep(_delta,global_rotation.x, pitch_to_point(world.origin,home.origin), redo_angle(0x100))
		return true

	return false
func flyidle(_delta):
	if timer >= 0:
		timer -= _delta*20

	if is_lit || element == "Ice" || not return_to_perch(_delta) && not seektorch(_delta):
		if true:#skel_anime_on_frame
			var rand = randf_range(0,1)
			if rand < 0.5:
				global_rotation.y = deltastep(_delta,angle_difference(0,global_rotation.y), yaw_to_point(world.origin, home.origin), redo_angle(0x300))
			elif rand < 0.8:
				global_rotation.y += redo_angle(rand_centered_float(1536.0))

			if world.origin.y < max_altitude:
				target_pitch = redo_angle(-0x954)
			elif max_altitude < world.origin.y:
				target_pitch = redo_angle(0x2154)
			else:
				if rand < 0.35:
					target_pitch = redo_angle(-0x954)
				else:
					target_pitch = redo_angle(0x2154)
		else:
			if self["is_on_floor"].call():
				target_pitch = redo_angle(-0x954)
			elif self["is_on_ceiling"].call() or max_altitude < world.origin.y:
				target_pitch = redo_angle(0x2154)

		if self["is_on_wall"].call():
			var normal = -self["get_wall_normal"].call()
			var wall_yaw = yaw_to_point(Vector3.ZERO,normal)
			global_rotation.y = deltastep(_delta,angle_difference(0,global_rotation.y), global_rotation.y+PI, redo_angle(0x300))
		var dist_to_player_xz = dist_to_xz(player.world.origin,world.origin)
		if timer <= 0 and dist_to_player_xz < 200.0:
			setup(diveattack)
	global_rotation.x = deltastep(_delta,global_rotation.x, target_pitch,  redo_angle(0x100))
func ignite():
	if (element == "Ice"):
		element = "Fire";
	else:
		element = "Fire";
	fire_filter.active = true
	ice_filter.active = false
	is_lit = true;
func extinguish():
	element = "None";
	fire_filter.active = false
	ice_filter.active = false
	is_lit = false;

func seektorch(_delta):
	var find_torch = get_tree().get_nodes_in_group("Torch")
	var closest_torch = null
	var current_min_dist = 35000.0

	for torch in find_torch:
		if  torch.actor.lit_timer != 0:
			var torch_dist = world.origin.distance_to(torch.global_position)
			if torch_dist < current_min_dist:
				current_min_dist = torch_dist
				closest_torch = torch

	if closest_torch != null:
		var flame_origin = closest_torch.global_position
		if world.origin.distance_to(flame_origin) < 15.0:
			ignite()
			return 1
		else:
			global_rotation.y = deltastep(_delta,angle_difference(0,global_rotation.y), Vector2(world.origin.x,world.origin.z).angle_to(Vector2(flame_origin.x,flame_origin.z)), redo_angle(0x300))
			global_rotation.x = deltastep(_delta,global_rotation.x, pitch_to_point(world.origin, flame_origin) , redo_angle(0x100))
			return 1

	return 0
func fall(_delta):
	

	#color_filter_timer = 40
	#skel_anime_update()
	speed = deltastep(_delta,speed, 0.0, 0.5)
	#if flags & ACTOR_FLAG_15:
	#	pass
		#color_filter_timer = 40
	#else:
	global_rotation.x = deltastep(_delta,global_rotation.x, redo_angle(0x6800), redo_angle(0x200))
	global_rotation.y -= redo_angle(0x300)

	timer -= _delta*20
	if self["is_on_floor"].call()or timer <= 0:
		setup(die)
func die(_delta):
	timer -= _delta*20
	scale = Vector3.ONE* deltastep(_delta,scale.x, 0.0, 0.00034)
 
	if timer <= 0:
		#item_drop_collectible_random( world.origin, 0xE0)
		if not is_queued_for_deletion():
			$IMultiplayerSpawn.free_me()
func diveattack(_delta):
	var prey_origin = world.origin+(player.world.origin-world.origin)

	#skel_anime_update()
	timer -= _delta*20
	speed =deltastep(_delta,speed,1.5,0.5)
	var player_yaw =yaw_to_point(world.origin,prey_origin)
	if self["is_on_wall"].call():
		var normal = -self["get_wall_normal"].call()
		var wall_yaw = yaw_to_point(Vector3.ZERO,normal)
		global_rotation.y = deltastep(_delta,angle_difference(0,global_rotation.y), global_rotation.y+PI, redo_angle(0x300))
		global_rotation.x = deltastep(_delta,global_rotation.x, target_pitch, redo_angle(0x100))
	elif angle_difference(global_rotation.y,player_yaw) <= PI/3:
		#if skel_anime_on_frame(4.0):
			#skel_anime._speed = 0.0
			#skel_anime.cur_frame = 4.0

		var old_tf = global_transform
		look_at(prey_origin,Vector3.UP)
		var target_y = global_rotation.y
		var target_x = global_rotation.x
		global_transform = old_tf
		global_rotation.y = deltastep(_delta,angle_difference(0,global_rotation.y), target_y+PI, redo_angle(0x300)*3.0)
		global_rotation.x = deltastep(_delta,global_rotation.x, target_x-PI/2, redo_angle(0x100))
	else:
		#skel_anime._speed = 1.5
		var player_dist_xz = dist_to_xz(world.origin,player.world.origin)
		if player_dist_xz > 80.0:
			global_rotation.y = deltastep(_delta,angle_difference(0,global_rotation.y), player_yaw, redo_angle(0x300))
#
		if self["is_on_floor"].call():
			target_pitch = redo_angle(-0x954)
		elif self["is_on_ceiling"].call() or max_altitude < world.origin.y:
			target_pitch = redo_angle(0x2154)
		else:
			target_pitch = redo_angle(-0x954)

	global_rotation.x = deltastep(_delta,global_rotation.x, target_pitch, redo_angle(0x100))

	if timer <= 0:
		setup(flyaway)
func rebound(_delta):
	global_rotation.x = deltastep(_delta,global_rotation.x, 0, redo_angle(0x100))
	my_velocity.y = deltastep(_delta,my_velocity.y, 0.0, 0.4)

	if deltastep(_delta,speed, 0.0, 0.15):
		timer -= _delta*20
		if timer <= 0:
			setup(flyaway)
func stunned(_delta):
	speed = deltastep(_delta,speed, 0.0, 0.5)
	global_rotation.x = deltastep(_delta,global_rotation.x, 0, 0x100)

	timer -= _delta*20
	if timer <= 0:
		if element == "Fire":
			fire_filter.active = true
		elif element == "Ice":
			ice_filter.active = true
		setup(flyidle)
func flyaway(_delta):
	#skel_anime_update()
	timer -= _delta*20
	var dist_to_home = dist_to_xz(world.origin,home.origin)
	if abs(world.origin.y - max_altitude) < 10.0 and dist_to_home < 20.0 or timer <= 0:
		setup(flyidle)
		return

	speed = deltastep(_delta,speed, 3.0, 0.3)

	if self["is_on_floor"].call():
		target_pitch = redo_angle(-0x954)
	elif self["is_on_ceiling"].call() or max_altitude < world.origin.y:
		target_pitch = redo_angle(0x2154)
	else:
		target_pitch = redo_angle(-0x954)

	if self["is_on_wall"].call():
		var normal = -self["get_wall_normal"].call()
		var wall_yaw = yaw_to_point(Vector3.ZERO,normal)
		global_rotation.y = deltastep(_delta,angle_difference(0,global_rotation.y), global_rotation.y+PI, redo_angle(0x300))
	else:
		global_rotation.y = deltastep(_delta,angle_difference(0,global_rotation.y), yaw_to_point(world.origin, home.origin),  redo_angle(0x300))

	global_rotation.x = deltastep(_delta,global_rotation.x, target_pitch,  redo_angle(0x100))
func frozen_fall(_delta):
	if self["is_on_floor"].call():
		#color_filter_timer = 0
		setup(die)
	#else:
		#color_filter_timer = 255
func perch(_delta):
	global_rotation.x = deltastep(_delta,global_rotation.x, 0, redo_angle(0x100))

	if timer > 0:
		#skel_anime_update()
		#if skel_anime_on_frame(6.0):
			timer -= _delta*20
	elif randf_range(0,1) < 0.02:
		timer = 1
	var dist_to_player = dist_to_xz(world.origin,player.world.origin)
	if dist_to_player < 120.0:
		setup(disturbdive)
func disturbdive(_delta):
	var prey_origin = player.world.origin + Vector3(0, 20.0, 0)

	#skel_anime_update()

	timer -= _delta*20
	var player_yaw = yaw_to_point(world.origin,prey_origin)
	if timer < 40:
		global_rotation.x = deltastep(_delta,global_rotation.x, redo_angle(-0xAAC), redo_angle(0x100))
	else:
		global_rotation.x = deltastep(_delta,global_rotation.x, pitch_to_point(world.origin, prey_origin) , redo_angle(0x100))
		global_rotation.y = deltastep(_delta,angle_difference(0,global_rotation.y), player_yaw, redo_angle(0x300))

	if timer <= 0:
		setup(flyidle)
func combust():
	pass
	#for i in range(3):
		#effect_ss_en_fire_spawn_vec3f(world.origin, 40, 0, 0, i)
#
	is_lit = false
	element = "None"
func hit_fire(filtermatch,filter):
	if element == "Ice":
		#col_chk_info.health = 0
		#enemy_start_finishing_blow()
		combust()
		setup(fall)
	elif not is_lit:
		ignite()
		if state == perch:
			setup(flyidle)
func hit_ice(filtermatch,filter):
		if element == "Ice":
					setup(fall)
		else:
					setup(frozen_fall)
func hit_normal(hitter,hitspot):
	
	if is_lit:
			extinguish()
	if state != disturbdive and state != rebound:
			setup(rebound)
			return
	if state != stunned:
		setup(stunned)
func on_depleted():
	setup(die)
#func damage(_damage):
	#if collider.base.ac_flags & AC_HIT:
		#collider.base.ac_flags &= ~AC_HIT
		#set_drop_flag(collider.elements[0].base, true)
#
		#if col_chk_info.damage_effect != 0 or col_chk_info.damage != 0:
			#if not apply_damage():
				#enemy_start_finishing_blow()
				#flags &= ~ACTOR_FLAG_0
#
			#damage_effect = col_chk_info.damage_effect

			#if damage_effect == 3:
			#
			#else:
				#if damage_effect == 0xF and params == KEESE_ICE_FLY:
					#EnFirefly_Combust()
				#EnFirefly_SetupFall()
