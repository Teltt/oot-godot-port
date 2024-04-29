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
@onready var test:CollisionTest = $Test
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
	params = init_params
	if params == ARROW_CS_NUT:
		is_cs_nut = true
		params = ARROW_NUT
	if params <= ARROW_SEED:
		pass
	state = ( shoot)

func _exit_tree() -> void:
	if is_queued_for_deletion():
		if hit_actor != null and hit_actor.is_processing():
			hit_actor = null
			
			release.emit()


func shoot(_delta):
	if parent == null:
		#if params != ARROW_NUT: #and player.unk_A73 == 0:
		#	queue_free()
		#	return
		state = ( fly)
		if params == ARROW_SEED:
			$slingshot_sfx.play()
		elif params == ARROW_NORMAL or params == ARROW_NORMAL_HORSE or ARROW_NORMAL_LIT:
			$arrow_shot_sfx.play()
		elif params == ARROW_FIRE or params == ARROW_ICE or params == ARROW_LIGHT:
			$magic_arrow_shot_sfx.play()
		unk_210 = world.origin
		if params >= ARROW_SEED:
			SetProjectileSpeed(80.0)
			timer = 15
		else:
			SetProjectileSpeed(150.0)
			timer = 12

func fly(_delta):
	if timer <= 0:
		queue_free()
		return
	if timer < 7.2000003:
		gravity = -0.4
	timer -=_delta
	var at_touched = params >= ARROW_SEED and params <= ARROW_SEED 
	if at_touched or touched_poly:
		if params >= ARROW_SEED:
			if at_touched:
				world.origin.x = (world.origin.x + prevPos.origin.x) * 0.5
				world.origin.y = (world.origin.y + prevPos.origin.y) * 0.5
				world.origin.z = (world.origin.z + prevPos.origin.z) * 0.5
			if params == ARROW_NUT:
				## R_TRANS_FADE_FLASH_ALPHA_STEP = -1
				## Actor_Spawn(&play->actorCtx, play, ACTOR_EN_M_FIRE1, world.origin.x, world.origin.y, world.origin.z, 0, 0, 0, 0)
				
				$dekunut_sfx.play()
			else:
				$sling_reflect.play()
			queue_free()
		else:
			pass
			#EffectSsHitMark_SpawnCustomScale(play, 150, world.origin)
			#
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
		test.global_position = prevPos.origin
		test.target_position =-(prevPos.origin-world.origin)
		prevPos = world
		if test.is_colliding():
			#func_8002F9EC(wall_poly, bg_id, hit_point)
			#pos_copy = world.origin'
			if not hit_actor:
				world.origin = test.get_collision_point(0)
		if params <= ARROW_0E:
			rotation.x = atan2(speed, -my_velocity.y)
	if hit_actor != null:
		if hit_actor.is_processing():
			var sp60 = unk_210 + unk_250
			var sp54 = world.origin + unk_250
			if not test.shape:
				test.shape = SphereShape3D.new()
				test.shape.radius = 0.01

func func_809B4640(_delta):
   # SkelAnime_Update(&this->skelAnime);
	MoveXZGravity(_delta);
	timer -=1
	if (timer <= 0):
		queue_free();
func func_809B3CEC():
	state = (func_809B4640)
	#Animation_PlayOnce(skel_anime, gArrow1Anim)
	rotation.y += roundf(24576.0 * (randf_range(0,1) - 0.5) + 0x8000)
	my_velocity.y += speed * (0.4 + 0.4 * randf_range(0,1))
	speed *= 0.04 + 0.3 * randf_range(0,1)
	timer = 50
	gravity = -1.5
signal carry(actor)
signal release
@export var carry_distance:float = 10
var carry_origin:Vector3
var carried = 0
func EnArrow_CarryActor():
	
	if not $Igrab.holding and carried== 0:
		carried = 2
		carry_origin = world.origin
		carry.emit(hit_actor)
signal process_carried
func _process(_delta: float) -> void:
	super(_delta)
func _physics_process(_delta: float) -> void:
	process_carried.emit()
	if is_cs_nut or (params >= ARROW_NORMAL_LIT):# and player.unk_A73 != 0):# or not Player_InBlockingCsMode(play, player):
		state.call(_delta)
	carried = maxi(carried,0)
	if carry_origin.distance_to(world.origin) >= carry_distance:
		hit_actor = null
		release.emit()
	if params >= ARROW_FIRE and params <= ARROW_0E:
		#elemental_actor_ids = [ACTOR_ARROW_FIRE, ACTOR_ARROW_ICE, ACTOR_ARROW_LIGHT, ACTOR_ARROW_FIRE, ACTOR_ARROW_FIRE, ACTOR_ARROW_FIRE]
		if child == null:
			child = preload("res://translated_actor/Scene/arrow_fire.tscn").instantiate()
			#Actor_SpawnAsChild(play, self, elemental_actor_ids[params - 3], world.origin.x, world.origin.y, world.origin.z, 0, 0, 0, 0)
	#elif params == ARROW_NORMAL_LIT:
		# func_8002836C(play, &unk_21C, &my_velocity, &accel, &prim_color, &env_color, 100, 0, 8)

static var D_809B4E88 = Vector3( 0.0, 400.0, 1500.0);
static var D_809B4E94 = Vector3( 0.0, -400.0, 1500.0);
static var D_809B4EA0 = Vector3(0.0, 0.0, -300.0)
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



func _on_ihit_hit(_hitter: Variant, hitspot: Variant) -> void:
	if state == fly:
				hit_actor = hitspot.actor
				if hit_actor.is_processing() :# and hit_actor.flags & ACTOR_FLAG_14
					
					EnArrow_CarryActor()
				else:
					hit_flags |= 1
					hit_flags |= 2
					world.origin = hitspot.global_position
					func_809B3CEC()
					$arrowstick_sfx.play()
	pass # Replace with function body.
