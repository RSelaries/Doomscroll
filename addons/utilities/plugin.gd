@tool
extends EditorPlugin


const POSTS_VIEWER_SCENE = preload("res://addons/utilities/posts_viewer/posts_viewer.tscn")


var post_viewer: Control


func _enable_plugin() -> void:
	# Add autoloads here.
	pass


func _disable_plugin() -> void:
	# Remove autoloads here.
	pass


func _enter_tree() -> void:
	post_viewer = POSTS_VIEWER_SCENE.instantiate()
	DoomscrollPluginUndoRedo.manager = get_undo_redo()
	DoomscrollPluginUndoRedo.context = post_viewer
	EditorInterface.get_editor_main_screen().add_child(post_viewer)
	_make_visible(false)
	add_tool_menu_item("Convert CSV to PostListResource", convert_csv)


func _exit_tree() -> void:
	DoomscrollPluginUndoRedo.manager = null
	DoomscrollPluginUndoRedo.context = null
	if post_viewer:
		post_viewer.queue_free()
	remove_tool_menu_item("Convert CSV to PostListResource")


func _make_visible(visible: bool) -> void:
	if post_viewer:
		post_viewer.visible = visible


func _has_main_screen() -> bool:
	return true


func _get_plugin_name() -> String:
	return "Posts Viewer"


func _get_plugin_icon():
	return EditorInterface.get_editor_theme().get_icon("Object", "EditorIcons")


func convert_csv() -> void:
	var open_csv_popup: FileDialog = FileDialog.new()
	open_csv_popup.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	open_csv_popup.add_filter("*.csv", "CSV Files")
	open_csv_popup.file_selected.connect(_convert_csv_file)
	add_child(open_csv_popup)
	open_csv_popup.popup_file_dialog()


func _convert_csv_file(file_path: String) -> void:
	var file: FileAccess = FileAccess.open(file_path, FileAccess.READ)
	var headers: PackedStringArray
	
	while not file.eof_reached():
		var line: PackedStringArray = file.get_csv_line()
		if line[0].begins_with("#"):
			continue
		if headers.size() == 0:
			headers = line
			continue
