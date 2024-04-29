extends ShapeCast3D
class_name CollisionTest
signal hit_actor(actor,pos,normal)
signal hit_surface(surface,pos,normal)
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(_delta: float) -> void:
	if is_colliding():
		var collider = get_collider(0)
		var parent = collider.get_parent() 
		if  parent is Actor:
			hit_actor.emit(parent,get_collision_point(0),get_collision_normal(0))
		elif collider is Actor:
			hit_actor.emit(collider,get_collision_point(0),get_collision_normal(0))
			hit_surface.emit(collider,get_collision_point(0),get_collision_normal(0))
		else:
			hit_surface.emit(collider,get_collision_point(0),get_collision_normal(0))
func _force_shapecast_update():
	force_shapecast_update()
	if is_colliding():
		var collider = get_collider(0)
		var parent = collider.get_parent() 
		if  parent is Actor:
			hit_actor.emit(parent,get_collision_point(0),get_collision_normal(0))
		elif collider is Actor:
			hit_actor.emit(collider,get_collision_point(0),get_collision_normal(0))
			hit_surface.emit(collider,get_collision_point(0),get_collision_normal(0))
		else:
			hit_surface.emit(collider,get_collision_point(0),get_collision_normal(0))

	
