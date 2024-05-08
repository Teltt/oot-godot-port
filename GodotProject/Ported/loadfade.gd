extends ColorRect
signal loaded 
@onready var anim_player = $AnimationPlayer
var loading = false
var load_instance:PackedScene
var from_scratch = false
var lambada :Callable
var awaiting = false
signal await_finished 
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func fade_in():
	if awaiting:
		return
	
	
	loaded.emit()
	anim_player.play("fade_in")
	awaiting = true
	await(anim_player.animation_finished)
	await_finished.emit()
	awaiting = false
	loading = false
func fade_out():
	
	if awaiting:
		return
		
	loading = true
	if Game.main.msg_box.displaying:
		awaiting = true
		await(Game.main.msg_box.closed)
		await_finished.emit()
		awaiting = false
	anim_player.play("fade_out")
	awaiting = true
	await(anim_player.animation_finished)
	await_finished.emit()
	awaiting = false
	

func fade_out_battle():
		
	loading = true
	anim_player.play("fade_out_battle")
	awaiting = true
	await(anim_player.animation_finished)
	await_finished.emit()
	awaiting = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

signal faded_out
func _on_animation_player_animation_finished(anim_name):
	if awaiting:
		await (await_finished)
		awaiting = false
	if anim_name == "fade_out":
		lambada.call(load_instance,from_scratch)
		fade_in()
