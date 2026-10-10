extends MarginContainer


@onready var virality_value: Label = %ViralityValue
@onready var veracity_value: Label = %VeracityValue
@onready var aggressivity_value: Label = %AggressivityValue


func _ready() -> void:
	Global.stats_updated.connect(_update_stats)
	_update_stats()


func _update_stats() -> void:
	virality_value.text = "%d" % [Global.virality * 100]
	veracity_value.text = "%d" % [Global.veracity * 100]
	aggressivity_value.text = "%d" % [Global.aggressivity * 100]
