@tool
extends EditorPlugin


func _enable_plugin() -> void:
	# Add autoloads here.
	pass


func _disable_plugin() -> void:
	# Remove autoloads here.
	pass


func _enter_tree() -> void:
	add_tool_menu_item("Convert CSV to PostListResource", convert_csv)


func _exit_tree() -> void:
	remove_tool_menu_item("Convert CSV to PostListResource")


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
