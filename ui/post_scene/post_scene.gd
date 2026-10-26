@tool
extends Control


@export var shown_post: PostResource: set = _set_shown_post


@onready var poster_pfp: TextureRect = %PosterPfp
@onready var poster_name: Label = %PosterName
@onready var poster_at: Label = %PosterAt
@onready var post_content: RichTextLabel = %PostContent
@onready var likes_amount: Label = %LikesAmount
@onready var dislikes_amount: Label = %DislikesAmount
@onready var post_media: TextureRect = %PostMedia
@onready var answers_container: VBoxContainer = %AnswersContainer


func _ready() -> void:
	if shown_post:
		_update_shown_post()


func _update_shown_post() -> void:
	if not shown_post or not poster_pfp:
		return
	
	poster_name.text = shown_post.name
	poster_at.text = "@%s" % shown_post.at
	post_content.text = shown_post.content
	likes_amount.text = str(shown_post.likes)
	dislikes_amount.text = str(shown_post.dislikes)
	poster_pfp.texture = shown_post.poster_pfp
	if shown_post.media:
		post_media.show()
		post_media.texture = shown_post.media
	else:
		post_media.hide()
	
	for child in answers_container.get_children():
		child.queue_free()
	 
	for answer in shown_post.answers:
		var new_answer: AnswerScene = AnswerScene.SCENE.instantiate()
		new_answer.answer = answer
		answers_container.add_child(new_answer)


func _set_shown_post(new_value: PostResource) -> void:
	shown_post = new_value
	_update_shown_post()
