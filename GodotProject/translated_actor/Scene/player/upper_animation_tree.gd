extends AnimationTree
@export var swing_anim_state:String:
	set(value):
		var playback:AnimationNodeStateMachinePlayback= self["parameters/Hands/SwingState/playback"]
		if value != playback.get_current_node():
			playback.travel(value)
	get:
		var playback:AnimationNodeStateMachinePlayback= self["parameters/Hands/SwingState/playback"]
		return playback.get_current_node()
