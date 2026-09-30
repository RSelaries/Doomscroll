extends Control


var posts: ConfigFile = ConfigFile.new()
var current_post: String


@onready var poster_profile_picture: TextureRect = %PosterProfilePicture
@onready var poster_name: Label = %PosterName
@onready var post_content: RichTextLabel = %PostContent


func _ready() -> void:
	var err: Error = posts.load("res://data/posts.cfg")
	if err: return
	
	next_post()


func next_post() -> void:
	# Setup post infos 
	current_post = posts.get_sections()[randi_range(0, posts.get_sections().size() - 1)]
	
	poster_name.text = posts.get_value(current_post, "poster_name", "Poster Name")
	post_content.text = posts.get_value(current_post, "content", "This is a post.")


func _on_repost_btn_pressed() -> void:
	Global.veracity_points.append(posts.get_value(current_post, "veracity"))
	Global.virality_points.append(posts.get_value(current_post, "virality"))
	Global.aggressivity_points.append(posts.get_value(current_post, "aggressivity"))
	Global.update_stats()
	next_post()


func _on_flag_btn_pressed() -> void:
	next_post()
