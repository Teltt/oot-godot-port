@tool
extends Interface
@export var parent:Node
@export var case = "default"
var progress = 0.0
var soft_progress = 0.0
@export_range(0.0,1.0) var air_control = 1.0
var can = 4
signal vel_set(v)
signal accel_set(v)
signal finish
var vel_get:Callable
var fall_dir_get:Callable 
var dir_get:Callable 
var limit_get:Callable
var time_get:Callable
func _ready() -> void:
	if Engine.is_editor_hint():
		keys  = []
		before_init =true
		keys.append("time_get")
		keys.append("fall_dir_get")
		keys.append("dir_get")
		keys.append("limit_get")
		keys.append("vel_get")
		super()
		return
	vel_get= get_indexed(translations["vel_get"])
	fall_dir_get= get_indexed(translations["fall_dir_get"])
	dir_get= get_indexed(translations["dir_get"])
	limit_get= get_indexed(translations["limit_get"])
	time_get= get_indexed(translations["time_get"])
	
func _physics_process(delta: float) -> void:
	
	if Engine.is_editor_hint():
		return
	if can < 2:
		jump(delta)
func slow(_var=null):
	soft_progress = max(soft_progress,1.0-progress)
	progress = 1.0
func start_jump(_var=null):
	if can >= 1:
		if Engine.is_editor_hint():
			return
		can = 0
		progress = 0.0
		soft_progress = 0.0
		var  vel = vel_get.call(case)
		var direction= dir_get.call(case)
		var limit = limit_get.call(case)
		var proj_vel = vel.project(direction)
		vel_set.emit((vel-proj_vel)*air_control+direction*limit*(vel-proj_vel).length()/9.0)
		progress = 0.0
func jump(delta):
	var vel = vel_get.call(case)
	var limit = limit_get.call(case)
	var direction = dir_get.call(case)
	var fall_direction = fall_dir_get.call(case)
	var time = time_get.call(case)
	var proj_vel = vel.project(direction)
	var delt =(delta)
	if soft_progress >= 1.0:
		if proj_vel.normalized().dot(fall_direction) >= 0.2:
			vel_set.emit((vel-proj_vel)+fall_direction*time*1)
		return
	elif progress >=1.0:
		soft_progress = soft_progress+delt*8.0*time
		var amount = (1.0-min(1.0,soft_progress))
		var add= direction*limit*amount
		if soft_progress >= 0.5:
			add+= -direction*delt*0.0125*time
		vel_set.emit((vel-proj_vel)+add*1.0*time)
	else:
		vel_set.emit((vel-proj_vel)+direction*limit*3.0*time)
		progress = clamp(progress+delt*4.0*time,0.0,1.0)
func ireset(_var=null):
	if _var:
		can = clamp(can+1,0,3)
		var vel = vel_get.call(case)
		var direction= dir_get.call(case)
		var proj_vel = vel.project(direction)
		if proj_vel.normalized().dot(direction) < 0:
			progress = 1.0
			soft_progress = 1.0
			
