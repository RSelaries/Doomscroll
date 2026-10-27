class_name PostResource
extends Resource


@export_group("Poster Infos")
@export var name: String
@export var at: String
@export var poster_pfp: Texture2D
@export_group("Post Content")
@export_multiline var content: String
@export var media: Texture2D
@export var likes: int
@export var dislikes: int
@export_group("SubPost")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var has_subpost: bool = false
@export var subpost: SubPostResource
@export_group("Answers")
@export var answers: Array[AnswerResource]
