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
			reparent(value,false)
		else:
			reparent(get_tree().get_first_node_in_group("world"))
	get:
		if get_parent() == get_tree().get_first_node_in_group("world"):
			return null
		return get_parent()
func CHECK_FLAG_ALL(flags, mask):
	return (((flags) & (mask)) == (mask))
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
var world: Transform3D:
	set(value):
		global_transform = value
	get:
		return global_transform
var focus: Transform3D
var velocity: Vector3
var speed: float
var gravity: float
func SetProjectileSpeed(speedXYZ):
	speed = (world.basis.y).dot(Vector3.UP)* speedXYZ;
	velocity.y = -(world.basis.y).dot(Vector3.FORWARD) * speedXYZ;
var minVelocityY: float
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


func UpdatePos(_delta:float) :
	var speedRate = _delta * 0.5;

	world.origin.x += (velocity.x * speedRate);
	world.origin.y += (velocity.y * speedRate);
	world.origin.z += (velocity.z * speedRate);

func UpdateVelocityXZGravity(_delta:float) :
	var forward = world.basis.x
	velocity.x = forward.x * speed;
	velocity.z = forward.z * speed;

	velocity.y += gravity;

	if (velocity.y < minVelocityY):
		velocity.y = minVelocityY;

func MoveXZGravity(_delta:float) :
	UpdateVelocityXZGravity(_delta);
	UpdatePos(_delta);
