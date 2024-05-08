extends Label

@export var parent:Node3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var camera:Camera3D = get_tree().get_first_node_in_group("camera")
	position = camera.unproject_position(parent.global_position)
	if not camera.is_position_in_frustum(parent.global_position):
		position = Vector2.ONE*-9999
	pass
