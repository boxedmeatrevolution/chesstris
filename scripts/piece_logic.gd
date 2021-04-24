extends Object

class_name PieceLogic


var id : int = -1
var pos : IntVec2
var type = MoveType.GOOD_PAWN
var is_player : bool = false


func _init(params) -> void:
	self.id = params['id']
	self.pos = params['pos']
	self.type = params['type']
	self.is_player = params['is_player']
