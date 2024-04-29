extends Node
class_name HITABLE
@export var actor:Actor
const AC_NONE =0 # No flags set. Cannot have AC collisions when set as AC
const AC_ON =(1 << 0) # Can have AC collisions when set as AC
const AC_HIT= (1 << 1) # Had an AC collision
const AC_HARD= (1 << 2) # Causes AT colliders to bounce off it
const AC_TYPE_PLAYER =IHIT.AT_TYPE_PLAYER # Takes player-aligned damage
const AC_TYPE_ENEMY= IHIT.AT_TYPE_ENEMY # Takes enemy-aligned damage
const AC_TYPE_OTHER= IHIT.AT_TYPE_OTHER # Takes non-aligned damage
const AC_NO_DAMAGE= (1 << 6) # Collider does not take damage
const AC_BOUNCED =(1 << 7) # Caused an AT collider to bounce off it
const AT_SELF =(1 << 8) # Can have AT collisions with colliders attached to the same actor
const AC_TYPE_ALL= (AC_TYPE_PLAYER | AC_TYPE_ENEMY | AC_TYPE_OTHER) # Takes damage from all three alignments
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
@onready var parent = get_parent()

func _is(flags):
	if true:
		return (flags &my_flags) != 0
	else:
		hit.emit(null,null)
signal hit(hitter,hitspot)
