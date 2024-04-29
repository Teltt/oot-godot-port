extends Node
class_name ACFLAGS
@export var actor:Actor
const ACELEM_NONE= 0 # No flags set. Cannot have AC collisions
const ACELEM_ON =(1 << 0) # Can have AC collisions
const ACELEM_HIT =(1 << 1) # Had an AC collision
const ACELEM_HOOKABLE =(1 << 2) # Can be hooked if actor has hookability flags set.
const ACELEM_NO_AT_INFO =(1 << 3) # Does not give its info to the AT collider that hit it.
const ACELEM_NO_DAMAGE =(1 << 4) # Does not take damage.
const ACELEM_NO_SWORD_SFX =(1 << 5) # Does not have a sound effect when hit by player-attached AT colliders.
const ACELEM_NO_HITMARK =(1 << 6) # Skips hit effects.
const ACELEM_DRAW_HITMARK =(1 << 7) # Draw hitmark for AC collision this frame.
@export_flags(
	"ON:1",
	"HIT:2",
	"HOOKABLE:4",
	"NO_AT_INFO:8",
	"NO_DAMAGE:16",
	"NO_SWORD_SFX:32",
	"NO_HITMARK:64",
	"DRAW_HITMARK:128"
) var my_flags
func _is(flags):
	return (flags &my_flags) != 0
