@tool
class_name SubPostScene
extends Control


@export var subpost: SubPostResource: set = _set_subpost


@onready var poster_pfp: TextureRect = %PosterPfp
@onready var poster_name: Label = %PosterName
@onready var poster_at: Label = %PosterAt
@onready var post_content: RichTextLabel = %PostContent
@onready var post_media: TextureRect = %PostMedia


func _ready() -> void:
	_update_post()


func _update_post() -> void:
	if not subpost or not poster_at:
		return
	
	poster_pfp.texture = subpost.poster_pfp
	poster_at.text = subpost.at
	poster_name.text = subpost.name
	post_content.text = subpost.content
	if subpost.media:
		post_media.show()
		post_media.texture = subpost.media
	else:
		post_media.hide()


func _set_subpost(new_value: SubPostResource) -> void:
	subpost = new_value
	_update_post()
