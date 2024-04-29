extends Actor
class_name PLayer
@onready var unk_3C8 = global_position
var heldActor:Actor
var upper_state:Callable
var lower_state:Callable
var body_state:Callable
var in_first_person
var in_cutscene
var targeting:Actor= null
var face_look_at:Vector3
var expression#face_expression enum

func HoldsHookshot():
	return true
func _physics_process(_delta: float) -> void:
	body_state.call(_delta)
	pass

func body_idle(_delta):
	pass
func body_hurt(_delta):
	pass
func lower_idle(_delta):
	pass
func lower_move(_delta):
	pass
func lower_jump(_delta):
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
func lower_crawl(_delta):
	pass
func upper_swingdown(_delta):
	pass
func upper_swingright(_delta):
	pass
func upper_swingup(_delta):
	pass
func upper_swingspin(_delta):
	pass
