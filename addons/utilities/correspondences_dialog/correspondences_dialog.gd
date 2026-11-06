@tool
extends AcceptDialog


var option_buttons: Array[OptionButton] = [
	post_name, post_at, post_likes, post_dislikes, post_content,
	post_media, post_pfp, sub_post_content, sub_post_name,
	sub_post_at, sub_post_media, sub_post_pfp,
]

@onready var post_name: OptionButton = %PostName
@onready var post_at: OptionButton = %PostAt
@onready var post_likes: OptionButton = %PostLikes
@onready var post_dislikes: OptionButton = %PostDislikes
@onready var post_content: OptionButton = %PostContent
@onready var post_media: OptionButton = %PostMedia
@onready var post_pfp: OptionButton = %PostPfp
@onready var sub_post_content: OptionButton = %SubPostContent
@onready var sub_post_name: OptionButton = %SubPostName
@onready var sub_post_at: OptionButton = %SubPostAt
@onready var sub_post_media: OptionButton = %SubPostMedia
@onready var sub_post_pfp: OptionButton = %SubPostPfp
@onready var answer_amount: EditorSpinSlider = %AnswerAmount
@onready var answer_content: LineEdit = %AnswerContent
@onready var answer_followers: LineEdit = %AnswerFollowers
@onready var answer_likes: LineEdit = %AnswerLikes
@onready var answer_dislikes: LineEdit = %AnswerDislikes
@onready var answer_tags: LineEdit = %AnswerTags


var header_correspondences: Dictionary[String, Dictionary] = {
	"post_resource": {
		"name": "name",
		"at": "at",
		"poster_pfp": "poster_pfp",
		"content": "content",
		"media": "media",
		"likes": "likes",
		"dislikes": "dislikes",
	},
	"subpost_resource": {
		"name": "subpost_name",
		"at": "subpost_at",
		"poster_pfp": "subpost_poster_pfp",
		"content": "subpost_content",
		"media": "subpost_media",
	},
	"answer_resource": {
		"answer_amount": 2,
		"content": "comment_%s",
		"add_followers_amount": "comment_%s_followers",
		"add_likes_amount": "comment_%s_likes",
		"add_dislikes_amount": "comment_%s_dislikes",
		"add_tags": "comment_%s_tags",
	},
}


func get_correspondences(headers: PackedStringArray) -> Dictionary[String, Dictionary]:
	for button in option_buttons:
		for i in headers.size():
			var header = headers[i]
			button.add_item(header)
	
	await confirmed
	
	return header_correspondences
