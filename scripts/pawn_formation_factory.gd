extends Object

class_name PawnFormationFactory


const EMPTY = [[]]
const SINGLE = [[1]]
const H_PAIR = [[1,1]]
const D_PAIR1 = [[1,0],[0,1]]
const D_PAIR2 = [[0,1],[1,0]]
const V = [[1,0,1],[0,1,0]]
const EYES = [[1,0,0,0,0,1]]
const INVERT_V = [[0,1,0],[1,0,1]]
const UHOH = [[0,1,0,1,0,1],[1,0,1,0,1,0]]



func _init() -> void:
	pass

func get_formation(level: int, turn: int) -> Array:
	return []

