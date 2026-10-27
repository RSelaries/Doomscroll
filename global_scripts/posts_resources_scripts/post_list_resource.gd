class_name PostListResource
extends Resource


@export var posts: Array[PostResource]:
	set(value):
		if value != posts:
			posts = value
			emit_changed()
