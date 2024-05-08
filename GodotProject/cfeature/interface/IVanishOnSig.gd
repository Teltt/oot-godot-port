@tool
extends Interface
@export var parent:Node
func _ready() -> void:
	before_init = true
	keys = []
	keys.append("despawn_func")
	before_init = false
	super()
	pass # Replace with function body.

@export var called = false
@rpc("call_remote","any_peer")
func vanish() -> void:
	if Engine.is_editor_hint():
		return
	if called == true:
		return
	if not is_multiplayer_authority():
		called = true
		vanish.rpc()
		return
	else:
		called = true
		self["despawn_func"].call()
		
