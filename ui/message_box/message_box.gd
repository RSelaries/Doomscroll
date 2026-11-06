class_name MessageBoxScene
extends Control


const MESSAGE_SCENE = preload("uid://dc1p8h3s3wmwt")


## The dialogue resource
var dialogue_resource: DialogueResource
## The cue to start the dialogue from
var start_from_cue: String = ""
## Temporary game states
var temporary_game_states: Array = []
## A dictionary to store any ephemeral variables
var locals: Dictionary = {}
## The current line
var dialogue_line: DialogueLine: set = _set_current_line


@onready var messages_container: VBoxContainer = %MessagesContainer
@onready var no_responses: HBoxContainer = %NoResponses
@onready var responses_menu: DialogueResponsesMenu = %ResponsesMenu


func _ready() -> void:
	clear()
	start(load("res://dialogues/debug_dialogue.dialogue"))


## Call this function to start a dialogue.
func start(dialogue_res: DialogueResource, cue: String = "", extra_game_states: Array = []) -> void:
	temporary_game_states = [self] + extra_game_states
	dialogue_resource = dialogue_res
	if not cue.is_empty():
		start_from_cue = cue
	dialogue_line = await dialogue_resource.get_next_dialogue_line(start_from_cue, temporary_game_states)


## Apply any changes to the balloon given a new [DialogueLine].
func apply_dialogue_line() -> void:
	no_responses.show()
	
	responses_menu.responses = dialogue_line.responses
	
	# Add new line
	var new_message: MessageScene = MESSAGE_SCENE.instantiate()
	new_message.character_name = dialogue_line.character
	new_message.message_content = dialogue_line.text
	messages_container.add_child(new_message)
	
	# Wait for next line
	if dialogue_line.responses.size() > 0:
		no_responses.hide()
		responses_menu.focus_first_item()
	else:
		if dialogue_line.time in ["auto", ""]:
			await get_tree().create_timer(1.0).timeout
		elif get(dialogue_line.time) is Signal:
			await get(dialogue_line.time)
		else:
			var time: float = dialogue_line.time.to_float()
			await get_tree().create_timer(time).timeout
		
		next(dialogue_line.next_id)


## Go to the next line
func next(next_id: String) -> void:
	dialogue_line = await dialogue_resource.get_next_dialogue_line(next_id, temporary_game_states)


## Clears the message box
func clear() -> void:
	for child in messages_container.get_children():
		child.queue_free()


func _set_current_line(line: DialogueLine) -> void:
	dialogue_line = line
	if is_instance_valid(line):
		apply_dialogue_line()
