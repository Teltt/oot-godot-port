extends Node2D

@onready var anim_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	Game.is_event_loaded = true
	await get_tree().process_frame
	Game.main.event = self
	anim_player.play("event")
	pass # Replace with function body.
func play_message_set(message:DialogueResource,message_title:String):
	if Game.main.can_progress_event():
		Game.main.display_msg_box(message,message_title)
func s():
	pass
func load_new_field(field:PackedScene):
	Game.main.load_new_field(field,true)
	await Game.main.load_fade.loaded
	queue_free()
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Game.main.can_progress_event():
		anim_player.advance(delta)
	pass
