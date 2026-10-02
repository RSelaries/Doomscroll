@tool
extends ScrollContainer


var file_path: String
var file: ConfigFile = ConfigFile.new()
var tree_root: TreeItem
var headings: PackedStringArray


@onready var config_file_data: Tree = %ConfigFileData


func _ready() -> void:
	var err: Error = file.load(file_path)
	if err: return
	
	for section: String in file.get_sections():
		for key: String in file.get_section_keys(section):
			if headings.has(key): break
			headings.append(key)
	
	config_file_data.columns = headings.size()
	tree_root = config_file_data.create_item()
	
	for i in headings.size():
		config_file_data.set_column_title(i, headings[i])
	
	for section in file.get_sections():
		var new_item: TreeItem = config_file_data.create_item(tree_root)
		for i in headings.size():
			new_item.set_text(i, str(file.get_value(section, headings[i], "")))
			new_item.set_editable(i, true)
			new_item.set_edit_multiline(i, true)
	
