class_name nFirefly
extends Actor
var state:Callable
var on_fire = false
var max_altitude = 0.0
var timer:float
var aura_type
var navi_enemy_id
var target_pitch
var flags
var rand
@onready var er:Actor
var y_dist_to_er
var yaw_towards_er
var dist_to_er_xz
var dist_from_home
var dist_to_home_xyz
var floor_height
func step_to_s(v,v2,v3):
	pass
func smooth_step_to_s(v,v1,v2,v3,v4,v5):
	pass
func yaw_toward_point(v,v2):
	pass
func pitch_toward_point(v,v2):
	pass
func rand_centered_float(f):
	return (randf_range(0,1) - 0.5) * f;
const KEESE_AURA_NONE=0
const KEESE_AURA_FIRE=1
const KEESE_AURA_ICE=2
const KEESE_FIRE_FLY=0
const KEESE_FIRE_PERCH=1
const KEESE_NORMAL_FLY=2
const KEESE_NORMAL_PERCH=3
const KEESE_ICE_FLY = 4
func _ready():
	er = get_tree().get_first_node_in_group("er")
	if params & 0x8000 != 0:
		params &= 0x7FFF

	on_fire = params <= KEESE_FIRE_PERCH

	if on_fire:
		state = EnFirefly_FlyIdle
		timer = randi() % 20 + 20
		global_rotation.x = 0x1554
		aura_type = KEESE_AURA_FIRE
		max_altitude = home.origin.y
	else:
		if params == KEESE_NORMAL_PERCH:
			state = EnFirefly_Perch
		else:
			state = EnFirefly_FlyIdle


		max_altitude = home.origin.y + 100.0

		if params == KEESE_ICE_FLY:
			aura_type = KEESE_AURA_ICE
		else:
			aura_type = KEESE_AURA_NONE
func EnFirefly_SetupFlyIdle():
	timer = randi() % 70 + 30
	speed = randf_range(1.5, 3.0)
	global_rotation.y = step_to_s(global_rotation.y, yaw_toward_point(world.origin, home.origin), 0x300)
	target_pitch = (  0xC00 if (max_altitude < world.origin.y) else -0xC00) + 0x1554
	state = EnFirefly_FlyIdle

func EnFirefly_SetupFall():
	timer = 40
	my_velocity.y = 0.0
	#_sfx(NA_SE_EN_FFLY_DEAD)
	flags |= ACTOR_FLAG_4
	#set_color_filter(COLORFILTER_COLORFLAG_RED, 255, COLORFILTER_BUFFLAG_OPA, 40)
	state = EnFirefly_Fall

func EnFirefly_SetupDie():
	timer = 15
	speed = 0.0
	state = EnFirefly_Die

func EnFirefly_SetupRebound():
	global_rotation.x = 0x7000
	timer = 18
	speed = 2.5
	state = EnFirefly_Rebound

func EnFirefly_SetupDiveAttack():
	timer = randi() % 70 + 30
	target_pitch = ( -0xC00 if (y_dist_to_er > 0.0)   else 0xC00) + 0x1554
	state = EnFirefly_DiveAttack

func EnFirefly_SetupFlyAway():
	timer = 150
	target_pitch = 0x954
	state = EnFirefly_FlyAway

func EnFirefly_SetupStunned():
	timer = 80
	#set_color_filter(COLORFILTER_COLORFLAG_BLUE, 255, COLORFILTER_BUFFLAG_OPA, 80)
	aura_type = KEESE_AURA_NONE
	my_velocity.y = 0.0
	#skel_anime._speed = 3.0
	#_sfx(NA_SE_EN_GOMA_JR_FREEZE)
	state = EnFirefly_Stunned

func EnFirefly_SetupFrozenFall():
	flags |= ACTOR_FLAG_4
	aura_type = KEESE_AURA_NONE
	speed = 0.0
	#set_color_filter(COLORFILTER_COLORFLAG_BLUE, 255, COLORFILTER_BUFFLAG_OPA, 255)
	#_sfx(NA_SE_EN_FFLY_DEAD)
	state = EnFirefly_FrozenFall

func EnFirefly_SetupPerch():
	timer = 1
	speed = 0.0
	state = EnFirefly_Perch

func EnFirefly_SetupDisturbDiveAttack():
	#skel_anime._speed = 3.0
	global_rotation.x = 0x1554
	global_rotation.y = yaw_towards_er
	timer = 50
	speed = 3.0
	state = EnFirefly_DisturbDiveAttack

func EnFirefly_ReturnToPerch():
	if params != KEESE_NORMAL_PERCH:
		return 0

	if dist_to_er_xz > 300.0:
		dist_from_home = dist_to_home_xyz
		if dist_from_home < 5.0:
			EnFirefly_SetupPerch()
			return 1

		dist_from_home *= 0.05
		if dist_from_home < 1.0:
			speed *= dist_from_home

		global_rotation.y = step_to_s(global_rotation.y, yaw_toward_point(world.origin, home.origin), 0x300)
		global_rotation.x = step_to_s(global_rotation.x, pitch_toward_point(world.origin, home.origin) + 0x1554, 0x100)
		return 1

	return 0
#
func EnFirefly_SeekTorch():
	pass
	#var find_torch = .actor_ctx.actor_lists[ACTORCAT_PROP].head
	#var closest_torch = null
	#var current_min_dist = 35000.0
#
	#while find_torch != null:
		#if find_torch.id == ACTOR_OBJ_SYOKUDAI && find_torch.lit_timer != 0:
			#torch_dist = dist_to_actor(find_torch)
			#if torch_dist < current_min_dist:
				#current_min_dist = torch_dist
				#closest_torch = find_torch
#
		#find_torch = find_torch.next
#
	#if closest_torch != null:
		#flame_origin = closest_torch.origin + Vector3(0, 52.0 + 15.0, 0)
		#if dist_to_point(flame_origin) < 15.0:
			#EnFirefly_Ignite()
			#return 1
		#else:
			#global_rotation.y = step_to_s(global_rotation.y, Math.yaw_toward_actor(closest_torch), 0x300)
			#global_rotation.x = step_to_s(global_rotation.x, pitch_toward_point(world.origin, flame_origin) + 0x1554, 0x100)
			#return 1
#
	#return 0

func EnFirefly_FlyIdle():
	#skel_anime_update()
	if timer != 0:
		timer -= 1

	if on_fire || params == KEESE_ICE_FLY || EnFirefly_ReturnToPerch() == 0 && EnFirefly_SeekTorch() == 0:
		if true:#skel_anime_on_frame
			rand = randf_range(0,1)
			if rand < 0.5:
				global_rotation.y = step_to_s(global_rotation.y, yaw_toward_point(world.origin, home.origin), 0x300)
			elif rand < 0.8:
				global_rotation.y += rand_centered_float(1536.0)

			if world.origin.y < floor_height + 20.0:
				target_pitch = 0x954
			elif max_altitude < world.origin.y:
				target_pitch = 0x2154
			else:
				if rand < 0.35:
					target_pitch = 0x954
				else:
					target_pitch = 0x2154
		else:
			if bg_check_flags & BGCHECKFLAG_GROUND:
				target_pitch = 0x954
			elif bg_check_flags & BGCHECKFLAG_CEILING or max_altitude < world.origin.y:
				target_pitch = 0x2154

		if bg_check_flags & BGCHECKFLAG_WALL:
			global_rotation.y = smooth_step_to_s(global_rotation.y, wall_yaw, 2, 0xC00, 0x300)

		if timer == 0 and dist_to_er_xz < 200.0 and er_get_mask() != ER_MASK_SKULL:
			EnFirefly_SetupDiveAttack()

func EnFirefly_Fall():
	if skel_anime_on_frame(6.0):
		pass
		#skel_anime._speed = 0.0

	color_filter_timer = 40
	#skel_anime_update()
	speed = Math.step_to_f(speed, 0.0, 0.5)
	if flags & ACTOR_FLAG_15:
		color_filter_timer = 40
	else:
		global_rotation.x = step_to_s(global_rotation.x, 0x6800, 0x200)
		global_rotation.y -= 0x300

	timer -= 1
	if bg_check_flags & BGCHECKFLAG_GROUND or timer == 0:
		EnFirefly_SetupDie()

func EnFirefly_Die():
	timer -= 1
	scale = Vector3.ONE* step(scale.x, 0.0, 0.00034)
 
	if timer == 0:
		item_drop_collectible_random( world.origin, 0xE0)
		queue_free()

func EnFirefly_DiveAttack():
	var er = get_er()
	var prey_origin = er.origin + Vector3(0, 20.0, 0)

	#skel_anime_update()
	timer -= 1
	speed = Math.step_to_f(speed, 4.0, 0.5)

	if bg_check_flags & BGCHECKFLAG_WALL:
		global_rotation.y = smooth_step_to_s(global_rotation.y, wall_yaw, 2, 0xC00, 0x300)
		global_rotation.x = step_to_s(global_rotation.x, target_pitch, 0x100)
	elif is_facing_er(0x2800):
		if skel_anime_on_frame(4.0):
			#skel_anime._speed = 0.0
			skel_anime.cur_frame = 4.0

		global_rotation.y = smooth_step_to_s(global_rotation.y, yaw_towards_er, 2, 0xC00, 0x300)
		global_rotation.x = smooth_step_to_s(global_rotation.x, pitch_toward_point(world.origin, prey_origin) + 0x1554, 2, 0x400, 0x100)
	else:
		#skel_anime._speed = 1.5
		if dist_to_er_xz > 80.0:
			global_rotation.y = smooth_step_to_s(global_rotation.y, yaw_towards_er, 2, 0xC00, 0x300)

		if bg_check_flags & BGCHECKFLAG_GROUND:
			target_pitch = 0x954
		elif bg_check_flags & BGCHECKFLAG_CEILING or max_altitude < world.origin.y:
			target_pitch = 0x2154
		else:
			target_pitch = 0x954

		global_rotation.x = step_to_s(global_rotation.x, target_pitch, 0x100)

	if timer == 0 or er_get_mask() == ER_MASK_SKULL:
		EnFirefly_SetupFlyAway()

func EnFirefly_Rebound():
	#skel_anime_update()
	global_rotation.x = step_to_s(global_rotation.x, 0, 0x100)
	my_velocity.y = Math.step_to_f(my_velocity.y, 0.0, 0.4)

	if Math.step_to_f(speed, 0.0, 0.15):
		timer -= 1
		if timer == 0:
			EnFirefly_SetupFlyAway()

func EnFirefly_FlyAway():
	#skel_anime_update()
	timer -= 1

	if abs(world.origin.y - max_altitude) < 10.0 and dist_to_home_xz < 20.0 or timer == 0:
		EnFirefly_SetupFlyIdle()
		return

	speed = Math.step_to_f(speed, 3.0, 0.3)

	if bg_check_flags & BGCHECKFLAG_GROUND:
		target_pitch = 0x954
	elif bg_check_flags & BGCHECKFLAG_CEILING or max_altitude < world.origin.y:
		target_pitch = 0x2154
	else:
		target_pitch = 0x954

	if bg_check_flags & BGCHECKFLAG_WALL:
		global_rotation.y = smooth_step_to_s(global_rotation.y, wall_yaw, 2, 0xC00, 0x300)
	else:
		global_rotation.y = step_to_s(global_rotation.y, yaw_toward_point(world.origin, home.origin), 0x300)

	global_rotation.x = step_to_s(global_rotation.x, target_pitch, 0x100)

func EnFirefly_Stunned():
	#skel_anime_update()
	speed = Math.step_to_f(speed, 0.0, 0.5)
	global_rotation.x = step_to_s(global_rotation.x, 0x1554, 0x100)

	timer -= 1
	if timer == 0:
		if on_fire:
			aura_type = KEESE_AURA_FIRE
		elif params == KEESE_ICE_FLY:
			aura_type = KEESE_AURA_ICE
		EnFirefly_SetupFlyIdle()

func EnFirefly_FrozenFall():
	if bg_check_flags & BGCHECKFLAG_GROUND or floor_height == BGCHECK_Y_MIN:
		color_filter_timer = 0
		EnFirefly_SetupDie()
	else:
		color_filter_timer = 255

func EnFirefly_Perch():
	global_rotation.x = step_to_s(global_rotation.x, 0, 0x100)

	if timer != 0:
		#skel_anime_update()
		if skel_anime_on_frame(6.0):
			timer -= 1
	elif randf_range(0,1) < 0.02:
		timer = 1

	if dist_to_er_xz < 120.0:
		EnFirefly_SetupDisturbDiveAttack()

func EnFirefly_DisturbDiveAttack():
	var er = get_er()
	var prey_origin = er.origin + Vector3(0, 20.0, 0)

	#skel_anime_update()

	timer -= 1

	if timer < 40:
		global_rotation.x = step_to_s(global_rotation.x, -0xAAC, 0x100)
	else:
		global_rotation.x = step_to_s(global_rotation.x, pitch_toward_point(world.origin, prey_origin) + 0x1554, 0x100)
		global_rotation.y = step_to_s(global_rotation.y, yaw_towards_er, 0x300)

	if timer == 0:
		EnFirefly_SetupFlyIdle()

func EnFirefly_Combust():
	for i in range(3):
		effect_ss_en_fire_spawn_vec3f(world.origin, 40, 0, 0, i)

	aura_type = KEESE_AURA_NONE

func EnFirefly_UpdateDamage():
	if collider.base.ac_flags & AC_HIT:
		collider.base.ac_flags &= ~AC_HIT
		set_drop_flag(collider.elements[0].base, true)

		if col_chk_info.damage_effect != 0 or col_chk_info.damage != 0:
			if not apply_damage():
				enemy_start_finishing_blow()
				flags &= ~ACTOR_FLAG_0

			damage_effect = col_chk_info.damage_effect

			if damage_effect == 2:
				if params == KEESE_ICE_FLY:
					col_chk_info.health = 0
					enemy_start_finishing_blow()
					EnFirefly_Combust()
					EnFirefly_SetupFall()
				elif not on_fire:
					EnFirefly_Ignite()
					if state == EnFirefly_Perch:
						EnFirefly_SetupFlyIdle()
			elif damage_effect == 3:
				if params == KEESE_ICE_FLY:
					EnFirefly_SetupFall()
				else:
					EnFirefly_SetupFrozenFall()
			elif damage_effect == 1:
				if state != EnFirefly_Stunned:
					EnFirefly_SetupStunned()
			else:
				if damage_effect == 0xF and params == KEESE_ICE_FLY:
					EnFirefly_Combust()
				EnFirefly_SetupFall()

func EnFirefly_Update(delta):
	if collider.base.at_flags & AT_HIT:
		collider.base.at_flags &= ~AT_HIT
		#_sfx(NA_SE_EN_FFLY_ATTACK)
		if on_fire:
			EnFirefly_Extinguish()
		if state != EnFirefly_DisturbDiveAttack:
			EnFirefly_SetupRebound()

	EnFirefly_UpdateDamage()

	state()

	if not flags & ACTOR_FLAG_15:
		if col_chk_info.health == 0 or state == EnFirefly_Stunned:
			move_xz_gravity()
		else:
			world.rot.x = 0x1554 - global_rotation.x
			move_xyz()

	update_bg_check_info()
	collider.elements[0].dim.world_sphere.center = world.origin + Vector3(0, 10.0, 0)

	if state == EnFirefly_DiveAttack or state == EnFirefly_DisturbDiveAttack:
		collision_check_set_at(collider.base)

	if col_chk_info.health != 0:
		collision_check_set_ac( collider.base)
		world.rot.y = global_rotation.y
		if skel_anime_on_frame(5.0):
			pass
			#_sfx(NA_SE_EN_FFLY_FLY)

	collision_check_set_oc( collider.base)
	focus.origin = world.origin + Vector3(Math.sin(global_rotation.x) * Math.sin(global_rotation.y), Math.cos(global_rotation.x), Math.sin(global_rotation.x) * Math.cos(global_rotation.y)) * 10.0
