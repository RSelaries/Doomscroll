@tool
extends PanelContainer


signal tag_deleted(tag: String)
signal tag_changed(tag: String, new_value: String)


@onready var delete_tag_button: Button = %DeleteTagButton
@onready var tag_line_edit: LineEdit = %TagLineEdit


var tag: String:
	set(value):
		tag_changed.emit(tag, value)
		if tag_line_edit and tag_line_edit.text != value:
			tag_line_edit.text = value
		tag = value


func _ready() -> void:
	delete_tag_button.icon = EditorInterface.get_editor_theme().get_icon("Remove", "EditorIcons")
	tag_line_edit.text = tag
	
	# signals
	tag_line_edit.text_changed.connect(func(text): tag = text)
	delete_tag_button.pressed.connect(func(): tag_deleted.emit(tag); queue_free())
