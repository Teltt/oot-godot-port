extends Actor
class_name Player
@onready var unk_3C8 = global_position
var heldActor:Actor
var upper_state:Callable
var lower_entered = false
var lower_state:Callable:
	set(value):
		lower_state = value
		lower_entered = true
var body_state:Callable
var in_first_person
var in_cutscene
var targeting:Actor= null
var face_look_at:Vector3
var expression#face_expression enum
var lower_anim_length
var upper_anim_length
var body_anim_length
var joystick_dir:Vector2
var camera:Camera3D
@onready var lower_anim_tree:AnimationTree = $Lower/AnimationTree
@onready var upper_anim_tree:AnimationTree = $Lower/Upper/AnimationTree
func HoldsHookshot():
	return true
signal jump
signal slow
signal touched_floor
var just_jumped = false
func _ready() -> void:
	camera= get_tree().get_first_node_in_group("camera")
	$LedgeDetect/Foot.add_exception(self)
	$LedgeDetect/Foot2.add_exception(self)
	$LedgeDetect/Foot3.add_exception(self)
	$LedgeDetect/Knee.add_exception(self)
	$LedgeDetect/Chest.add_exception(self)
	$LedgeDetect/UpperChest.add_exception(self)
	lower_state = lower_move
	upper_state = upper_swing
var was_on_floor
var movement_angle
func _process(delta: float) -> void:
	pass
func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	process_ztarget()
	camera= get_tree().get_first_node_in_group("camera")
	
	joystick_dir = Input.get_vector("ui_left","ui_right","ui_down","ui_up")
	movement_angle = Vector2(joystick_dir.x,joystick_dir.y).angle()
	
	joystick_dir = Vector2(joystick_dir.y,joystick_dir.x).rotated(-camera.global_rotation.y-PI/2)
	lower_anim_tree["parameters/Walk/blend_position"] = Vector2.from_angle( PI/2+angle_difference(joystick_dir.angle(),global_rotation.y))
	$LedgeDetect.global_rotation.y = (joystick_dir*Vector2(1,-1)).angle()
	lower_state.call(_delta)
	upper_state.call(_delta)
	lower_entered = false
const frames_to_untarget = 20
var target_frames_passed = 0
func process_ztarget():
	
	if ((not Input.is_action_just_pressed("shift") and Input.is_action_pressed("shift") )):
		target_frames_passed = min(target_frames_passed+1,frames_to_untarget)
		if target_frames_passed >= frames_to_untarget:
			ZTargetting.untarget()
			
			target_frames_passed = 0
		return
	elif (camera.is_position_behind(global_position)):
		ZTargetting.untarget()
		target_frames_passed = 0
		return
	elif Input.is_action_just_pressed("shift") and ZTargetting.current_target == null:
			ZTargetting.change_to_first()
			target_frames_passed = 0
			return
	elif ZTargetting.current_target != null and Input.is_action_just_pressed("shift") :
			ZTargetting.change_by_num(1)			
			target_frames_passed = 0
			return
	target_frames_passed = 0
func get_limit(_case="default"):
	return pow(3.0,1.0-jump_dir_get().y)*1.7
func jump_dir_get(_case="default"):
	var vel = Vector2(my_velocity.x,my_velocity.z)
	return (Vector3.UP+Vector3(vel.x,0.0,vel.y).normalized()).normalized()
func fall_dir_get(_case):
	return Vector3.DOWN
func get_time(_case):
	return 1.5
func set_vel(vel):
	my_velocity = vel
func get_vel(_case):
	return my_velocity
#region New Code Region
func body_idle(_delta):
	pass
func body_reach_ledge(_delta):
	pass
func body_hang_ledge(_delta):
	pass
func body_ascend_ledge(_delta):
	pass
func body_hurt(_delta):
	pass
func lower_idle(_delta):
	pass
func lower_move(_delta):
	if self["is_on_floor"].call() and Input.is_action_just_pressed("ui_accept"):
		jump.emit()
		lower_state = lower_jump
		self.call("move_and_slide")
		return
	if not joystick_dir.length() <= 0.05:
		speed= deltastep(_delta,speed,6.0,1.5)
	else:
		speed = 0
	if self["is_on_floor"].call():
		if joystick_dir.length() >0.15:
			$Lower.global_rotation.y = lerp_angle($Lower.global_rotation.y,movement_angle+PI+camera.global_rotation.y,0.25)
		
		$Lower.scale = Vector3.ONE*0.5
		if speed > 1.5:
			my_velocity.x = lerp(my_velocity.x,joystick_dir.x*speed,1.0)
			my_velocity.z = lerp(my_velocity.z,joystick_dir.y*speed,1.0)
			var foot= is_shape_on_wall($LedgeDetect/Foot)
			var knee = is_shape_on_wall($LedgeDetect/Knee)
			if foot and not knee and $LedgeDetect/Foot2.is_colliding():
				jump.emit()
				lower_state = lower_jump
				
				self.call("move_and_slide")
				return
		
		else:
			my_velocity.x = 0
			my_velocity.z = 0
		
		
	if self["is_on_floor"].call():
		touched_floor.emit(self["is_on_floor"])
	else:
		if speed > 5.5:
			if not lower_entered and $LedgeDetect/Foot3.is_colliding():
				lower_state = lower_jump
				touched_floor.emit(false)
				jump.emit()
				self.call("move_and_slide")
				return
	
	my_velocity.y = deltastep(_delta,my_velocity.y,-9.8,-fall_dir_get("").y)
		
	self.call("move_and_slide")

func lower_jump(_delta):
	if not joystick_dir.length() <= 0.05:
		speed= clampf(speed+0.5,0,6)
	
	if self["is_on_floor"].call():
		touched_floor.emit(self["is_on_floor"].call())
		lower_state = lower_move
		return

	if self["is_on_floor"].call():
		if speed > 1.5:
			my_velocity.x = lerp(my_velocity.x,joystick_dir.x*speed,1.0)
			my_velocity.z = lerp(my_velocity.z,joystick_dir.y*speed,1.0)
		else:
			my_velocity.x = 0
			my_velocity.z = 0
	else:
		my_velocity.x = lerp(my_velocity.x,joystick_dir.x*speed,0.6)
		my_velocity.z = lerp(my_velocity.z,joystick_dir.y*speed,0.6)
		
	my_velocity.y = clamp(my_velocity.y-1.0*jump_dir_get().y,-120,999)
		
	self["move_and_slide"].call()
	pass
func lower_hop(_delta):
	pass
func lower_sidehop(_delta):
	pass
func lower_backflip(_delta):
	pass
func lower_step(_delta):
	pass
func lower_spin(_delta):
	pass
func lower_crouch(_delta):
	pass
func lower_kneel(_delta):
	pass
func lower_crawl(_delta):
	pass
func lower_pulled(_delta):
	pass
func lower_sliding(_delta):
	pass
func lower_struggle(_delta):
	pass
func lower_lie_down(_delta):
	pass
func lower_lie_up(_delta):
	pass
func lower_collapse(_delta):
	pass
func lower_climb_wall(_delta):
	pass
func lower_climb_pole(_delta):
	pass
func upper_crawl(_delta):
	pass
var swings = {
	"Forward":"Up",
	"Backward":"Up",
	"Up":"Down",
	"Down":"Finish",
	"End" :"Forward"
}
func upper_swing(_delta):
	var playback:AnimationNodeStateMachinePlayback= upper_anim_tree["parameters/Hands/SwingState/playback"]
	
	var cur = playback.get_current_node()
	if cur == "End" or cur == "Start":
		$Hand/Ihit.my_flags = 0
	else:
		$Hand/Ihit.my_flags = 2
	if Input.is_action_just_pressed("z"):
		if cur != "Finish" and cur:
			playback.travel(swings[cur])
		

	pass
func upper_shield(_delta):
	pass
func upper_carry_bottle(_delta):
	pass
func upper_carry_over(_delta):
	pass
func upper_carry_side(_delta):
	pass
func upper_slingshot(_delta):
	pass
func upper_hookshot(_delta):
	pass
func upper_bow(_delta):
	pass
func upper_scoop(_delta):
	pass
func upper_fish(_delta):
	pass
func upper_dump(_delta):
	pass
func upper_grip_pole(_delta):
	pass
func upper_grip_hook(_delta):
	pass
func upper_grip_rope(_delta):
	pass
func upper_climb_wall(_delta):
	pass
func upper_climb_pole(_delta):
	pass

#endregion

func is_shape_on_wall(shape):
	if shape.is_colliding():
		var normal = shape.get_collision_normal(0)
		if Vector3.UP.dot(normal) < 0.75:
			return true
	return false


