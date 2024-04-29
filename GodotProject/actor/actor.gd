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
var room: int
var flags: int
var home: Transform3D
var params: int
var objectSlot: int
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
var wallPoly#: CollisionPoly
var floorPoly#: CollisionPoly
var wallBgId: int
var floorBgId: int
var wallYaw: int
var floorHeight: float
var yDistToWater: float
var bgCheckFlags: int
var yawTowardsPlayer: int
var xyzDistToPlayerSq: float
var xzDistToPlayer: float
var yDistToPlayer: float
var colChkInfo: CollisionCheckInfo
var shape: ActorShape
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
var init: Callable
var destroy: Callable
var update: Callable
var draw: Callable


class ActorInit:
	var id: int
	var category: int
	var flags: int
	var objectId: int
	var instanceSize: int
	var init: Callable
	var destroy: Callable
	var update: Callable
	var draw: Callable

class DamageTable:
	var table: Array

class CollisionCheckInfoInit:
	var health: int
	var cylRadius: int
	var cylHeight: int
	var mass: int

class CollisionCheckInfoInit2:
	var health: int
	var cylRadius: int
	var cylHeight: int
	var cylYShift: int
	var mass: int

class CollisionCheckInfo:
	var damageTable: DamageTable
	var displacement: Vector3
	var cylRadius: int
	var cylHeight: int
	var cylYShift: int
	var mass: int
	var health: int
	var damage: int
	var damageEffect: int
	var atHitEffect: int
	var acHitEffect: int

class ActorShape:
	var rot: Vector3i
	var face: int
	var yOffset: float
	var shadowDraw: Callable
	var shadowScale: float
	var shadowAlpha: int
	var feetFloorFlag: int
	var feetPos: Array

class DynaPolyActor extends Actor:
	var bgId: int
	var unk_150: float
	var unk_154: float
	var unk_158: int
	var transformFlags: int
	var interactFlags: int
	var unk_162: int

class BodyBreak:
	var matrices: Array
	var objectSlots: Array
	var count: int
	var dLists: Array
	var val: int
	var prevLimbIndex: int
func _ready() -> void:
	world = global_transform

func UpdatePos(_delta:float) :
	var speedRate = _delta * 0.5;

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
const PHYSICS_FRAMRATE =20.0
var physics_interpolation = 0.0
func _process(_delta: float) -> void:
	physics_interpolation+= _delta*20*0.333333333333
	physics_interpolation = min(physics_interpolation,1.0)
	global_transform = prev_global_transform.interpolate_with(world,physics_interpolation)
	pass
