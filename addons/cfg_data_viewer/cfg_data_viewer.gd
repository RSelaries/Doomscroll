@tool
extends EditorPlugin


const DataViewerScene = preload("res://addons/cfg_data_viewer/data_viewer_scene/data_viewer_scene.tscn")

var data_viewer_instance: Control


func _enable_plugin() -> void:
	# Add autoloads here.
	pass


func _disable_plugin() -> void:
	# Remove autoloads here.
	pass


func _enter_tree() -> void:
	data_viewer_instance = DataViewerScene.instantiate()
	EditorInterface.get_editor_main_screen().add_child(data_viewer_instance)
	_make_visible(false)


func _exit_tree() -> void:
	if data_viewer_instance:
		data_viewer_instance.queue_free()


func _make_visible(visible: bool) -> void:
	if data_viewer_instance:
		data_viewer_instance.visible = visible

func _has_main_screen() -> bool:
	return true

func _get_plugin_name() -> String:
	return "CFG Data Viewer"

func _get_plugin_icon() -> Texture2D:
	return EditorInterface.get_editor_theme().get_icon("TextFile", "EditorIcons")
