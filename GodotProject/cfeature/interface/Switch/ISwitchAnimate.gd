extends AnimationPlayer
@export var switch:Switch
@export var switch_to_animation_name:Dictionary = {}
@export var skips_inital_switch_anim = true
func _ready() -> void:
	on_ready(switch.v)
	switch.send_changed_value.connect(receive_request)
func receive_request(v):
	play(switch_to_animation_name[v])
func on_ready(v):
	var anim = get_animation(switch_to_animation_name[v])
	if anim.loop_mode != Animation.LOOP_NONE or not skips_inital_switch_anim:
	
		play(switch_to_animation_name[v])
	else:
		
		play(switch_to_animation_name[v])
		seek(anim.length)
