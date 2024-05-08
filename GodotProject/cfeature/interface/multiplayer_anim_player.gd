extends AnimationPlayer

@export var anim_time:float:
	set(value):
		seek(value)
	get:
		if not current_animation:
			return 0
		return current_animation_position
