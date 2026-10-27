@tool
extends PanelContainer


const TAG_SCENE = preload("res://addons/utilities/posts_viewer/post_list_viewer_panel/post_viewer/answer_scene/tag/tag.tscn")
const Tag = preload("res://addons/utilities/posts_viewer/post_list_viewer_panel/post_viewer/answer_scene/tag/tag.gd")


signal answer_deleted(answer: AnswerResource)


@export var tag_stylebox: StyleBox

var answer: AnswerResource

@onready var answer_label: TextEdit = %AnswerLabel
@onready var followers: EditorSpinSlider = %Followers
@onready var likes: EditorSpinSlider = %Likes
@onready var dislikes: EditorSpinSlider = %Dislikes
@onready var tags_container: HFlowContainer = %TagsContainer
@onready var delete_answer_button: Button = %DeleteAnswerButton


func _ready() -> void:
	if answer:
		_update()
	
	delete_answer_button.icon = EditorInterface.get_editor_theme().get_icon("Remove", "EditorIcons")
	
	var add_tag_button := Button.new()
	add_tag_button.icon = EditorInterface.get_editor_theme().get_icon("Add", "EditorIcons")
	tags_container.add_child(add_tag_button, false, Node.INTERNAL_MODE_BACK)
	
	# Signals
	add_tag_button.pressed.connect(func(): answer.add_tags.append(""); _update())
	delete_answer_button.pressed.connect(func(): answer_deleted.emit(answer); queue_free())
	answer_label.text_changed.connect(func(): answer.content = answer_label.text)
	followers.value_changed.connect(func(value): answer.add_followers_amount = value)
	likes.value_changed.connect(func(value): answer.add_likes_amount = value)
	dislikes.value_changed.connect(func(value): answer.add_dislikes_amount = value)


func _update() -> void:
	answer_label.text = answer.content
	followers.value = answer.add_followers_amount
	likes.value = answer.add_likes_amount
	dislikes.value = answer.add_dislikes_amount
	for child in tags_container.get_children():
		child.queue_free()
	for tag in answer.add_tags:
		var new_tag: Tag = TAG_SCENE.instantiate()
		new_tag.tag = tag
		new_tag.tag_changed.connect(func(tag, new_value):
				answer.add_tags[answer.add_tags.find(tag)] = new_value)
		new_tag.tag_deleted.connect(func(tag):
				answer.add_tags.erase(tag)
				_update())
		tags_container.add_child(new_tag)
