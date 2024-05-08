extends DialogueResponsesMenu
@onready var anim_player:AnimationPlayer= %AnimationPlayer
@onready var msg_box = $"../.."
	


func _on_response_selected(_response):
	anim_player.play("popout_choices")
	msg_box.awaiting = true
	await (anim_player.animation_finished)
	msg_box.awaiting = false
	pass # Replace with function body.
