extends MarginContainer


var posts: ConfigFile = ConfigFile.new()
var current_post: String
var remaining_posts: PackedStringArray


@onready var poster_profile_picture: TextureRect = %PosterProfilePicture
@onready var poster_name: Label = %PosterName
@onready var post_content: RichTextLabel = %PostContent
@onready var repost_btn: Button = %RepostBtn
@onready var flag_btn: Button = %FlagBtn
@onready var replay_btn: Button = %ReplayBtn
@onready var poster_at: Label = %PosterAt


func _ready() -> void:
	var err: Error = posts.load("res://data/posts.cfg")
	if err:
		printerr("Error %S. Can't load posts data" % err)
		return
	
	remaining_posts = posts.get_sections()
	Global.end_reached.connect(end_scene)
	next_post()


func next_post() -> void:
	hide()
	if remaining_posts.size() < 1:
		Global.end_game()
		return
	
	repost_btn.show()
	flag_btn.show()
	replay_btn.hide()
	poster_at.hide()
	
	# Setup post infos 
	current_post = remaining_posts[randi_range(0, remaining_posts.size() - 1)]
	remaining_posts.erase(current_post)
	
	if posts.has_section_key(current_post, "poster_at"):
		poster_at.show()
		poster_at.text = "@" + posts.get_value(current_post, "poster_at", "")
	
	if posts.has_section_key(current_post, "poster_pp"):
		var poster_pp_path: String = posts.get_value(current_post, "poster_pp", "")
		poster_profile_picture.texture = load(poster_pp_path)
	else:
		poster_profile_picture.texture = load("uid://bq4abeek0t6uq")
	
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


func end_scene() -> void:
	poster_name.text = "Dieu"
	post_content.text = Global.get_ending()
	repost_btn.hide()
	flag_btn.hide()
	replay_btn.show()
	show()


func _on_replay_btn_pressed() -> void:
	get_tree().current_scene.animation_player.play(&"fade_out")
	await get_tree().current_scene.animation_player.animation_finished
	Global.veracity_points.clear()
	Global.aggressivity_points.clear()
	Global.virality_points.clear()
	get_tree().change_scene_to_file("res://main.tscn")
