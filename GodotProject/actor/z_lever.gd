extends Actor

@export var switch:Switch
@onready var anim:ISwitchAnimate = $Anim
var awaiting = false
func _ready() -> void:
	world = global_transform
	
	anim.switch = switch
func hit(hitter,hitspot):
	flip.rpc()
@rpc("call_local","any_peer")
func flip():
	if not awaiting:
		awaiting= true
		switch.v = not switch.v
		await anim.animation_finished
		awaiting = false
