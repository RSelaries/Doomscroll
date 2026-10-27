@tool
class_name PostListViewerPanel
extends ScrollContainer


const POST_VIEWER_SCENE = preload("res://addons/utilities/posts_viewer/post_list_viewer_panel/post_viewer/post_viewer.tscn")
const PostViewer = preload("res://addons/utilities/posts_viewer/post_list_viewer_panel/post_viewer/post_viewer.gd")


@export var post_list: PostListResource

@onready var posts_container: VBoxContainer = %PostsContainer
@onready var add_post_button: Button = %AddPostButton


func _ready() -> void:
	add_post_button.icon = EditorInterface.get_editor_theme().get_icon("Add", "EditorIcons")
	
	update()
	
	post_list.changed.connect(update)


func update() -> void:
	for child in posts_container.get_children():
		child.queue_free()
	
	if not post_list: return
	
	for post in post_list.posts:
		var new_post: PostViewer = POST_VIEWER_SCENE.instantiate()
		new_post.post = post
		new_post.post_deleted.connect(_on_post_deleted)
		posts_container.add_child(new_post)


func _on_add_post_button_pressed() -> void:
	var posts: Array[PostResource] = post_list.posts.duplicate()
	posts.append(PostResource.new())
	DoomscrollPluginUndoRedo.set_property(post_list, &"posts", posts, "Add post")


func _on_post_deleted(post: PostResource) -> void:
	var posts: Array[PostResource] = post_list.posts.duplicate()
	posts.erase(post)
	DoomscrollPluginUndoRedo.set_property(post_list, &"posts", posts, "Add post")
