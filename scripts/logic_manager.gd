extends Node

const WIDTH : int = 6
const HEIGHT : int = 6

var next_object_id : int = 1

var level : int = 1
var moves = {
	'first': MoveType.PAWN,
	'second': MoveType.PAWN,
	'third': MoveType.PAWN
}
var next_move = MoveType.PAWN
var enemy_ids = [] # list of ids
var player_id :int = 0
var player = PieceLogic.new({
	'id': player_id,
	'is_player': true,
	'pos': IntVec2.new(1,1),
	'type': MoveType.PAWN
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
