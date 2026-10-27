@tool
extends PanelContainer


signal tag_deleted()
signal tag_changed(tag: String, new_value: String)


@onready var delete_tag_button: Button = %DeleteTagButton
@onready var tag_line_edit: LineEdit = %TagLineEdit


var tag: String


func _ready() -> void:
	delete_tag_button.icon = EditorInterface.get_editor_theme().get_icon("Remove", "EditorIcons")
	tag_line_edit.text = tag
	
	# signals
	tag_line_edit.text_changed.connect(func(text): tag_changed.emit(text))
	delete_tag_button.pressed.connect(func(): tag_deleted.emit())


func set_text_no_signal(text: String) -> void:
	if tag_line_edit.text != text:
		tag_line_edit.text = text
