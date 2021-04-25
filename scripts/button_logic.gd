extends Object

class_name ButtonLogic


var id : int = -1
var pos : IntVec2
var pressed : bool = false 


func _init(params) -> void:
	self.id = params['id']
	self.pos = params['pos']
