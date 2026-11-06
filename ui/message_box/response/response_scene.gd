@tool
class_name ResponseScene
extends HBoxContainer


@export var is_placeholder: bool = false:
	set(value):
		is_placeholder = value
		if is_instance_valid(response_content):
			response_content.add_theme_color_override(
					&"default_color", Color.GRAY if value else Color.WHITE)
@export var text: String:
	set(value):
		text = value
		if is_instance_valid(response_content):
			response_content.text = value

@onready var response_content: RichTextLabel = $ResponseContent


func _ready() -> void:
	response_content.text = text
	response_content.add_theme_color_override(&"default_color", Color.GRAY)
