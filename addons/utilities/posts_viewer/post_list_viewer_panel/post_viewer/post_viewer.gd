@tool
extends Control


const ANSWER_SCENE = preload("res://addons/utilities/posts_viewer/post_list_viewer_panel/post_viewer/answer_scene/answer_scene.tscn")
const AnswerSceneType = preload("res://addons/utilities/posts_viewer/post_list_viewer_panel/post_viewer/answer_scene/answer_scene.gd")


signal post_deleted(post: PostResource)


@export var post: PostResource: set = _set_post


@onready var poster_name: LineEdit = %PosterName
@onready var poster_at: LineEdit = %PosterAt
@onready var post_content: TextEdit = %PostContent
@onready var likes_amount: EditorSpinSlider = %LikesAmount
@onready var dislikes_amount: EditorSpinSlider = %DislikesAmount
@onready var answers_container: Container = %AnswersContainer
@onready var subpost_scene: Control = %SubpostScene
@onready var delete_post_button: Button = %DeletePostButton
@onready var media_picker: EditorResourcePicker = %MediaPicker
@onready var clear_media_button: Button = %ClearMediaButton
@onready var pfp_picker: EditorResourcePicker = %PfpPicker


func _ready() -> void:
	if post:
		_update_post()
	delete_post_button.icon = EditorInterface.get_editor_theme().get_icon("Remove", "EditorIcons")
	clear_media_button.icon = EditorInterface.get_editor_theme().get_icon("Remove", "EditorIcons")
	
	var new_answer_button := Button.new()
	new_answer_button.icon = EditorInterface.get_editor_theme().get_icon("Add", "EditorIcons")
	answers_container.add_child(new_answer_button, false, Node.INTERNAL_MODE_BACK)
	
	# signals
	new_answer_button.pressed.connect(func(): post.answers.append(AnswerResource.new()); _update_post())
	poster_name.text_changed.connect(func(text: String): post.name = text)
	poster_at.text_changed.connect(func(text: String): post.at = text)
	post_content.text_changed.connect(func(): post.content = post_content.text)
	likes_amount.value_changed.connect(func(value): post.likes = value)
	dislikes_amount.value_changed.connect(func(value): post.dislikes = value)
	media_picker.resource_changed.connect(func(res: Texture2D): post.media = res)
	clear_media_button.pressed.connect(func(): media_picker.edited_resource = null; post.media = null)
	pfp_picker.resource_changed.connect(func(res: Texture2D): post.poster_pfp = res)


func _update_post() -> void:
	if not post or not poster_name:
		return
	
	poster_name.text = post.name
	poster_at.text = post.at
	post_content.text = post.content
	likes_amount.value = post.likes
	dislikes_amount.value = post.dislikes
	pfp_picker.edited_resource = post.poster_pfp
	media_picker.edited_resource = post.media
	if post.subpost:
		subpost_scene.show()
		subpost_scene.subpost = post.subpost
	else :
		subpost_scene.hide()
	
	for child in answers_container.get_children():
		child.queue_free()
	 
	for answer in post.answers:
		var new_answer: AnswerSceneType = ANSWER_SCENE.instantiate()
		new_answer.answer = answer
		new_answer.answer_deleted.connect(func(answer): post.answers.erase(answer))
		answers_container.add_child(new_answer)


func _set_post(new_value: PostResource) -> void:
	post = new_value
	_update_post()


func _on_delete_post_button_pressed() -> void:
	queue_free()
	post_deleted.emit(post)
