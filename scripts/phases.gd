extends Reference
class_name Phases

const PLAYER_MOVE = 0
const QUEEN_MOVE = 1
const PAWN_MOVE = 2
const SPAWN_ENEMY = 3
const PRE_GAME = 4
const GAME_OVER = 5
const YOU_WIN = 6

static func string(phase : int) -> String:
	var phases = [
		"PLAYER_MOVE", "QUEEN_MOVE", "PAWN_MOVE", "SPAWN_ENEMY",
		"PRE_GAME", "GAME_OVER", "YOU_WIN"
	]
	if phase < 0 || phase >= phases.size():
		return "Invalid phase value %s" % phase
	return phases[phase]
	
