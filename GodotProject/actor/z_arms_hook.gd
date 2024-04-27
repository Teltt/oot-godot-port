extends Actor
class_name ArmsHook

var actor = self
var collider:CollisionShape3D
var hookInfo;#WeaponInfo 
var unk_1E8:Vector3 ;
var unk_1F4:Vector3 ;
var grabbed:Actor;
var grabbedDistDiff:Vector3;
var timer:int;
var actionFunc;

var FLAGS = (ACTOR_FLAG_4 | ACTOR_FLAG_5)


var Arms_Hook_InitVars:Dictionary ={
	#ACTOR_ARMS_HOOK,
	#ACTORCAT_ITEMACTION,
	#FLAGS,
	#OBJECT_LINK_BOY,
	#sizeof(ArmsHook),
	#ArmsHook_Init,
	#ArmsHook_Destroy,
	#ArmsHook_physics_process,
	#ArmsHook_process,
};

static var sQuadInit:Dictionary = {#ColliderQuadInit 
	#{
		#COLTYPE_NONE,
		#AT_ON | AT_TYPE_PLAYER,
		#AC_NONE,
		#OC1_NONE,
		#OC2_TYPE_PLAYER,
		#COLSHAPE_QUAD,
	#},
	#{
		#ELEMTYPE_UNK2,
		#{ 0x00000080, 0x00, 0x01 },
		#{ 0xFFCFFFFF, 0x00, 0x00 },
		#ATELEM_ON | ATELEM_NEAREST | ATELEM_SFX_NORMAL,
		#ACELEM_NONE,
		#OCELEM_NONE,
	#},
	#{ { { 0.0, 0.0, 0.0 }, { 0.0, 0.0, 0.0 }, { 0.0, 0.0, 0.0 }, { 0.0, 0.0, 0.0 } } },
};

static var sUnusedVec1 :Vector3= Vector3(0.0, 0.5, 0.0 );
static var sUnusedVec2 :Vector3= Vector3( 0.0, 0.5, 0.0 );

static var sUnusedColors= [#Color_RGB8 
	Color8(255, 255, 100),
	Color8( 255, 255, 50),
]

static var D_80865B70: Vector3 = Vector3( 0.0, 0.0, 0.0 );
static var D_80865B7C:Vector3  =Vector3(0.0, 0.0, 900.0 );
static var D_80865B88:Vector3  =Vector3( 0.0, 500.0, -3000.0 );
static var D_80865B94:Vector3  = Vector3( 0.0, -500.0, -3000.0 );
static var D_80865BA0:Vector3  = Vector3(0.0, 500.0, 1200.0 );
static var D_80865BAC:Vector3 = Vector3(0.0, -500.0, 1200.0 );

func ArmsHook_SetupAction(_actionFunc):
	actionFunc = _actionFunc;

func ArmsHook_Init() :
	

	#Collider_InitQuad(play, &self.collider);
	#Collider_SetQuad(play, &self.collider, &self.actor, &sQuadInit);
	ArmsHook_SetupAction();
	unk_1E8 = actor.world.pos;

func ArmsHook_Destroy() :
	

	if (self.grabbed != NULL):
		self.grabbed.flags &= ~ACTOR_FLAG_13;
	#Collider_DestroyQuad(play, &self.collider);

func ArmsHook_Wait():
	if (self.actor.parent == NULL):
		var player:Player = GET_PLAYER(play);
		#get correct timer length for hookshot or longshot
		var length:int =  13 if (player.heldItemAction == PLAYER_IA_HOOKSHOT) else 26;

		ArmsHook_SetupAction(this, ArmsHook_Shoot);
		Actor_SetProjectileSpeed(20.0);
		self.actor.parent = GET_PLAYER().actor;
		self.timer = length;

func func_80865044() :
	self.actor.child = self.actor.parent;
	self.actor.parent.parent = self.actor;

func ArmsHook_AttachToPlayer():
	player.actor.child = self.actor;
	player.heldActor = self.actor;
	if (self.actor.child != NULL):
		player.actor.parent = NULL;
		self.actor.child = NULL;
		return true;
	return false;

func ArmsHook_DetachHookFromActor():
	if (self.grabbed != NULL) :
		self.grabbed.flags &= ~ACTOR_FLAG_13;
		self.grabbed = NULL;

func ArmsHook_CheckForCancel() -> int:
	var player:Player = self.actor.parent;

	if (Player_HoldsHookshot(player)):
		if ((player.itemAction != player.heldItemAction) or (player.actor.flags & ACTOR_FLAG_TALK) or
			((player.stateFlags1 & (PLAYER_STATE1_7 | PLAYER_STATE1_26)))):
			self.timer = 0;
			ArmsHook_DetachHookFromActor(this);
			Math_Vector3_Copy(self.actor.world.pos, player.unk_3C8);
			return 1;
	return 0;
func ArmsHook_AttachHookToActor():
	actor.flags |= ACTOR_FLAG_13;
	self.grabbed = actor;
	Math_Vector3_Diff(actor.world.pos, self.actor.world.pos, self.grabbedDistDiff)

func ArmsHook_Shoot():
	var player = GET_PLAYER();

	if ((self.actor.parent == NULL) or (!Player_HoldsHookshot(player))):
		ArmsHook_DetachHookFromActor();
		Actor_Kill(self.actor);
		return;

	func_8002F8F0(player.actor, NA_SE_IT_HOOKSHOT_CHAIN - SFX_FLAG);
	ArmsHook_CheckForCancel(this);

	if ((self.timer != 0) and (self.collider.base.atFlags & AT_HIT) and
		(self.collider.elem.atHitElem.elemType != ELEMTYPE_UNK4)) :
		var touchedActor = self.collider.base.at;

		if ((touchedActor.physics_process != NULL) and (touchedActor.flags & (ACTOR_FLAG_9 | ACTOR_FLAG_10))):
			if (self.collider.elem.atHitElem.acElemFlags & ACELEM_HOOKABLE):
				ArmsHook_AttachHookToActor(this, touchedActor);
				if (CHECK_FLAG_ALL(touchedActor.flags, ACTOR_FLAG_10)):
					func_80865044(this);
		self.timer = 0;
		Audio_PlaySfxGeneral(NA_SE_IT_ARROW_STICK_CRE, self.actor.projectedPos, 4, gSfxDefaultFreqAndVolScale,
							 gSfxDefaultFreqAndVolScale, gSfxDefaultReverb);
		return;

	if (DECR(self.timer) == 0):
		var grabbed;
		var bodyDistDiffVec:Vector3;
		var newPos:Vector3;
		var  bodyDistDiff:float;
		var  phi_f16:float;
		var  pad1:int;
		var  curGrabbedDist:float;
		var  grabbedDist:float;
		var  velocity:float;

		grabbed = self.grabbed;
		if (grabbed != NULL) :
			if ((grabbed.physics_process == NULL) or !CHECK_FLAG_ALL(grabbed.flags, ACTOR_FLAG_13)) :
				grabbed = NULL;
				self.grabbed = NULL;
			elif (self.actor.child != NULL):
				curGrabbedDist = Actor_WorldDistXYZToActor(self.actor, grabbed);
				grabbedDist =sqrt(SQ(self.grabbedDistDiff.x) + SQ(self.grabbedDistDiff.y) + SQ(self.grabbedDistDiff.z));
				Math_Vector3_Diff(grabbed.world.pos, self.grabbedDistDiff, self.actor.world.pos);
				if ((curGrabbedDist - grabbedDist) > 50.0):
					ArmsHook_DetachHookFromActor(this);
					grabbed = NULL;
				
			
		

		bodyDistDiff = Math_Vector3_DistXYZAndStoreDiff(player.unk_3C8, self.actor.world.pos, bodyDistDiffVec);
		if (bodyDistDiff < 30.0):
			velocity = 0.0;
			phi_f16 = 0.0;
		else:
			if (self.actor.child != NULL):
				velocity = 30.0;
			elif (grabbed != NULL):
				velocity = 50.0;
			else:
				velocity = 200.0;
			
			phi_f16 = bodyDistDiff - velocity;
			if (bodyDistDiff <= velocity):
				phi_f16 = 0.0;
			
			velocity = phi_f16 / bodyDistDiff;
		

		newPos.x = bodyDistDiffVec.x * velocity;
		newPos.y = bodyDistDiffVec.y * velocity;
		newPos.z = bodyDistDiffVec.z * velocity;

		if (self.actor.child == NULL):
			if ((grabbed != NULL) and (grabbed.id == ACTOR_BG_SPOT06_OBJECTS)):
				Math_Vector3_Diff(grabbed.world.pos, self.grabbedDistDiff, self.actor.world.pos);
				phi_f16 = 1.0;
			else:
				Math_Vector3_Sum(player.unk_3C8, newPos, self.actor.world.pos);
				if (grabbed != NULL):
					Math_Vector3_Sum(self.actor.world.pos, self.grabbedDistDiff, grabbed.world.pos);
				
			
		else:
			Math_Vector3_Diff(bodyDistDiffVec, newPos, player.actor.velocity);
			player.actor.world.rot.x =Math_Atan2S(sqrtf(SQ(bodyDistDiffVec.x) + SQ(bodyDistDiffVec.z)), -bodyDistDiffVec.y);
		

		if (phi_f16 < 50.0):
			ArmsHook_DetachHookFromActor(this);
			if (phi_f16 == 0.0):
				ArmsHook_SetupAction(this, ArmsHook_Wait);
				if (ArmsHook_AttachToPlayer(this, player)):
					Math_Vector3_Diff(self.actor.world.pos, player.actor.world.pos, player.actor.velocity);
					player.actor.velocity.y -= 20.0;
				
			
		
	else:
		var poly;#CollisionPoly
		var bgId:int;
		var intersectPos:Vector3;
		var prevFrameDiff:Vector3;
		var sp60:Vector3;

		Actor_MoveXZGravity(self.actor);
		Math_Vector3_Diff(self.actor.world.pos, self.actor.prevPos, prevFrameDiff);
		Math_Vector3_Sum(self.unk_1E8, prevFrameDiff, self.unk_1E8);
		self.actor.shape.rot.x = Math_Atan2S(self.actor.speed, -self.actor.velocity.y);
		sp60.x = self.unk_1F4.x - (self.unk_1E8.x - self.unk_1F4.x);
		sp60.y = self.unk_1F4.y - (self.unk_1E8.y - self.unk_1F4.y);
		sp60.z = self.unk_1F4.z - (self.unk_1E8.z - self.unk_1F4.z);
		if (BgCheck_EntityLineTest1(play.colCtx, sp60, self.unk_1E8, intersectPos, poly, true, true, true, true,
									bgId) and
			!func_8002F9EC(play, self.actor, poly, bgId, intersectPos)):
			var polyNormalX:float = COLPOLY_GET_NORMAL(poly.normal.x);
			var polyNormalZ:float = COLPOLY_GET_NORMAL(poly.normal.z);
			var pad:int;

			Math_Vector3_Copy(self.actor.world.pos, intersectPos);
			self.actor.world.pos.x += 10.0 * polyNormalX;
			self.actor.world.pos.z += 10.0 * polyNormalZ;
			self.timer = 0;
			if (SurfaceType_CanHookshot(play.colCtx, poly, bgId)):
				DynaPolyActor* dynaPolyActor;

				if (bgId != BGCHECK_SCENE):
					dynaPolyActor = DynaPoly_GetActor(play.colCtx, bgId);
					if (dynaPolyActor != NULL):
						ArmsHook_AttachHookToActor(this, dynaPolyActor.actor);
					
				
				func_80865044(this);
				Audio_PlaySfxGeneral(NA_SE_IT_HOOKSHOT_STICK_OBJ, self.actor.projectedPos, 4,
									 gSfxDefaultFreqAndVolScale, gSfxDefaultFreqAndVolScale, gSfxDefaultReverb);
			else:
				CollisionCheck_SpawnShieldParticlesMetal(play, self.actor.world.pos);
				Audio_PlaySfxGeneral(NA_SE_IT_HOOKSHOT_REFLECT, self.actor.projectedPos, 4,
									 gSfxDefaultFreqAndVolScale, gSfxDefaultFreqAndVolScale, gSfxDefaultReverb);
			
		elif (CHECK_BTN_ANY(play.state.input[0].press.button,
								 (BTN_A | BTN_B | BTN_R | BTN_CUP | BTN_CLEFT | BTN_CRIGHT | BTN_CDOWN))):
			self.timer = 0;
		
	


func ArmsHook_physics_process():

	self.actionFunc(this, play);
	self.unk_1F4 = self.unk_1E8;


func ArmsHook_process():
	var pad;
	
	var player = GET_PLAYER(play);
	var sp78;
	var hookNewTip:Vector3;
	var hookNewBase:Vector3;
	var sp5C:float;
	var sp58:float;
#
	#if ((player.actor.process != NULL) and (player.rightHandType == PLAYER_MODELTYPE_RH_HOOKSHOT)):
		#OPEN_DISPS(play.state.gfxCtx, "../z_arms_hook.c", 850);
#
		#if (1):
#
		#if ((ArmsHook_Shoot != self.actionFunc) or (self.timer <= 0)):
			#Matrix_MultVector3(&D_80865B70, &self.unk_1E8);
			#Matrix_MultVector3(&D_80865B88, &hookNewTip);
			#Matrix_MultVector3(&D_80865B94, &hookNewBase);
			#self.hookInfo.active = 0;
		 #else:
			#Matrix_MultVector3(&D_80865B7C, &self.unk_1E8);
			#Matrix_MultVector3(&D_80865BA0, &hookNewTip);
			#Matrix_MultVector3(&D_80865BAC, &hookNewBase);
		#
#
		#func_80090480(play, &self.collider, &self.hookInfo, &hookNewTip, &hookNewBase);
		#Gfx_SetupDL_25Opa(play.state.gfxCtx);
		#gSPMatrix(POLY_OPA_DISP++, MATRIX_NEW(play.state.gfxCtx, "../z_arms_hook.c", 895),
				  #G_MTX_NOPUSH | G_MTX_LOAD | G_MTX_MODELVIEW);
		#gSPDisplayList(POLY_OPA_DISP++, gLinkAdultHookshotTipDL);
		#Matrix_Translate(self.actor.world.pos.x, self.actor.world.pos.y, self.actor.world.pos.z, MTXMODE_NEW);
		#Math_Vector3_Diff(&player.unk_3C8, &self.actor.world.pos, &sp78);
		#sp58 = SQ(sp78.x) + SQ(sp78.z);
		#sp5C = sqrtf(sp58);
		#Matrix_RotateY(Math_FAtan2F(sp78.x, sp78.z), MTXMODE_APPLY);
		#Matrix_RotateX(Math_FAtan2F(-sp78.y, sp5C), MTXMODE_APPLY);
		#Matrix_Scale(0.015f, 0.015f, sqrtf(SQ(sp78.y) + sp58) * 0.01f, MTXMODE_APPLY);
		#gSPMatrix(POLY_OPA_DISP++, MATRIX_NEW(play.state.gfxCtx, "../z_arms_hook.c", 910),
				  #G_MTX_NOPUSH | G_MTX_LOAD | G_MTX_MODELVIEW);
		#gSPDisplayList(POLY_OPA_DISP++, gLinkAdultHookshotChainDL);
#
		#CLOSE_DISPS(play.state.gfxCtx, "../z_arms_hook.c", 913);
	#
func _process(_delta):
	#display logic here
	pass
func _physics_process(_delta):
	pass
