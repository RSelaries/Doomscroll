class_name MessageScene
extends HBoxContainer


@onready var pfp_texture_rect: TextureRect = %PfpTexture
@onready var character_name_label: Label = %CharacterName
@onready var message_content_label: RichTextLabel = %MessageContent

var message_content: String
var character_name: String


func _ready() -> void:
	character_name_label.text = character_name
	message_content_label.text = message_content
