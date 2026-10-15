extends Control


@onready var animation_player: AnimationPlayer = %AnimationPlayer


func _ready() -> void:
	animation_player.play(&"fade_in")


func _on_start_btn_pressed() -> void:
	animation_player.play(&"fade_out")
	await animation_player.animation_finished
	get_tree().change_scene_to_file("res://ui/game/game.tscn")
