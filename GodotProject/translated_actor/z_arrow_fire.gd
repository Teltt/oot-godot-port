extends Actor

class_name ArrowFire

var actor = self
var unkPos:Vector3
var radius: float = 0
var unk_158: float = 1.0
var state: Callable
var alpha: int = 160
var timer: int = 0
var unk_15C: float = 0.0

var FLAGS = (ACTOR_FLAG_4 | ACTOR_FLAG_25)

#var Arrow_Fire_InitVars: Dictionary = {
	#ACTOR_ARROW_FIRE,
	#ACTORCAT_ITEMACTION,
	#FLAGS,
	#OBJECT_GAMEPLAY_KEEP,
	#sizeof(ArrowFire),
	#ArrowFire_Init,
	#ArrowFire_Destroy,
	#ArrowFire_Update,
	#ArrowFire_Draw,
#}
#
#static var sInitChain: Array = [
	#ICHAIN_F32(uncullZoneForward, 2000, ICHAIN_STOP),
#]


func _ready() -> void:
	#Actor_ProcessInitChain(sInitChain)
	radius = 0
	unk_158 = 1.0
	state =(charge)
	scale = Vector3.ONE * 0.01
	alpha = 160
	timer = 0
	unk_15C = 0.0

func _exit_tree() -> void:
	if is_queued_for_deletion():
		pass
		# Magic_Reset(play)
		 # LOG_STRING("消滅", "../z_arrow_fire.c", 421)

func charge(_delta):
	var arrow: Actor= parent
	if arrow == null or not arrow.is_processing():
		queue_free()
		return

	if radius < 10:
		radius += 1

	#world = arrow.world

	#func_8002F974(NA_SE_PL_ARROW_CHARGE_FIRE - SFX_FLAG)
	
	if parent.parent == null:
		unkPos = world.origin
		radius = 10
		state =(fly)
		alpha = 255

func func_80865ECC( firePos: Vector3, sc: float):
	unkPos.x += (firePos.x - unkPos.x) * sc
	unkPos.y += (firePos.y - unkPos.y) * sc
	unkPos.z += (firePos.z - unkPos.z) * sc

func hit(_delta):
	var offset
	if projectedPos.w < 50.0:
		scale = Vector3.ONE*10.0
	else:
		scale = Vector3.ONE*projectedPos.w 
		scale = Vector3.ONE*(((scale.x - 50.0) * (1.0 / 3.0)) + 10.0)

	timer = self.timer
	if timer != 0:
		self.timer -= 1

		if self.timer >= 8:
			offset = (self.timer - 8) * (1.0 / 24.0)
			offset = offset * offset
			radius = ((1.0 - offset) * scale) + 10.0
			unk_158 += (2.0 - unk_158) * 0.1
			if self.timer < 16:
				alpha = (self.timer * 0x23) - 0x118

	if self.timer >= 9:
		if unk_15C < 1.0:
			unk_15C += 0.25
	else:
		if unk_15C > 0.0:
			unk_15C -= 0.125

	if self.timer < 8:
		alpha = 0

	if self.timer == 0:
		self.timer = 255
		queue_free()

func fly(_delta):
	var arrow:Actor = parent
	if arrow == null or arrow.update == null:
		queue_free()
		return

	#world.origin = arrow.world.origin
	#shape.rot = arrow.shape.rot
	var distanceScaled: float = unkPos.distance_to(world.origin) * (1.0 / 24.0)
	unk_158 = distanceScaled
	if distanceScaled < 1.0:
		unk_158 = 1.0
	func_80865ECC(world.origin, 0.05)

	if arrow.hitFlags & 1:
		#Actor_PlaySfx(NA_SE_IT_EXPLOSION_FRAME)
		state =(hit)
		timer = 32
		alpha = 255
	elif arrow.timer < 34:
		if alpha < 35:
			queue_free()
		else:
			alpha -= 0x19

func _physics_process(_delta: float) -> void:
	#if play.msgCtx.msgMode == MSGMODE_OCARINA_CORRECT_PLAYBACK or play.msgCtx.msgMode == MSGMODE_SONG_PLAYED:
	#	queue_free()
	#	return

	state.call(_delta)
#
#func ArrowFire_Draw():
	#if timer >= 255:
		#return
#
	#var transform: Actor
	#var arrow: EnArrow = parent as EnArrow
#
	#if arrow == null or arrow.update == null:
		#return
#
	#if arrow.hitFlags & 2:
		#transform = actor
	#else:
		#transform = arrow.actor
#
	#OPEN_DISPS(play.state.gfxCtx, "../z_arrow_fire.c", 618)
#
	#Matrix_Translate(transform.world.origin.x, transform.world.origin.y, transform.world.origin.z, MTXMODE_NEW)
	#Matrix_RotateY(BINANG_TO_RAD(transform.shape.rot.y), MTXMODE_APPLY)
	#Matrix_RotateX(BINANG_TO_RAD(transform.shape.rot.x), MTXMODE_APPLY)
	#Matrix_RotateZ(BINANG_TO_RAD(transform.shape.rot.z), MTXMODE_APPLY)
	#Matrix_Scale(0.01, 0.01, 0.01, MTXMODE_APPLY)
#
	#if unk_15C > 0:
		#POLY_XLU_DISP = Gfx_SetupDL_57(POLY_XLU_DISP)
		#gDPSetPrimColor(POLY_XLU_DISP, 0, 0, int(40.0 * unk_15C) & 0xFF, 0, 0, int(150.0 * unk_15C) & 0xFF)
		#gDPSetAlphaDither(POLY_XLU_DISP, G_AD_DISABLE)
		#gDPFillRectangle(POLY_XLU_DISP, 0, 0, SCREEN_WIDTH - 1, SCREEN_HEIGHT - 1)
#
	#Gfx_SetupDL_25Xlu(play.state.gfxCtx)
	#gDPSetPrimColor(POLY_XLU_DISP, 0x80, 0x80, 255, 200, 0, alpha)
	#gDPSetEnvColor(POLY_XLU_DISP, 255, 0, 0, 128)
	#Matrix_RotateZYX(0x4000, 0x0, 0x0, MTXMODE_APPLY)
	#if timer != 0:
		#Matrix_Translate(0.0, 0.0, 0.0, MTXMODE_APPLY)
	#else:
		#Matrix_Translate(0.0, 1500.0, 0.0, MTXMODE_APPLY)
	#Matrix_Scale(radius * 0.2, unk_158 * 4.0, radius * 0.2, MTXMODE_APPLY)
	#Matrix_Translate(0.0, -700.0, 0.0, MTXMODE_APPLY)
	#gSPMatrix(POLY_XLU_DISP, MATRIX_NEW(play.state.gfxCtx, "../z_arrow_fire.c", 666), G_MTX_NOPUSH | G_MTX_LOAD | G_MTX_MODELVIEW)
	#gSPDisplayList(POLY_XLU_DISP, sMaterialDL)
	#gSPDisplayList(POLY_XLU_DISP, Gfx_TwoTexScroll(play.state.gfxCtx, G_TX_RENDERTILE, 255 - (state.frames * 2) % 256, 0, 64, 32, 1, 255 - state.frames % 256, 511 - (state.frames * 10) % 512, 64, 64))
	#gSPDisplayList(POLY_XLU_DISP, sModelDL)
#
	#CLOSE_DISPS(play.state.gfxCtx, "../z_arrow_fire.c", 682)
