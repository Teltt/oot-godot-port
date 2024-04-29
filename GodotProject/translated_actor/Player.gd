extends Actor
class_name PLayer
@onready var unk_3C8 = global_position
var heldActor:Actor
func HoldsHookshot():
	return true
func _physics_process(_delta: float) -> void:
	MoveXZGravity(_delta)
	pass
