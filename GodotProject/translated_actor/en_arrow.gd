extends Actor

class_name EnArrow
const ARROW_CS_NUT = -10
const ARROW_NORMAL_SILENT = -1
const ARROW_NORMAL_LIT = 0
const ARROW_NORMAL_HORSE = 1
const ARROW_NORMAL = 2
const ARROW_FIRE = 3
const ARROW_ICE = 4
const ARROW_LIGHT = 5
const ARROW_0C = 6
const ARROW_0D = 7
const ARROW_0E = 8
const ARROW_SEED = 9
const ARROW_NUT = 10
@onready var test:ShapeCast3D = $Test
@onready var player:Actor:
	get:
		return get_tree().get_first_node_in_group("player")
var is_cs_nut = false
var state = null
var skel_anime = null
var collider = null
var effect_index = null
var hit_actor = null
var hit_flags = 0
var unk_210 = Vector3()
var unk_21c = Vector3()
var unk_250 = Vector3()
var touched_poly = false
var weapon_info# = WeaponInfo()
var timer = 0
var init_params = ARROW_FIRE
func _ready():
	var params = init_params
	if params == ARROW_CS_NUT:
		is_cs_nut = true
		params = ARROW_NUT
	if params <= ARROW_SEED:
		pass
		#if params <= ARROW_0E:
		#	SkelAnime_Init(play, self.skel_anime, gArrowSkel, gArrow2Anim, null, null, 0)
		#if params <= ARROW_NORMAL:
			#if params == ARROW_NORMAL_HORSE:
				#blure_normal.elem_duration = 4
			#else:
				#blure_normal.elem_duration = 16
			## Effect_Add(play, &self.effect_index, EFFECT_BLURE2, 0, 0, &blure_normal)
		#elif params == ARROW_FIRE:
			## Effect_Add(play, &self.effect_index, EFFECT_BLURE2, 0, 0, &blure_fire)
		#elif params == ARROW_ICE:
			## Effect_Add(play, &self.effect_index, EFFECT_BLURE2, 0, 0, &blure_ice)
		#elif params == ARROW_LIGHT:
			## Effect_Add(play, &self.effect_index, EFFECT_BLURE2, 0, 0, &blure_light)
		#Collider_InitQuad(play, self.collider)
		#Collider_SetQuad(play, self.collider, self, &sColliderInit)
		#if params <= ARROW_NORMAL:
			#self.collider.elem.at_elem_flags &= ~ATELEM_SFX_MASK
			#self.collider.elem.at_elem_flags |= ATELEM_SFX_NORMAL
		#if params < 0:
			#self.collider.base.at_flags = (AT_ON | AT_TYPE_ENEMY)
		#else:
			#self.collider.elem.at_dmg_info.dmg_flags = dmg_flags[params]
	state = ( shoot)

func _exit_tree() -> void:
	if is_queued_for_deletion():
		#if params <= ARROW_LIGHT:
			# Effect_Delete(play, self.effect_index)
		#SkelAnime_Free(self.skel_anime, play)
		#Collider_DestroyQuad(play, self.collider)
		if hit_actor != null and hit_actor.is_processing():
			hit_actor.flags &= ~ACTOR_FLAG_15


func shoot(_delta):
	player
	if parent == null:
		#if params != ARROW_NUT: #and player.unk_A73 == 0:
		#	queue_free()
		#	return
		#match params:
			#ARROW_SEED:
				#Player_PlaySfx(player, NA_SE_IT_SLING_SHOT)
			#ARROW_NORMAL_LIT, ARROW_NORMAL_HORSE, ARROW_NORMAL:
				#Player_PlaySfx(player, NA_SE_IT_ARROW_SHOT)
			#ARROW_FIRE, ARROW_ICE, ARROW_LIGHT:
				#Player_PlaySfx(player, NA_SE_IT_MAGIC_ARROW_SHOT)
		state = ( fly)
		unk_210 = world.origin
		if params >= ARROW_SEED:
			SetProjectileSpeed(80.0)
			timer = 15
			shape.rot = Vector3()
		else:
			SetProjectileSpeed(150.0)
			timer = 12

func fly(_delta):
	if timer <= 0:
		queue_free()
		return
	if timer < 7.2000003:
		gravity = -0.4
	var at_touched = params >= ARROW_SEED and params <= ARROW_SEED #and collider.base.at_flags & AT_HIT
	if at_touched or touched_poly:
		if params >= ARROW_SEED:
			if at_touched:
				world.origin.x = (world.origin.x + prevPos.origin.x) * 0.5
				world.origin.y = (world.origin.y + prevPos.origin.y) * 0.5
				world.origin.z = (world.origin.z + prevPos.origin.z) * 0.5
			#if params == ARROW_NUT:
				## R_TRANS_FADE_FLASH_ALPHA_STEP = -1
				## Actor_Spawn(&play->actorCtx, play, ACTOR_EN_M_FIRE1, world.origin.x, world.origin.y, world.origin.z, 0, 0, 0, 0)
				#sfx_id = NA_SE_IT_DEKU
			#else:
				#sfx_id = NA_SE_IT_SLING_REFLECT
			## EffectSsStone1_Spawn(play, &world.origin, 0)
			#SfxSource_PlaySfxAtFixedWorldPos(play, world.origin, 20, sfx_id)
			queue_free()
		else:
			pass
			#EffectSsHitMark_SpawnCustomScale(play, 150, world.origin)
			#if at_touched and collider.elem.at_hit_elem.elem_type != ELEMTYPE_UNK4:
				#hit_actor = collider.base.at
				#if hit_actor.is_processing() and not collider.base.at_flags & AT_BOUNCED and hit_actor.flags & ACTOR_FLAG_14:
					#hit_actor = hit_actor
					#EnArrow_CarryActor(self, play)
					#hit_actor.flags |= ACTOR_FLAG_15
					#collider.base.at_flags &= ~AT_HIT
					#speed /= 2.0
					#velocity.y /= 2.0
				#else:
					#hit_flags |= 1
					#hit_flags |= 2
					#if collider.elem.at_hit_elem.ac_elem_flags & ACELEM_HIT:
						#world.origin = collider.elem.at_hit_elem.ac_dmg_info.hit_pos
					#func_809B3CEC(play, self)
					#Actor_PlaySfx(self, NA_SE_IT_ARROW_STICK_CRE)
			#elif touched_poly:
				#state = ( func_809B45E0)
				#Animation_PlayOnce(skel_anime, gArrow2Anim)
				#if params >= ARROW_NORMAL_LIT:
					#timer = 60
				#else:
					#timer = 20
				#Actor_PlaySfx(self, NA_SE_IT_ARROW_STICK_OBJ)
				#hit_flags |= 1
	else:
		unk_210 = world.origin
		MoveXZGravity(_delta)
		if not test.shape:
			test.shape = SphereShape3D.new()
			test.shape.radius = 0.01
		test.target_position =-(prevPos.origin-world.origin)
		test.force_shapecast_update()
		if test.is_colliding():
			#func_8002F9EC(play, self, wall_poly, bg_id, hit_point)
			#pos_copy = world.origin
			world.origin = test.get_collision_point(0)
		if params <= ARROW_0E:
			rotation.x = atan2(speed, -velocity.y)
	if hit_actor != null:
		if hit_actor.is_processing():
			var sp60 = unk_210 + unk_250
			var sp54 = world.origin + unk_250
			if not test.shape:
				test.shape = SphereShape3D.new()
				test.shape.radius = 0.01
			test.target_position =-(sp60-sp54)
			test.force_shapecast_update()
			if test.is_colliding():
				var hit_point = test.get_collision_point(0)
				hit_actor.world.origin.x = hit_point.x + ( 1.0 if (sp54.x <= hit_point.x) else -1.0)
				hit_actor.world.origin.y = hit_point.y +  ( 1.0 if (sp54.y <= hit_point.y) else -1.0)
				hit_actor.world.origin.z = hit_point.z +  ( 1.0 if (sp54.z <= hit_point.z) else -1.0)
				unk_250 = hit_actor.world.origin - world.origin
				hit_actor.flags &= ~ACTOR_FLAG_15
				hit_actor = null
			else:
				hit_actor.world.origin = sp54
			if touched_poly and hit_actor != null:
				hit_actor.flags &= ~ACTOR_FLAG_15
				hit_actor = null
func func_809B4640(_delta):
   # SkelAnime_Update(&this->skelAnime);
	MoveXZGravity(_delta);
	timer -=1
	if (timer == 0):
		queue_free();
func func_809B3CEC():
	state = (func_809B4640)
	#Animation_PlayOnce(skel_anime, gArrow1Anim)
	rotation.y += roundf(24576.0 * (randf_range(0,1) - 0.5) + 0x8000)
	velocity.y += speed * (0.4 + 0.4 * randf_range(0,1))
	speed *= 0.04 + 0.3 * randf_range(0,1)
	timer = 50
	gravity = -1.5

func EnArrow_CarryActor():
	var hit_poly = null
	var hit_point = Vector3()
	var pos_diff_last_frame = world.origin - unk_210
	var temp_f12 = (world.origin.x - hit_actor.world.origin.x) * pos_diff_last_frame.x + (world.origin.y - hit_actor.world.origin.y) * pos_diff_last_frame.y + (world.origin.z - hit_actor.world.origin.z) * pos_diff_last_frame.z
	if temp_f12 < 0.0:
		var sca = pos_diff_last_frame.length_squared()
		if sca < 1.0:
			scale = Vector3.ONE *(temp_f12 / sca)
			pos_diff_last_frame *= sca
			var actor_next_pos = hit_actor.world.origin + pos_diff_last_frame
			if not test.shape:
				test.shape = SphereShape3D.new()
				test.shape.radius = 0.01
			test.target_position =-( hit_actor.world.origin- actor_next_pos)
			test.force_shapecast_update()
			if test.is_colliding():
				hit_point = test.get_collision_point(0)
				hit_actor.world.origin.x = hit_point.x + ( 1.0 if (actor_next_pos.x <= hit_point.x)else  -1.0)
				hit_actor.world.origin.y = hit_point.y + ( 1.0 if (actor_next_pos.y <= hit_point.y)else  -1.0)
				hit_actor.world.origin.z = hit_point.z + ( 1.0 if (actor_next_pos.z <= hit_point.z)else  -1.0)
			else:
				hit_actor.world.origin = actor_next_pos

func _physics_process(_delta: float) -> void:
	if is_cs_nut or (params >= ARROW_NORMAL_LIT):# and player.unk_A73 != 0):# or not Player_InBlockingCsMode(play, player):
		state.call(_delta)
	if params >= ARROW_FIRE and params <= ARROW_0E:
		#elemental_actor_ids = [ACTOR_ARROW_FIRE, ACTOR_ARROW_ICE, ACTOR_ARROW_LIGHT, ACTOR_ARROW_FIRE, ACTOR_ARROW_FIRE, ACTOR_ARROW_FIRE]
		if child == null:
			child = preload("res://translated_actor/Scene/arrow_fire.tscn").instantiate()
			#Actor_SpawnAsChild(play, self, elemental_actor_ids[params - 3], world.origin.x, world.origin.y, world.origin.z, 0, 0, 0, 0)
	#elif params == ARROW_NORMAL_LIT:
		# func_8002836C(play, &unk_21C, &velocity, &accel, &prim_color, &env_color, 100, 0, 8)

func func_809B4800():
	pass
	#if state == fly:
		#var sp44 = D_809B4E88 * world.rot
		#var sp38 = D_809B4E94 * world.rot
		#if params <= ARROW_SEED:
			#add_blure_vertex = params <= ARROW_LIGHT
			#if hit_actor == null:
				#add_blure_vertex &= func_80090480(play, collider, weapon_info, sp44, sp38)
			#else:
				#if add_blure_vertex:
					#if sp44 == weapon_info.tip and sp38 == weapon_info.base:
						#add_blure_vertex = false
			#if add_blure_vertex:
				# EffectBlure_AddVertex(Effect_GetByIndex(effect_index), &sp44, &sp38)

func EnArrow_Draw():
	pass
	# if params <= ARROW_0E:
		#Gfx_SetupDL_25Opa(play.state.gfxCtx)
		#SkelAnime_DrawLod(play, skel_anime.skeleton, skel_anime.joint_table, null, null, self, (projected_pos.z < MREG(95)) ? 0 : 1)
	#elif speed != 0.0:
		#alpha = (Math_CosS(timer * 5000) * 127.5 + 127.5).round()
		#OPEN_DISPS(play.state.gfxCtx)
		#Gfx_SetupDL_25Xlu2(play.state.gfxCtx)
		#if params == ARROW_SEED:
			#gDPSetPrimColor(POLY_XLU_DISP, 0, 0, 255, 255, 255, 255)
			#gDPSetEnvColor(POLY_XLU_DISP, 0, 255, 255, alpha)
			#scale = 50.0
		#else:
			#gDPSetPrimColor(POLY_XLU_DISP, 0, 0, 12, 0, 0, 255)
			#gDPSetEnvColor(POLY_XLU_DISP, 250, 250, 0, alpha)
			#scale = 150.0
		#Matrix_Push()
		#Matrix_Mult(billboard_mtxf, MTXMODE_APPLY)
		#if speed == 0.0:
			#Matrix_RotateZ(0.0, MTXMODE_APPLY)
		#else:
			#Matrix_RotateZ((play.gameplay_frames & 0xFF) * 4000, MTXMODE_APPLY)
		#Matrix_Scale(scale, scale, scale, MTXMODE_APPLY)
		#gSPMatrix(POLY_XLU_DISP, MATRIX_NEW(play.state.gfxCtx), G_MTX_NOPUSH | G_MTX_LOAD | G_MTX_MODELVIEW)
		#gSPDisplayList(POLY_XLU_DISP, gEffSparklesDL)
		#Matrix_Pop()
		#Matrix_RotateY(world.rot.y, MTXMODE_APPLY)
		#CLOSE_DISPS(play.state.gfxCtx)
	#func_809B4800(self, play)
