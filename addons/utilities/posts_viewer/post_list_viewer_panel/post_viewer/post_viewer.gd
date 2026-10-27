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
	new_answer_button.pressed.connect(func():
			var answers: Array[AnswerResource] = post.answers.duplicate()
			answers.append(AnswerResource.new())
			DoomscrollPluginUndoRedo.set_property(post, &"answers", answers, "Add new answer"))
	poster_name.text_changed.connect(func(t: String):
			DoomscrollPluginUndoRedo.set_property(post, &"name", t, "Edit name", true))
	poster_at.text_changed.connect(func(t: String):
			DoomscrollPluginUndoRedo.set_property(post, &"at", t, "Edit @", true))
	post_content.text_changed.connect(func():
			DoomscrollPluginUndoRedo.set_property(post, &"content", post_content.text, "Edit content", true))
	likes_amount.value_changed.connect(func(v):
			DoomscrollPluginUndoRedo.set_property(post, &"likes", v, "Edit likes", true))
	dislikes_amount.value_changed.connect(func(v):
			DoomscrollPluginUndoRedo.set_property(post, &"dislikes", v, "Edit dislikes", true))
	media_picker.resource_changed.connect(func(res: Texture2D):
			DoomscrollPluginUndoRedo.set_property(post, &"media", res, "Change media"))
	clear_media_button.pressed.connect(func():
			DoomscrollPluginUndoRedo.set_property(post, &"media", null, "Clear media"))
	pfp_picker.resource_changed.connect(func(res: Texture2D):
			DoomscrollPluginUndoRedo.set_property(post, &"poster_pfp", res, "Change poster_pfp"))


func _update_post() -> void:
	if not post or not poster_name:
		return
	
	if poster_name.text != post.name:
		poster_name.text = post.name
	if poster_at.text != post.at:
		poster_at.text = post.at
	if post_content.text != post.content:
		post_content.text = post.content
	if pfp_picker.edited_resource != post.poster_pfp:
		pfp_picker.edited_resource = post.poster_pfp
	if media_picker.edited_resource != post.media:
		media_picker.edited_resource = post.media
	
	likes_amount.set_value_no_signal(post.likes)
	dislikes_amount.set_value_no_signal(post.dislikes)
	
	if post.subpost:
		subpost_scene.show()
		subpost_scene.subpost = post.subpost
	else :
		subpost_scene.hide()
	
	if answers_container.get_child_count() != post.answers.size():
		for child in answers_container.get_children():
			child.queue_free()
		 
		for answer in post.answers:
			var new_answer: AnswerSceneType = ANSWER_SCENE.instantiate()
			new_answer.answer = answer
			new_answer.answer_deleted.connect(_on_answer_deleted)
			answers_container.add_child(new_answer)


func _set_post(new_value: PostResource) -> void:
	if post and post.changed.is_connected(_update_post):
		post.changed.disconnect(_update_post)
	post = new_value
	if post:
		post.changed.connect(_update_post)
	_update_post()


func _on_answer_deleted(answer: AnswerResource) -> void:
	var answers: Array[AnswerResource] = post.answers.duplicate()
	answers.erase(answer)
	DoomscrollPluginUndoRedo.set_property(post, &"answers", answers, "Delete answer")


func _on_delete_post_button_pressed() -> void:
	post_deleted.emit(post)
