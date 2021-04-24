extends Object

class_name IntVec2

var x : int = 0
var y : int = 0

func _init(x_ : int, y_ : int) -> void:
	self.x = x_
	self.y = y_

func _to_string():
	return "(%s, %s)" % [x, y]

func add(other : IntVec2) -> IntVec2:
	return get_script().new(other.x + self.x, other.y + self.y)

func sub(other : IntVec2) -> IntVec2:
	return get_script().new(self.x - other.x, self.y - other.y)

func scale(other : int) -> IntVec2:
	return get_script().new(other * self.x, other * self.y)

func equals(other : IntVec2) -> bool:
	return self.x == other.x && self.y == other.y
