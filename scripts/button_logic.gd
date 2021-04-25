extends Object

class_name ButtonLogic


var id : int = -1
var pos : IntVec2
var pressed : bool = false 


func _init(params) -> void:
	self.id = params['id']
	self.pos = params['pos']

func _to_string() -> String:
	return "Id: %s, Pos: %s, Pressed: %s" % [id, pos, pressed]
