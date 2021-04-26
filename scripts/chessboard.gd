extends Node2D

const TILE_WIDTH := 96
const TILE_HEIGHT := 96
const NUM_WIDTH := 6
const NUM_HEIGHT := 7


func get_pos(ipos : IntVec2) -> Vector2:
	if ipos.x < 0 || ipos.x >= NUM_WIDTH || ipos.y < 0 || ipos.y >= NUM_HEIGHT:
		return Vector2(NAN, NAN)
	var origin := position
	var x := (ipos.x + 0.5) * TILE_WIDTH + origin.x
	var y := ((NUM_HEIGHT - ipos.y - 1) + 0.5) * TILE_HEIGHT + origin.y
	return Vector2(x, y)

func get_ipos(pos : Vector2) -> IntVec2:
	var origin := position
	var ix := int(floor((pos.x - origin.x) / TILE_WIDTH))
	var iy := NUM_HEIGHT - int(floor((pos.y - origin.y) / TILE_HEIGHT)) - 1
	if ix < 0 || ix >= NUM_WIDTH || iy < 0 || iy >= NUM_HEIGHT:
		return IntVec2.new(-128, -128)
	else:
		return IntVec2.new(ix, iy)
