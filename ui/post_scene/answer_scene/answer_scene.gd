@tool
class_name AnswerScene
extends PanelContainer


const SCENE = preload("uid://d3b51xebnebpj")


signal answer_selected(answer: AnswerResource)


var answer: AnswerResource

@onready var answer_label: RichTextLabel = %AnswerLabel


func _ready() -> void:
	if answer:
		answer_label.text = answer.content


func _on_send_button_pressed() -> void:
	answer_selected.emit(answer)
