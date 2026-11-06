@tool
extends EditorPlugin


const POSTS_VIEWER_SCENE = preload("res://addons/utilities/posts_viewer/posts_viewer.tscn")
const CORRESPONDENCE_DIALOG_SCENE = preload("res://addons/utilities/correspondences_dialog/correspondences_dialog.tscn")
const CorrespondenceDialog = preload("res://addons/utilities/correspondences_dialog/correspondences_dialog.gd")


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
	var open_csv_popup: EditorFileDialog = EditorFileDialog.new()
	open_csv_popup.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	open_csv_popup.add_filter("*.csv", "CSV Files")
	open_csv_popup.file_selected.connect(_convert_csv_file)
	add_child(open_csv_popup)
	open_csv_popup.popup_file_dialog()


func _convert_csv_file(file_path: String) -> void:
	# -------------------
	# Parse CSV File
	# -------------------
	var file: FileAccess = FileAccess.open(file_path, FileAccess.READ)
	var headers: PackedStringArray
	
	var dicts: Array[Dictionary]
	var index: int = 0
	
	while not file.eof_reached():
		var line: PackedStringArray = file.get_csv_line()
		
		# Get headers
		if headers.size() == 0:
			headers = line
			continue
		
		# Add values
		var new_dict: Dictionary[String, Variant]
		for i in line.size():
			new_dict.set(headers[i], line[i])
		dicts.append(new_dict)
	
	# -------------------
	# Get header correspondences
	# -------------------
	var cor_dialog: CorrespondenceDialog = CORRESPONDENCE_DIALOG_SCENE.instantiate()
	add_child(cor_dialog)
	var header_cor := await cor_dialog.get_correspondences(headers)
	cor_dialog.canceled.connect(func(): cor_dialog.queue_free(); return)
	cor_dialog.queue_free()
	
	# -------------------
	# Create post list
	# -------------------
	var post_list_res: PostListResource = PostListResource.new()
	
	for i in dicts.size():
		var dict: Dictionary[String, Variant] = dicts[i]
		var new_post: PostResource = PostResource.new()
		
		# Answers
		# -----
		var answer_cor := header_cor.answer_resource
		var answers: Array[AnswerResource]
		for an_i in answer_cor.answer_amount:
			var new_answer := AnswerResource.new()
			new_answer.content = dict.get(answer_cor.content % [an_i + 1], "")
			new_answer.add_followers_amount = int(dict.get(answer_cor.add_followers_amount % [an_i + 1], ""))
			new_answer.add_likes_amount = int(dict.get(answer_cor.add_likes_amount % [an_i + 1], ""))
			new_answer.add_dislikes_amount = int(dict.get(answer_cor.add_dislikes_amount % [an_i + 1], ""))
			new_answer.add_tags = dict.get(answer_cor.add_tags % [an_i + 1], "").split(",")
			answers.append(new_answer)
		
		# Post
		# -----
		var post_resource_cor := header_cor.post_resource
		new_post.name = dict.get(post_resource_cor.name, "")
		new_post.at = dict.get(post_resource_cor.at, "")
		new_post.content = dict.get(post_resource_cor.content, "")
		new_post.answers = answers
		new_post.likes = dict.get(post_resource_cor.likes, "")
		new_post.dislikes = dict.get(post_resource_cor.dislikes, "")
		# poster pfp
		var pfp = dict.get(post_resource_cor.poster_pfp, "")
		if pfp and FileAccess.file_exists(pfp):
			new_post.poster_pfp = load(pfp)
		# post media
		var media = dict.get(post_resource_cor.media, "")
		if media and FileAccess.file_exists(media):
			new_post.poster_pfp = load(media)
		
		# Subpost
		# -----
		var subpost_cor := header_cor.subpost_resource
		if subpost_cor.content:
			var new_subpost := SubPostResource.new()
			new_subpost.name = dict.get(subpost_cor.name, "")
			new_subpost.at = dict.get(subpost_cor.at, "")
			new_subpost.content = dict.get(subpost_cor.content, "")
			var sub_media = dict.get(subpost_cor.media, "")
			if sub_media and FileAccess.file_exists(sub_media):
				new_subpost.media = load(sub_media)
			var sub_pfp = dict.get(subpost_cor.poster_pfp, "")
			if sub_pfp and FileAccess.file_exists(sub_pfp):
				new_subpost.poster_pfp = load(sub_pfp)
			new_post.subpost = new_subpost
		
		post_list_res.posts.append(new_post)
	
	# -------------------
	# Save resource
	# -------------------
	var save_popup: EditorFileDialog = EditorFileDialog.new()
	save_popup.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	save_popup.file_selected.connect(_save_post_list_res.bind(post_list_res))
	save_popup.add_filter("*.tres", "TRES")
	save_popup.root_subfolder = "res://data"
	add_child(save_popup)
	save_popup.popup_file_dialog()


func _save_post_list_res(at: String, res: PostListResource) -> void:
	ResourceSaver.save(res, at)
	EditorInterface.get_resource_filesystem().update_file(at)
	ResourceLoader.load(at, "", ResourceLoader.CACHE_MODE_REPLACE)
