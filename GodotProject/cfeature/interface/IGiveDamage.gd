extends Interface
signal given_damage
@export var damage:float = 0.0
# Called when the node enters the scene tree for the first time.
func give_damage(receiver):
	
	if receiver.has_meta('idamagable'):
		if receiver.is_multiplayer_authority():
			receiver.idamagable.add_damage(damage)
			given_damage.emit()
		return
	else:
		for child in receiver.get_children():
			if child is IDamagable:
				if child.is_multiplayer_authority():
					child.add_damage(damage)
					given_damage.emit()
				return 


