extends Node


signal stats_updated


# Stats
## A number between -1 and 1 representing the trustworthyness of the account.
var veracity: float:
	get = get_veracity
## A number between 0 and 1 representing the virality of the account.
var virality: float:
	get = get_virality
## A number between -1 and 1 representing the aggressivity of the account.
var aggressivity: float:
	get = get_aggressivity


var veracity_points: Array[float]
var virality_points: Array[float]
var aggressivity_points: Array[float]


func update_stats() -> void:
	stats_updated.emit()


func get_veracity() -> float:
	return avgf(veracity_points)

func get_virality() -> float:
	return avgf(virality_points)

func get_aggressivity() -> float:
	return avgf(aggressivity_points)


# Get average of float list
func avgf(list: Array[float]) -> float:
	if list.size() == 0:
		return 1.0
	
	var total: float = 0.0
	for i in list:
		total += i
	return total / list.size()
