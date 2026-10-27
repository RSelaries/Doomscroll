@tool
extends Control


@export var subpost: SubPostResource


@onready var poster_name: LineEdit = %PosterName
@onready var poster_at: LineEdit = %PosterAt
@onready var post_content: TextEdit = %PostContent
@onready var pfp_picker: EditorResourcePicker = %PfpPicker
@onready var media_picker: EditorResourcePicker = %MediaPicker
@onready var clear_media_button: Button = %ClearMediaButton


func _ready() -> void:
	_update_post()
	clear_media_button.icon = EditorInterface.get_editor_theme().get_icon("Remove", "EditorIcons")
	
	# signals
	poster_name.text_changed.connect(func(text): subpost.name = text)
	poster_at.text_changed.connect(func(text): subpost.at = text)
	post_content.text_changed.connect(func(): subpost.content = post_content.text)
	pfp_picker.resource_changed.connect(func(res: Texture2D): subpost.poster_pfp = res)
	media_picker.resource_changed.connect(func(res: Texture2D): subpost.media = res)
	clear_media_button.pressed.connect(func(): media_picker.edited_resource = null; subpost.media = null)


func _update_post() -> void:
	if not subpost or not poster_at:
		return
	
	poster_at.text = subpost.at
	poster_name.text = subpost.name
	post_content.text = subpost.content
	pfp_picker.edited_resource = subpost.poster_pfp
	media_picker.edited_resource = subpost.media


func _set_subpost(new_value: SubPostResource) -> void:
	subpost = new_value
	_update_post()


func _on_edit_media_button_pressed() -> void:
	pass # Replace with function body.


func _on_delete_media_button_pressed() -> void:
	pass # Replace with function body.
