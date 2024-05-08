extends Control

@export var current_message:DialogueResource =null
@export var current_message_title:String =''
var displaying = false
@onready var anim_player = $"AnimationPlayer"
@onready var box = $"Control/Poly"
@onready var name_label:RichTextLabel = $"Control/Poly/Name"
@onready var message_label:DialogueLabel = $"Control/Poly/Message"
@onready var choices_node = $"Choices"
var awaiting = false
@onready var balloon: Control = $Control
@onready var responses_menu: DialogueResponsesMenu = %ResponsesMenu
var choosing = false
## The dialogue resource
var resource: DialogueResource

## Temporary game states
var temporary_game_states: Array = []

## See if we are waiting for the player
var is_waiting_for_input: bool = false

## See if we are running a long mutation and should hide the balloon
var will_hide_balloon: bool = false
## The current line
var dialogue_line: DialogueLine:
	set(next_dialogue_line):
		is_waiting_for_input = false

		# The dialogue has finished so close the balloon
		if not is_instance_valid(next_dialogue_line):
			dialogue_line = next_dialogue_line
			close()
			return
		displaying = true
		dialogue_line = next_dialogue_line

		name_label.visible = not dialogue_line.character.is_empty()
		name_label.text = tr(dialogue_line.character, "dialogue")

		message_label.hide()
		message_label.dialogue_line = dialogue_line

		responses_menu.hide()
		responses_menu.set_responses(dialogue_line.responses)

		# Show our balloon
		anim_player.play("popup")
		will_hide_balloon = false

		message_label.show()
		if not dialogue_line.text.is_empty():
			message_label.type_out()
			await message_label.finished_typing

		if not is_instance_valid(dialogue_line):
			return
		# Wait for input
		if dialogue_line.responses.size() > 0:
			choosing = true
			responses_menu.show()
			anim_player.play("display_choices")
			self.awaiting = true
			await (anim_player.animation_finished)
			self.awaiting = false
		elif dialogue_line.time != "":
			var time = dialogue_line.text.length() * 0.02 if dialogue_line.time == "auto" else dialogue_line.time.to_float()
			await get_tree().create_timer(time).timeout
			change_message(dialogue_line.next_id)
		else:
			is_waiting_for_input = true
			choosing = false
	get:
		return dialogue_line
signal closed

func display(new_message,message_title):
	if is_instance_valid(new_message):
		
		temporary_game_states =  [self]
		is_waiting_for_input = false
		current_message = new_message
		resource = current_message
		self.dialogue_line = await resource.get_next_dialogue_line(message_title, temporary_game_states)

func close():
	anim_player.play("popout")
	awaiting = true
	await(anim_player.animation_finished)
	responses_menu.set_responses([])
	awaiting = false
	displaying = false
	closed.emit()
func change_message(next_id):
	if is_instance_valid(dialogue_line):
		self.dialogue_line = await resource.get_next_dialogue_line(next_id, temporary_game_states)
	elif displaying:
		close()
func _ready() -> void:
	anim_player.play("popout",-1,9999.0)
	anim_player.play("popout_choices",-1,9999.0)
	Engine.get_singleton("DialogueManager").mutated.connect(_on_mutated)


func _unhandled_input(event: InputEvent) -> void:
	if awaiting:
		return
	
	if Game.main.load_fade.loading:
		if displaying:
			change_message(dialogue_line.next_id)
		return
	# If the user clicks on the balloon while it's typing then skip typing
	if message_label.is_typing and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		get_viewport().set_input_as_handled()
		message_label.skip_typing()
		return

	if not is_waiting_for_input: return
	if dialogue_line.responses.size() > 0: return

	# When there are no response options the balloon itself is the clickable thing
	get_viewport().set_input_as_handled()

	if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1:
		change_message(dialogue_line.next_id)
	elif event.is_action_pressed("circle") and choosing == false and is_instance_valid(dialogue_line):
		change_message(dialogue_line.next_id)


### Signals


func _on_mutated(_mutation: Dictionary) -> void:
		change_message(dialogue_line.next_id)


func _on_balloon_gui_input(_event: InputEvent) -> void:
	pass


func _on_responses_menu_response_selected(response: DialogueResponse) -> void:
	change_message(response.next_id)
	choosing = false


func _on_control_gui_input(_event):
	pass # Replace with function body.
