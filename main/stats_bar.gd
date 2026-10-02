extends MarginContainer


@onready var virality_value: Label = %ViralityValue
@onready var veracity_value: Label = %VeracityValue
@onready var aggressivity_value: Label = %AggressivityValue


func _ready() -> void:
	Global.stats_updated.connect(_update_stats)
	_update_stats()


func _update_stats() -> void:
	virality_value.text = "%.2f" % [Global.virality]
	veracity_value.text = "%.2f" % [Global.veracity]
	aggressivity_value.text = "%.2f" % [Global.aggressivity]
