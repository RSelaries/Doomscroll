extends Control


var posts: ConfigFile = ConfigFile.new()
var current_post: String
var remaining_posts: PackedStringArray


@onready var poster_profile_picture: TextureRect = %PosterProfilePicture
@onready var poster_name: Label = %PosterName
@onready var post_content: RichTextLabel = %PostContent


func _ready() -> void:
	var err: Error = posts.load("res://data/posts.cfg")
	if err:
		printerr(err)
		return
	
	remaining_posts = posts.get_sections()
	next_post()


func next_post() -> void:
	hide()
	if remaining_posts.size() < 1:
		Global.end_game()
		return
	
	# Setup post infos 
	current_post = remaining_posts[randi_range(0, remaining_posts.size() - 1)]
	remaining_posts.erase(current_post)
	
	poster_name.text = posts.get_value(current_post, "poster_name", "Poster Name")
	post_content.text = posts.get_value(current_post, "content", "This is a post.")
	
	show()


func _on_repost_btn_pressed() -> void:
	if posts.has_section_key(current_post, "repost/veracity"):
		Global.veracity_points.append(posts.get_value(current_post, "repost/veracity"))
	if posts.has_section_key(current_post, "repost/virality"):
		Global.virality_points.append(posts.get_value(current_post, "repost/virality"))
	if posts.has_section_key(current_post, "repost/virality"):
		Global.aggressivity_points.append(posts.get_value(current_post, "repost/aggressivity"))
	Global.update_stats()
	next_post()


func _on_flag_btn_pressed() -> void:
	if posts.has_section_key(current_post, "flag/veracity"):
		Global.veracity_points.append(posts.get_value(current_post, "flag/veracity"))
	if posts.has_section_key(current_post, "flag/virality"):
		Global.virality_points.append(posts.get_value(current_post, "flag/virality"))
	if posts.has_section_key(current_post, "flag/virality"):
		Global.aggressivity_points.append(posts.get_value(current_post, "flag/aggressivity"))
	Global.update_stats()
	next_post()
