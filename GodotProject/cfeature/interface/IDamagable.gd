@tool
class_name IDamagable
extends Interface
signal depleted
@export var parent:Node
@export var damage_taken = 0.0:
	set(value):
		damage_taken = value
		if not Engine.is_editor_hint():
			damage_taken = clamp(damage_taken,0.0,self["max_health"])
func _ready():
	before_init = true
	keys = []
	keys.append("max_health")
	before_init = false
	super()
@rpc("call_remote","any_peer")
func add_damage(_damage):
	
	if is_multiplayer_authority():
		damage_taken += _damage
		damage_taken = max(0.0,damage_taken)
	return 
func get_damage()->float:
	return damage_taken
func set_damage(_damage):
	damage_taken = _damage
	return 
func get_health():
	return self["max_health"] -damage_taken
func set_health(health):
	damage_taken = self["max_health"] - health
func get_max_health()->float:
	return self["max_health"]
func set_max_health(_health):
	self["max_health"] = _health
	return
var depleted_emitted = false
func _physics_process(delta):
	if Engine.is_editor_hint() or not is_multiplayer_authority():
		return
	if damage_taken >= self["max_health"] and not depleted_emitted:
		depleted.emit()
		depleted_emitted = true
	
