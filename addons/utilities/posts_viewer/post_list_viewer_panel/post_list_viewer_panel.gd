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
	
	for post in post_list.posts:
		var new_post: PostViewer = POST_VIEWER_SCENE.instantiate()
		new_post.post = post
		new_post.post_deleted.connect(_on_post_deleted)
		posts_container.add_child(new_post)


func _on_add_post_button_pressed() -> void:
	var new_post := PostResource.new()
	var new_post_scene: PostViewer = POST_VIEWER_SCENE.instantiate()
	new_post_scene.post = new_post
	new_post_scene.post_deleted.connect(_on_post_deleted)
	posts_container.add_child(new_post_scene)
	post_list.posts.append(new_post)


func _on_post_deleted(post: PostResource) -> void:
	post_list.posts.erase(post)
	print(post_list.posts)
