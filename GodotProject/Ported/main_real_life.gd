extends Node2D
@onready var field = null
@onready var event = null
@onready var msg_box = $Camera/Camera2D/CanvasLayer/msg_box
@onready var load_fade = $Camera/Camera2D/CanvasLayer/loadfade
@onready var camera = $Camera
var is_event = false:
	set(value):
		Game.is_event_loaded = value
	get:
		return Game.is_event_loaded
# Called when the node enters the scene tree for the first time.
func _ready():
	field = get_node_or_null("field")
	event = get_node_or_null("event")
	Game.field = field
	Game.main = self
	pass # Replace with function body.
func can_interact():
	return not msg_box.displaying and not load_fade.loading
func can_progress_event():
	return not msg_box.displaying and not load_fade.loading
func display_msg_box(new_message:DialogueResource,message_title:String):
	msg_box.display(new_message,message_title)
func load_new_field(new_field, from_scratch = false):
	is_event = false
	load_fade.lambada = load_field
	load_fade.load_instance = new_field
	load_fade.from_scratch = from_scratch
	load_fade.fade_out()
func load_new_event(new_event, from_scratch = false):
	is_event = true
	load_fade.lambada = load_event
	load_fade.load_instance = new_event
	load_fade.from_scratch = from_scratch
	load_fade.fade_out()
func load_field(new_field, from_scratch = false):
	if not from_scratch:
		if is_instance_valid(field):
			var old_field = field
			remove_child(old_field)
			old_field.queue_free()
		if is_instance_valid(event):
			var old_event = event
			remove_child(old_event)
			old_event.queue_free()
			
		
	var n_field = new_field.instantiate()
	n_field.set_visible(false)
	add_child(n_field)
	n_field.name = "field"
	field = n_field
	pause_node_by_name("field",true,PROCESS_MODE_INHERIT)
func load_event(p_event, from_scratch = false):
	if not from_scratch:
		if is_instance_valid(field):
			var old_field = field
			remove_child(old_field)
			old_field.queue_free()
		if is_instance_valid(event):
			var old_event = event
			remove_child(old_event)
			old_event.queue_free()
		
	var n_event = p_event.instantiate()
	n_event.set_visible(false)
	add_child(n_event)
	camera.position = n_event.get_node("Camera_Pos").position
	n_event.name = "event"
	event = n_event
	load_fade.fade_in()
	pause_node_by_name("event",true,PROCESS_MODE_INHERIT)
func pause_node_by_name(str_name:String,visibility:bool=false,_process_mode=PROCESS_MODE_DISABLED):
	var node:Node = get_node_or_null(str_name)
	if is_instance_valid(node):
		node.visible = visibility
		node.process_mode = _process_mode
