class_name AnswerResource
extends Resource


const PROPERTIES = [
	"content", "add_followers_amount", "add_likes_amount",
	"add_dislikes_amount", "add_tags",
]


@export_multiline var content: String
@export var add_followers_amount: int
@export var add_likes_amount: int
@export var add_dislikes_amount: int
@export var add_tags: PackedStringArray
