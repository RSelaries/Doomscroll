extends Control


@onready var ending_scene: MarginContainer = %EndingScene
@onready var end_text: RichTextLabel = %EndText


func _ready() -> void:
	ending_scene.hide()
	Global.end_reached.connect(_on_end_reached)


func _on_end_reached() -> void:
	end_text.text = Global.get_ending()
	ending_scene.show()
