extends ShapeCast3D
class_name CollisionTest
@export var actor:Actor
signal hit_actor(actor,pos,normal)
signal hit_surface(surface,pos,normal)
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(_delta: float) -> void:
	if is_colliding():
		for c in get_collision_count():
			var collider = get_collider(c)
			var parent = collider.get_parent() 
			if  parent is Actor:
				if parent != actor:
					hit_actor.emit(parent,get_collision_point(c),get_collision_normal(c))
			elif collider is Actor:
				if collider != actor:
					hit_actor.emit(collider,get_collision_point(c),get_collision_normal(c))
				hit_surface.emit(collider,get_collision_point(c),get_collision_normal(c))
			else:
				hit_surface.emit(collider,get_collision_point(c),get_collision_normal(c))
func _force_shapecast_update():
	force_shapecast_update()
	if is_colliding():
		for c in get_collision_count():
			var collider = get_collider(c)
			var parent = collider.get_parent() 
			if  parent is Actor:
				if parent != actor:
					hit_actor.emit(parent,get_collision_point(c),get_collision_normal(c))
			elif collider is Actor:
				if collider != actor:
					hit_actor.emit(collider,get_collision_point(c),get_collision_normal(c))
				hit_surface.emit(collider,get_collision_point(c),get_collision_normal(c))
			else:
				hit_surface.emit(collider,get_collision_point(c),get_collision_normal(c))

	
