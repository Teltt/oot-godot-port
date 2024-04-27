extends Node
class_name IHIT
@export var actor:Actor
@onready var parent = get_parent()
const AT_NONE= 0 # No flags set. Cannot have AT collisions when set as AT
const AT_ON =(1 << 0) # Can have AT collisions when set as AT
const AT_HIT =(1 << 1) # Had an AT collision
const AT_BOUNCED =(1 << 2) # Had an AT collision with an AC_HARD collider
const AT_TYPE_PLAYER =(1 << 3) # Has player-aligned damage
const AT_TYPE_ENEMY =(1 << 4) # Has enemy-aligned damage
const AT_TYPE_OTHER =(1 << 5) # Has non-aligned damage
const AT_NO_DAMAGE = (1<<6)
const AT_SOFT_BOUNCED = (1<<7)
const AT_SELF =(1 << 8) # Can have AT collisions with colliders attached to the same actor
const AT_TYPE_ALL =(AT_TYPE_PLAYER | AT_TYPE_ENEMY | AT_TYPE_OTHER) # Has all three damage alignments
@export_flags(
	"ON:1",
	"HIT:2",
	"HARD:4",
	"PLAYER:8",
	"ENEMY:16",
	"OTHER:32",
	"NO_DAMAGE:64",
	"BOUNCED:128",
	"SELF:256"
) var my_flags
var hit_pos:Vector3
var hit_normal:Vector3

func from_collision_test(_actor,pos,normal):
	contact(_actor,pos,normal)
signal hit(hitter,hitspot)
func contact(_actor,pos=Vector3.ZERO,normal= Vector3.ZERO):
	for child in _actor.get_children():
		if child is HITABLE:
			if child._is(my_flags):
				hit_pos = pos
				hit_normal = normal
				child.hit.emit(self,child)
				hit.emit(self,child)
