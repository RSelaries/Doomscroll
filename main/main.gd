extends Control


@onready var ending_scene: MarginContainer = %EndingScene
@onready var end_text: RichTextLabel = %EndText


func _ready() -> void:
	ending_scene.hide()
