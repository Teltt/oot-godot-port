extends Node

@export var audio_shared:SharedAudioStream
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_instance_valid(audio_shared):
		self["stream"] = audio_shared.stream
	check_is_class(self)
	pass # Replace with function body.
func check_is_class(this):
	if not this is AudioStreamPlayer and not this is AudioStreamPlayer2D and not this is AudioStreamPlayer3D:
		assert(false,str(get_path())+" is not audiostream player")
	
