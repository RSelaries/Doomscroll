class_name PostResource
extends Resource


const PROPERTIES = [
	"name", "at", "poster_pfp", "content", "media",
	"likes", "dislikes", "subpost", "answers",
]


@export_group("Poster Infos")
@export var name: String
@export var at: String
@export var poster_pfp: Texture2D = preload("res://assets/posters_pfp/default_pfp.png")
@export_group("Post Content")
@export_multiline var content: String
@export var media: Texture2D
@export var likes: int
@export var dislikes: int
@export var subpost: SubPostResource
@export_group("Answers")
@export var answers: Array[AnswerResource]
