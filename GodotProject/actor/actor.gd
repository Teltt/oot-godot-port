extends Node3D
class_name Actor
var child:
	set(value):
		if $Child.get_child_count() > 0:
			
			for _child in $Child.get_children():
				$Child.remove_child(_child)
		if value != null:
			$Child.add_child(value)
	get:
		if $Child.get_child_count() == 0:
			return null
		return $Child.get_child(0)
var parent:
	set(value):
		if value != null:
			if value is Actor:
				reparent(value.get_node("Child"),true)
			else:
				reparent(value,true)
		else:
			reparent(get_tree().get_first_node_in_group("world"))
	get:
		if get_parent() == get_tree().get_first_node_in_group("world"):
			return null
		if get_parent().name == "Child":
			return get_parent().get_parent()
		return get_parent()
func CHECK_FLAG_ALL(_flags, mask):
	return (((_flags) & (mask)) == (mask))
func SQ(value):
	return pow(value,2.0)
const ACTOR_FLAG_0 = 1 << 0
const ACTOR_FLAG_2 = 1 << 2
const ACTOR_FLAG_3 = 1 << 3
const ACTOR_FLAG_4 = 1 << 4
const ACTOR_FLAG_5 = 1 << 5
const ACTOR_FLAG_6 = 1 << 6
const ACTOR_FLAG_REACT_TO_LENS = 1 << 7
const ACTOR_FLAG_TALK = 1 << 8
const ACTOR_FLAG_9 = 1 << 9
const ACTOR_FLAG_10 = 1 << 10
const ACTOR_FLAG_ENKUSA_CUT = 1 << 11
const ACTOR_FLAG_IGNORE_QUAKE = 1 << 12
const ACTOR_FLAG_13 = 1 << 13
const ACTOR_FLAG_14 = 1 << 14
const ACTOR_FLAG_15 = 1 << 15
const ACTOR_FLAG_16 = 1 << 16
const ACTOR_FLAG_17 = 1 << 17
const ACTOR_FLAG_18 = 1 << 18
const ACTOR_FLAG_19 = 1 << 19
const ACTOR_FLAG_20 = 1 << 20
const ACTOR_FLAG_21 = 1 << 21
const ACTOR_FLAG_IGNORE_POINT_LIGHTS = 1 << 22
const ACTOR_FLAG_23 = 1 << 23
const ACTOR_FLAG_24 = 1 << 24
const ACTOR_FLAG_25 = 1 << 25
const ACTOR_FLAG_26 = 1 << 26
const ACTOR_FLAG_27 = 1 << 27
const ACTOR_FLAG_28 = 1 << 28

var id: int
var category: int
var home: Transform3D
var params: int
var targetMode: int
var sfx: int
var prev_global_transform: Transform3D
var world: Transform3D:
	set(value):
		prev_global_transform = global_transform
		physics_interpolation = 0.0
		world = value
	get:
		return world
var focus: Transform3D
var my_velocity: Vector3:
	set(value):
		if has_method("set_velocity"):
			self["set_velocity"].call(value)
		my_velocity = value
	get:
		if has_method("get_velocity"):
			return self["get_velocity"].call()
		return my_velocity
		
var speed: float
var gravity: float
func SetProjectileSpeed(speedXYZ):
	speed = (world.basis.y).dot(Vector3.UP)* speedXYZ;
	my_velocity.y = -(world.basis.y).dot(Vector3.FORWARD) * speedXYZ;
var minmy_velocityY: float
var wallYaw: int
var floorHeight: float
var yDistToWater: float
var bgCheckFlags: int
var yawTowardsPlayer: int
var xyzDistToPlayerSq: float
var xzDistToPlayer: float
var yDistToPlayer: float
var projectedPos: Vector4
var prevPos: Transform3D
var isTargeted: bool
var targetPriority: int
var textId#: int
var freezeTimer: int
var colorFilterParams: int
var colorFilterTimer: int
var dropFlag: int
var naviEnemyId: int

func _ready() -> void:
	world = global_transform

func UpdatePos(_delta:float) :
	var speedRate = _delta * 0.5;
	if has_method("move_and_slide"):
		self["move_and_slide"].call()
		world = global_transform
	else:
		world.origin.x += (my_velocity.x * speedRate);
		world.origin.y += (my_velocity.y * speedRate);
		world.origin.z += (my_velocity.z * speedRate);

func Updatemy_velocityXZGravity(_delta:float) :
	var forward = world.basis.x
	my_velocity.x = forward.x * speed;
	my_velocity.z = forward.z * speed;

	my_velocity.y += gravity;

	if (my_velocity.y < minmy_velocityY):
		my_velocity.y = minmy_velocityY;

func MoveXZGravity(_delta:float) :
	Updatemy_velocityXZGravity(_delta);
	UpdatePos(_delta);
func UpdateVelocityXYZ(_delta):
	my_velocity = world.basis.z.rotated(Vector3.UP,0)*speed
func MoveXYZ(_delta):
	UpdateVelocityXYZ(_delta)
	UpdatePos(_delta)
const PHYSICS_FRAMRATE =20.0
var physics_interpolation = 0.0
func _process(_delta: float) -> void:
	physics_interpolation+= _delta*20*0.333333333333
	physics_interpolation = min(physics_interpolation,1.0)
	global_transform = prev_global_transform.interpolate_with(world,physics_interpolation)
	pass

func pitch_to_point(p1,p2):
	var xz_dist = Vector2(p1.x,p1.z).distance_to(Vector2(p2.x,p2.z))
	var y_dist = p1.y -p2.y
	return Vector2(xz_dist,y_dist).angle()
func yaw_to_point(p1,p2):
	return Vector2(p1.x,p1.z).angle_to(Vector2(p2.x,p2.z))
func dist_to_xz(p1,p2):
	return Vector2(p1.x,p1.z).distance_to(Vector2(p2.x,p2.z))
func redo_angle(ang):
	return remap(ang*1.0,-0x7FFF*1.0,0x7FFF*1.0,-PI,PI)

func rand_centered_float(f):
	return (randf_range(0,1) - 0.5) * f;
func deltastep(_delta,from,to,x):
	var si = sign(to-from)
	if si <0:
		return max(from+x*si*_delta*20,to)
	else:
		
		return min(from+x*si*_delta*20,to)
