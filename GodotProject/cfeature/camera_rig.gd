extends Node3D

var target:Node3D
var player:Node3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target = get_tree().get_first_node_in_group("player")
	player = target
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	target = ZTargetting.current_target
	if target != null:
		global_position.x = lerp(global_position.x,target.position.x*0.25+player.global_position.x*0.75,0.125)
		global_position.y = lerp(global_position.y,target.position.y*0.75+player.global_position.y*0.25,0.125)
		global_position.z = lerp(global_position.z,target.position.z*0.25+player.global_position.z*0.75,0.125)
	else:
		global_position = lerp(global_position,player.global_position,0.125)

	pass
