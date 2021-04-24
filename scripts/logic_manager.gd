extends Node

const WIDTH : int = 6
const HEIGHT : int = 9
const SPAWN_ROWS : int = 3 # top 3 rows are for spawning pieces

var next_object_id : int = 1

var phase : int = Phases.PLAYER_MOVE
var level : int = 1
var moves = {
	'first': MoveType.GOOD_PAWN,
	'second': MoveType.GOOD_PAWN,
	'third': MoveType.GOOD_PAWN
}
var next_move = MoveType.PAWN
var enemy_ids = [] # list of ids
var player_id :int = 0
var player = PieceLogic.new({
	'id': player_id,
	'is_player': true,
	'pos': IntVec2.new(1,1),
	'type': MoveType.GOOD_PAWN
})
var pieces = {  # keys are piece ids
	player_id: player
} 
var board = [] # 2D array, with piece IDs in occupied spaces, null if empty


signal spawn_enemy(id, pos) # int and IntVec2
signal move_enemy(id, new_pos) # int and IntVec2
signal enemy_death(id, old_pos) # int and IntVec2
signal pawn_promotion(id, pos) # int and IntVec2
signal move_draw(type, slot) # MoveType and int
signal phase_change(new_phase) # Phases

# Called when the node enters the scene tree for the first time.
func _ready():
	# Init the board
	for x in range(0, WIDTH):
		var column = []
		for y in range(0, HEIGHT):
			column.push_back(null)
		board.push_back(column)
	# Add player to board
	board[player.pos.x][player.pos.y] = player_id
	
	
func get_next_id():
	var next = next_object_id
	next_object_id = next_object_id + 1
	return next
	

func increment_phase():
	pass	


# Increments the phase if the move is legal
func try_player_move(slot: int, pos: IntVec2) -> bool:
	return false

# Type is a MoveType
# Returns: 
#   array of IntVec2
func get_legal_moves(pos: IntVec2, type: int) -> Array:
	var moves = []
	if (type == MoveType.BAD_PAWN):
		var move = IntVec2.new(pos.x, pos.y - 1)
		if (is_on_board_and_empty(move)):
			moves.push_back(IntVec2.new(pos.x, pos.y - 1))
	elif (type == MoveType.GOOD_PAWN):
		var move = IntVec2.new(pos.x, pos.y + 1)
		if (is_on_play_area_and_empty(move)):
			moves.push_back(IntVec2.new(pos.x, pos.y + 1))
	return moves

func is_on_board_and_empty(pos: IntVec2) -> bool:
	return is_on_board(pos) && board[pos.x][pos.y] == null

func is_on_board(pos: IntVec2) -> bool:
	return pos.x >= 0 && pos.y >= 0 && pos.x < WIDTH && pos.y < HEIGHT

func is_on_play_area_and_empty(pos: IntVec2) -> bool: 
	return is_on_play_area(pos) && board[pos.x][pos.y] == null

func is_on_play_area(pos: IntVec2) -> bool: 
	return pos.x >= 0 && pos.y >= 0 && pos.x < WIDTH && pos.y < HEIGHT - SPAWN_ROWS

# Adds a piece to the board at the given location.
# Requires: the pos is not occupied
# Inputs:
#   IntVec2 pos    can be anywhere on or above the board
#   MoveType type  
# Returns:
#	String         the piece ID
func add_enemy_piece(pos: IntVec2, type: int):
	#enemyPieces.push_back()
	var id = get_next_id()
	emit_signal("spawn_enemy", id, pos)
	pass

func move_enemy_pieces():
	# First queens move
	
	# Then pawns
	pass # Each piece wants to move somewhere, need to handle conflicts
