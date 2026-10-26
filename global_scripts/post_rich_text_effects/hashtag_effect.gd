@tool
# Having a class name is handy for picking the effect in the Inspector.
class_name HashtagEffect
extends RichTextEffect


# To use this effect:
# - Enable BBCode on a RichTextLabel.
# - Register this effect on the label.
# - Use [ht]hello[/ht] in text.
var bbcode := "ht"


func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	#var param: float = char_fx.env.get("param", 1.0)
	char_fx.color = PostManager.HASHTAG_COLOR
	return true
