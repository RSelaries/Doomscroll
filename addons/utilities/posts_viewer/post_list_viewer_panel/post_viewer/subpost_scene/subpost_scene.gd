@tool
extends Control


signal subpost_deleted


@export var subpost: SubPostResource


@onready var poster_name: LineEdit = %PosterName
@onready var poster_at: LineEdit = %PosterAt
@onready var post_content: TextEdit = %PostContent
@onready var pfp_picker: EditorResourcePicker = %PfpPicker
@onready var media_picker: EditorResourcePicker = %MediaPicker
@onready var clear_media_button: Button = %ClearMediaButton
@onready var delete_subpost_button: Button = %DeleteSubpostButton


func _ready() -> void:
	_update_post()
	clear_media_button.icon = EditorInterface.get_editor_theme().get_icon("Clear", "EditorIcons")
	delete_subpost_button.icon = EditorInterface.get_editor_theme().get_icon("Remove", "EditorIcons")
	
	# signals
	delete_subpost_button.pressed.connect(subpost_deleted.emit)
	poster_name.text_changed.connect(func(text):
			DoomscrollPluginUndoRedo.set_property(subpost, &"name", text, "Edit name", true))
	poster_at.text_changed.connect(func(text):
			DoomscrollPluginUndoRedo.set_property(subpost, &"at", text, "Edit @", true))
	post_content.text_changed.connect(func():
			DoomscrollPluginUndoRedo.set_property(subpost, &"content", post_content.text, "Edit subpost", true))
	pfp_picker.resource_changed.connect(func(res: Texture2D):
			DoomscrollPluginUndoRedo.set_property(subpost, &"poster_pfp", res, "Change poster_pfp"))
	media_picker.resource_changed.connect(func(res: Texture2D):
			DoomscrollPluginUndoRedo.set_property(subpost, &"media", res, "Change media"))
	clear_media_button.pressed.connect(func():
			DoomscrollPluginUndoRedo.set_property(subpost, &"media", null, "Clear media"))


func _update_post() -> void:
	if not subpost or not poster_at:
		return
	
	if poster_at.text != subpost.at:
		poster_at.text = subpost.at
	if poster_name.text != subpost.name:
		poster_name.text = subpost.name
	if post_content.text != subpost.content:
		post_content.text = subpost.content
	if pfp_picker.edited_resource != subpost.poster_pfp:
		pfp_picker.edited_resource = subpost.poster_pfp
	if media_picker.edited_resource != subpost.media:
		media_picker.edited_resource = subpost.media
