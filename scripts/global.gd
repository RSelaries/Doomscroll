extends Node


signal stats_updated
signal end_reached


# Stats
## A number between -1 and 1 representing the trustworthyness of the account.
var veracity: float:
	get = get_veracity
## A number between -1 and 1 representing the virality of the account.
var virality: float:
	get = get_virality
## A number between -1 and 1 representing the aggressivity of the account.
var aggressivity: float:
	get = get_aggressivity


var endings: ConfigFile = ConfigFile.new()
var veracity_points: Array[float]
var virality_points: Array[float]
var aggressivity_points: Array[float]


func _ready() -> void:
	var err: Error = endings.load("res://data/endings.cfg")
	if err: return


func end_game() -> void: end_reached.emit()
func update_stats() -> void: stats_updated.emit()


func get_ending() -> String:
	if aggressivity > 3.0:
		return endings.get_value("Facho", "text")
	elif virality > 3.0 and veracity < 0.1:
		return endings.get_value("Polémiste", "text")
	elif veracity > 2.0 and aggressivity < 2.0:
		return endings.get_value("Wokiste", "text")
	else:
		return endings.get_value("Centriste", "text")


func get_veracity() -> float:
	return Math.sumf(veracity_points)
	#return avgf(veracity_points)

func get_virality() -> float:
	return Math.sumf(virality_points)
	#return avgf(virality_points)

func get_aggressivity() -> float:
	return Math.sumf(aggressivity_points)
	#return avgf(aggressivity_points)
