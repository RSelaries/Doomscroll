class_name Math
extends Object


static func sumf(list: Array[float]) -> float:
	return list.reduce(func(i, accum): return i + accum, 0.0)

static func sumi(list: Array[int]) -> int:
	return list.reduce(func(i, accum): return i + accum, 0)


# Get average of float list
static func avgf(list: Array[float]) -> float:
	if list.size() == 0: return NAN
	
	var total: float = sumf(list)
	return total / list.size()
