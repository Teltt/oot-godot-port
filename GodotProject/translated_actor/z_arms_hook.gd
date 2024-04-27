extends Actor
@onready var player:Actor 
@onready var test:ShapeCast3D = $Test
var state:Callable
@onready var collider:CollisionShape3D
var hookInfo;#WeaponInfo 
var unk_1E8:Vector3 ;
var unk_1F4:Vector3 ;
var grabbed:Actor;
var grabbedDistDiff:Vector3;
var timer:int;
func _ready() -> void:
	state = wait
	unk_1E8 = world.origin;
	pass
func _physics_process(_delta: float) -> void:
	player = get_tree().get_first_node_in_group("player");
	state.call(_delta);
	self.unk_1F4 = self.unk_1E8;
func _process(_delta: float) -> void:
	pass
func _exit_tree() -> void:
	if is_queued_for_deletion():
		if (self.grabbed != null):
			self.grabbed.flags &= ~ACTOR_FLAG_13;
func attach_player():
	
	player.heldActor = self;
	if (self.child):
		player.parent=null;
		self.child=(null);
		return true;
	return false;
func chk_cancel():
	if (player.HoldsHookshot()):
		if (player.flags & ACTOR_FLAG_TALK):# or (player.itemAction != player.heldItemAction) or  or
			#((player.stateFlags1 & (PLAYER_STATE1_7 | PLAYER_STATE1_26)))):
			self.timer = 0;
			detach();
			world.origin=player.unk_3C8;
			return 1;
	return 0;
func shoot(_delta):

	if (parent == null or (!player.HoldsHookshot())) :
		detach();
		queue_free()
		return;

	#func_8002F8F0(player, NA_SE_IT_HOOKSHOT_CHAIN - SFX_FLAG);
	chk_cancel();

	#if ((self.timer != 0) and (self.collider.base.atFlags & AT_HIT) and
		#(self.collider.elem.atHitElem.elemType != ELEMTYPE_UNK4)) :
		#var touchedActor = self.collider.base.at;
#
		#if ((touchedActor.update != null) and (touchedActor.flags & (ACTOR_FLAG_9 | ACTOR_FLAG_10))):
			#if (self.collider.elem.atHitElem.acElemFlags & ACELEM_HOOKABLE):
				#grab(touchedActor);
				#if (CHECK_FLAG_ALL(touchedActor.flags, ACTOR_FLAG_10)):
					#func_80865044(this);
		#self.timer = 0;
		#Audio_PlaySfxGeneral(NA_SE_IT_ARROW_STICK_CRE, projectedPos, 4, gSfxDefaultFreqAndVolScale,
							 #gSfxDefaultFreqAndVolScale, gSfxDefaultReverb);
	timer -= 1
	if (self.timer == 0):
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
		if (grabbed != null) :
			if ((grabbed.is_processing()) or !CHECK_FLAG_ALL(grabbed.flags, ACTOR_FLAG_13)) :
				grabbed = null;
				self.grabbed = null;
			elif (child != null):
				curGrabbedDist = world.origin.distance_to(grabbed.world.origin);
				grabbedDist =sqrt(SQ(self.grabbedDistDiff.x) + SQ(self.grabbedDistDiff.y) + SQ(self.grabbedDistDiff.z));
				world.origin=grabbed.world.origin- self.grabbedDistDiff;
				if ((curGrabbedDist - grabbedDist) > 50.0):
					detach();
					grabbed = null;
				
			
		

		bodyDistDiff = player.unk_3C8.distance_to( world.origin)
		if (bodyDistDiff < 30.0):
			velocity = 0.0;
			phi_f16 = 0.0;
		else:
			if (child != null):
				velocity = 30.0;
			elif (grabbed != null):
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

		if (child != null):
			pass
			if ((grabbed != null) ): #and (grabbed.id == ACTOR_BG_SPOT06_OBJECTS)
				world.origin=grabbed.world.origin- self.grabbedDistDiff;
				phi_f16 = 1.0;
			else:
				world.origin+player.unk_3C8+newPos;
				if (grabbed != null):
					grabbed.world.origin=world.origin+self.grabbedDistDiff;
				
			
		else:
			player.velocity=bodyDistDiffVec-newPos;
			player.rotation.x =atan2(sqrt(SQ(bodyDistDiffVec.x) + SQ(bodyDistDiffVec.z)), -bodyDistDiffVec.y);
		

		if (phi_f16 < 50.0):
			detach();
			if (phi_f16 == 0.0):
				state = wait;
				if (attach_player()):
					player.velocity=world.origin- player.world.origin;
					player.velocity.y -= 20.0;
				
			
		
	else:
		var poly;#CollisionPoly
		var bgId:int;
		var intersectPos:Vector3;
		var prevFrameDiff:Vector3;
		var sp60:Vector3;

		MoveXZGravity(_delta);
		prevFrameDiff=world.origin- prevPos.origin;
		self.unk_1E8+unk_1E8+prevFrameDiff;
		#shape.rot.x = atan2(speed, -velocity.y);
		sp60.x = self.unk_1F4.x - (self.unk_1E8.x - self.unk_1F4.x);
		sp60.y = self.unk_1F4.y - (self.unk_1E8.y - self.unk_1F4.y);
		sp60.z = self.unk_1F4.z - (self.unk_1E8.z - self.unk_1F4.z);
		if not test.shape:
			test.shape = SphereShape3D.new()
			test.shape.radius = 0.01
		sp60 -= self.unk_1E8
		test.target_position = -sp60
		test.force_shapecast_update()
		if test.is_colliding():
			intersectPos = test.get_collision_point(0)
			var polyNormal= test.get_collision_normal(0)
			world.origin= intersectPos;
			world.origin.x += 10.0 * polyNormal.x;
			world.origin.z += 10.0 * polyNormal.z;
			self.timer = 0;
			var surface = test.get_collider(0)
			#if (SurfaceType_CanHookshot(play.colCtx, poly, bgId)):
				#DynaPolyActor* dynaPolyActor;
#
				#if (bgId != BGCHECK_SCENE):
					#dynaPolyActor = DynaPoly_GetActor(play.colCtx, bgId);
					#if (dynaPolyActor != null):
						#ArmsHook_AttachHookToActor(this, dynaPolyactor);
					#
				#
				#func_80865044(this);
				#Audio_PlaySfxGeneral(NA_SE_IT_HOOKSHOT_STICK_OBJ, projectedPos, 4,
									 #gSfxDefaultFreqAndVolScale, gSfxDefaultFreqAndVolScale, gSfxDefaultReverb);
			#else:
				#CollisionCheck_SpawnShieldParticlesMetal(play, world.origin);
				#Audio_PlaySfxGeneral(NA_SE_IT_HOOKSHOT_REFLECT, projectedPos, 4,
									 #gSfxDefaultFreqAndVolScale, gSfxDefaultFreqAndVolScale, gSfxDefaultReverb);
			#
		#elif (CHECK_BTN_ANY(play.state.input[0].press.button,
								 #(BTN_A | BTN_B | BTN_R | BTN_CUP | BTN_CLEFT | BTN_CRIGHT | BTN_CDOWN))):
			#self.timer = 0;
func wait(_delta):
	if (parent == null):
		#get correct timer length for hookshot or longshot
		# 13 for hookshot length
		var length:int =  13
		state = (shoot);
		SetProjectileSpeed(20.0);
		parent=(player)
		self.timer = length;
func detach():
	if (grabbed != null) :
		grabbed.flags &= ~ACTOR_FLAG_13;
		grabbed = null
func grab(actor):
	actor.flags |= ACTOR_FLAG_13;
	grabbed = actor;
	grabbedDistDiff=actor.world.origin-world.origin
