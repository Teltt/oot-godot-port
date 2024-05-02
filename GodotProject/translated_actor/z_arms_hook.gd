extends Actor
@onready var player:Actor 
@onready var test:ShapeCast3D = $Test
var state:Callable
@onready var collider:CollisionShape3D
var hookInfo;#WeaponInfo 
var unk_1E8:Vector3 ;
var unk_1F4:Vector3 ;
var grabbedPos:Vector3;
var grabbedsurface
var timer:int:
	set(value):
		timer= value*2
signal grab(actor)
signal release
func _ready() -> void:
	state = wait
	unk_1E8 = world.origin;
	pass
signal process_grab()
func _physics_process(_delta: float) -> void:
	player = get_tree().get_first_node_in_group("player");
	state.call(_delta);
	self.unk_1F4 = self.unk_1E8;
func _process(_delta: float) -> void:
	process_grab.emit()
	super(_delta)
func _exit_tree() -> void:
	if is_queued_for_deletion():
		pass
func attach_player():
	
	player.heldActor = self;
func chk_cancel():
	if (player.HoldsHookshot()):
		pass
		#if (player.flags & ACTOR_FLAG_TALK):# or (player.itemAction != player.heldItemAction) or  or
			##((player.stateFlags1 & (PLAYER_STATE1_7 | PLAYER_STATE1_26)))):
			#self.timer = 0;
			#release.emit();
			#world.origin=player.unk_3C8;
			#return 1;
	return 0;
func shoot(_delta):

	if ((!player.HoldsHookshot())) :
		release.emit();
		queue_free()
		return;

	#func_8002F8F0(player, NA_SE_IT_HOOKSHOT_CHAIN - SFX_FLAG);
	chk_cancel();
	$chain_sfx.play()
	
	timer -= _delta

	if ((self.timer) <= 0):
		var grabbed;
		var  curGrabbedDist:float;
		var  grabbedDist:float;

		grabbed = null if not $Igrab.grabbed else $Igrab.grabbed.actor;
		if (grabbed != null) :
			if (child != null):
				curGrabbedDist = world.origin.distance_to(grabbed.world.origin);
				grabbedDist =sqrt(SQ(self.grabbedDistDiff.x) + SQ(self.grabbedDistDiff.y) + SQ(self.grabbedDistDiff.z));
				world.origin=grabbed.world.origin- self.grabbedDistDiff;
				if ((curGrabbedDist - grabbedDist) > 50.0):
					release.emit();
					grabbed = null;
			state = retract
				
		elif grabbedsurface:
			var newplayerPos=player.world.origin.move_toward(world.origin,_delta*2.0)
			player.speed = 20.0
			player.my_velocity = -(newplayerPos-player.world.origin)
			
			if player.world.origin.distance_to(world.origin) < 1.0:
				player.speed = 0.0
				player.my_velocity = Vector3.ZERO
				state = wait
		else:
			state = retract
	else:
		var prevFrameDiff:Vector3;
		prevPos = world
		MoveXZGravity(_delta);
		prevFrameDiff=world.origin- prevPos.origin;
		var old_rotation =world.basis.get_euler()
		world.basis = Basis.from_euler(Vector3(atan2(speed, -my_velocity.y)-PI/2,old_rotation.y,old_rotation.z));
		if not test.shape:
			test.shape = SphereShape3D.new()
			test.shape.radius = 0.01
		test.global_position = prevPos.origin
		test.target_position = -prevFrameDiff*1.0
		
		#elif (CHECK_BTN_ANY(play.state.input[0].press.button,
								 #(BTN_A | BTN_B | BTN_R | BTN_CUP | BTN_CLEFT | BTN_CRIGHT | BTN_CDOWN))):
			#self.timer = 0;
func retract(_delta):
	
	$chain_sfx.play()
	
	speed = -20
	rotation.y = (world.origin-player.world.origin).normalized().angle_to(Vector3.LEFT)+PI
	MoveXZGravity(_delta);
	if world.origin.distance_to(player.world.origin) <= 1.0:
		speed = 0.0
		$chain_sfx.stop()
	
		my_velocity = Vector3.ZERO
		state = wait
func wait(_delta):
	release.emit()
	if (parent == null):
		#get correct timer length for hookshot or longshot
		# 13 for hookshot length
		var length:int =  13
		state = (shoot);
		SetProjectileSpeed(20.0);
		var old = world
		parent = player
		world = old
		self.timer = length;

func _on_ihit_hit(_hitter: Variant, hitspot: Variant) -> void:
	if state != shoot:
		return
	if (self.timer > 0) : #and (self.collider.elem.atHitElem.elemType != ELEMTYPE_UNK4)
		var touchedActor = hitspot.actor
		if not $Igrab.holding:
			grab.emit(touchedActor);
			if $Igrab.holding:
				$hookstickobj_sfx.play()
		
		if $Igrab.grabbed and $Igrab.grabbed.actor:
			pass
		else:
			var trufunc = func():
				$arrowstick_sfx.play()
				self.timer = 0;
				grabbedsurface = touchedActor
				grabbedPos = grabbedPos
				world.origin= grabbedPos;
			var falsfunc = func():
				$hookreflect_sfx.play()
			$Ihook.second_actor(touchedActor,trufunc,falsfunc)
		#Audio_PlaySfxGeneral(NA_SE_IT_ARROW_STICK_CRE, projectedPos, 4, gSfxDefaultFreqAndVolScale,
		#					 gSfxDefaultFreqAndVolScale, gSfxDefaultReverb);


func _on_test_hit_surface(surface: Variant, pos: Variant, normal: Variant) -> void:
	if state != shoot:
		return
	var intersectPos = pos
	var polyNormal= normal
	var can_hookshot = false

	var trufunc = func():
		$arrowstick_sfx.play()
		self.timer = 0;
		world.origin= intersectPos;
		grabbedPos = (intersectPos)
		grabbedsurface = surface
	var falsfunc = func():
		$hookreflect_sfx.play()
	$Ihook.second_actor(surface,trufunc,falsfunc)
