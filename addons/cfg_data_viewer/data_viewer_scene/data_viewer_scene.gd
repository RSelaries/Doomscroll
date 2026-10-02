@tool
extends VBoxContainer


const CONFIG_FILE_DATA_TABLE = preload("res://addons/cfg_data_viewer/data_viewer_scene/config_file_data_table/config_file_data_table.tscn")
const TEST_FILE_PATH = "res://data/posts.cfg"


@onready var config_file_name: Label = %ConfigFileName
@onready var opened_config_files_tabs: Tree = %OpenedConfigFilesTabs
@onready var opened_config_files_container: TabContainer = %OpenedConfigFilesContainer


func _ready() -> void:
	opened_config_files_tabs.create_item()
	open_file(TEST_FILE_PATH)


func open_file(file_path: String) -> void:
	config_file_name.text = file_path
	
	var new_opened_file: TreeItem = opened_config_files_tabs.create_item()
	new_opened_file.set_text(0, file_path)
	new_opened_file.set_selectable(0, true)
	new_opened_file.set_icon(0, EditorInterface.get_editor_theme().get_icon("TextFile", "EditorIcons"))
	
	var new_table: Control = CONFIG_FILE_DATA_TABLE.instantiate()
	new_table.file_path = file_path
	opened_config_files_container.add_child(new_table)
	opened_config_files_container.set_tab_title(
		opened_config_files_container.get_child_count() - 1, file_path
	)


func _on_opened_config_files_tabs_item_selected() -> void:
	#var selected: TreeItem = opened_config_files_tabs.get_selected()
	#opened_config_files_container.
	pass
