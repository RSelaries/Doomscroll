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
	
	answer.changed.connect(_update)
	
	delete_answer_button.icon = EditorInterface.get_editor_theme().get_icon("Remove", "EditorIcons")
	
	var add_tag_button := Button.new()
	add_tag_button.icon = EditorInterface.get_editor_theme().get_icon("Add", "EditorIcons")
	tags_container.add_child(add_tag_button, false, Node.INTERNAL_MODE_BACK)
	
	# Signals
	add_tag_button.pressed.connect(func():
			var tags: PackedStringArray = answer.add_tags.duplicate()
			tags.append("")
			DoomscrollPluginUndoRedo.set_property(answer, &"add_tags", tags, "Add tag"))
	answer_label.text_changed.connect(func():
			DoomscrollPluginUndoRedo.set_property(answer, &"content", answer_label.text, "Edit answer", true))
	followers.value_changed.connect(func(value):
			DoomscrollPluginUndoRedo.set_property(answer, &"add_followers_amount", value, "Edit followers", true))
	likes.value_changed.connect(func(value):
			DoomscrollPluginUndoRedo.set_property(answer, &"add_likes_amount", value, "Edit likes", true))
	dislikes.value_changed.connect(func(value):
			DoomscrollPluginUndoRedo.set_property(answer, &"add_dislikes_amount", value, "Edit dislikes", true))
	delete_answer_button.pressed.connect(func(): answer_deleted.emit(answer))


func _update() -> void:
	if answer_label.text != answer.content:
		answer_label.text = answer.content
	followers.set_value_no_signal(answer.add_followers_amount)
	likes.set_value_no_signal(answer.add_likes_amount)
	dislikes.set_value_no_signal(answer.add_dislikes_amount)
	
	if tags_container.get_child_count() != answer.add_tags.size():
		for child in tags_container.get_children():
			child.queue_free()
		for i in answer.add_tags.size():
			var new_tag: Tag = TAG_SCENE.instantiate()
			new_tag.tag = answer.add_tags[i]
			new_tag.tag_changed.connect(_on_tag_edited.bind(i))
			new_tag.tag_deleted.connect(_on_tag_deleted.bind(i))
			tags_container.add_child(new_tag)
	else:
		for i in answer.add_tags.size():
			tags_container.get_child(i).set_text_no_signal(answer.add_tags[i])


func _on_tag_edited(new_value: String, index: int) -> void:
	var tags: PackedStringArray = answer.add_tags.duplicate()
	tags[index] = new_value
	DoomscrollPluginUndoRedo.set_property(answer, &"add_tags", tags, "Edit tag")


func _on_tag_deleted(index: int) -> void:
	var tags: PackedStringArray = answer.add_tags.duplicate()
	tags.remove_at(index)
	DoomscrollPluginUndoRedo.set_property(answer, &"add_tags", tags, "Delete tag")
