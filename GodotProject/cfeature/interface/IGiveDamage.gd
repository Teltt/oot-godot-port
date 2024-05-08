extends Interface
signal given_damage
@export var actor:Actor
@export var damage:float = 0.0
# Called when the node enters the scene tree for the first time.
func give_damage(hitter,receiver):
	
	for child in receiver.actor.get_children():
		if child is IDamagable:
				child.add_damage(hitter,receiver,damage)
				given_damage.emit()
				return 


