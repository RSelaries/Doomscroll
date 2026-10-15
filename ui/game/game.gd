extends Control


@onready var ending_scene: MarginContainer = %EndingScene
@onready var end_text: RichTextLabel = %EndText
@onready var animation_player: AnimationPlayer = %AnimationPlayer


func _ready() -> void:
	ending_scene.hide()
	animation_player.play(&"fade_in")
	Global.end_reached.connect(animation_player.play.bind(&"transition"))
