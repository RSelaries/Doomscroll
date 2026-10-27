@tool
extends Control


const POST_LIST_VIEWER_SCENE = preload("res://addons/utilities/posts_viewer/post_list_viewer_panel/post_list_viewer_panel.tscn")
const PostListViewer = preload("res://addons/utilities/posts_viewer/post_list_viewer_panel/post_list_viewer_panel.gd")


@onready var toggle_file_panel_button: Button = %ToggleFilePanelButton
@onready var open_file_button: Button = %OpenFileButton
@onready var file_panel: VBoxContainer = %FilePanel
@onready var opened_file_name: Label = %OpenedFileName
@onready var open_file_dialog: FileDialog = %OpenFileDialog
@onready var opened_files_list: ItemList = %OpenedFilesList
@onready var post_lists_container: TabContainer = %PostListsContainer


var opened_files: Array[Dictionary]


func _ready() -> void:
	toggle_file_panel_button.icon = EditorInterface.get_editor_theme().get_icon(
			"SidebarLeft", "EditorIcons")
	open_file_button.icon = EditorInterface.get_editor_theme().get_icon(
			"Load", "EditorIcons")


func _drop_data(at_position: Vector2, data: Variant) -> void:
	var files_path: PackedStringArray = data.files
	for file_path in files_path:
		_on_file_opened(file_path, false)


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if data.type == "files":
		return true
	return false


func _on_toggle_file_panel_button_toggled(toggled_on: bool) -> void:
	file_panel.visible = toggled_on


func _on_open_file_button_pressed() -> void:
	open_file_dialog.popup_file_dialog()


func _on_file_opened(path: String, print_error: bool = true) -> void:
	if not (path.ends_with(".res") or path.ends_with(".tres")):
		if print_error:
			push_error("Ce fichier n'est pas une resource.")
		return
	
	var resource: Resource = load(path) as Resource
	if resource is PostListResource:
		_file_opened(path, resource)
	elif print_error:
		push_error("Ce fichier n'est pas une PostListResource.")


func _file_opened(path: String, resource: PostListResource) -> void:
	for i in opened_files.size():
		var opened_file := opened_files[i]
		if opened_file.path == path:
			opened_files_list.select(i)
			_on_opened_files_list_item_selected(i)
			return
	
	opened_files.append({
		"path": path,
		"post_list_res": resource,
		"res_name": path.split("/")[-1],
	})
	opened_files_list.add_item(path.split("/")[-1],
			EditorInterface.get_editor_theme().get_icon("Object", "EditorIcons"))
	var new_post_list_viewer: PostListViewer = POST_LIST_VIEWER_SCENE.instantiate()
	new_post_list_viewer.post_list = resource
	post_lists_container.add_child(new_post_list_viewer)
	opened_files_list.select(opened_files.size() - 1)
	_on_opened_files_list_item_selected(opened_files.size() - 1)


func _on_opened_files_list_item_selected(index: int) -> void:
	post_lists_container.current_tab = index
	opened_file_name.text = opened_files[index].res_name
