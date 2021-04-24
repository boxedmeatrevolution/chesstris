extends Node

const WIDTH : int = 6
const HEIGHT : int = 9
const SPAWN_ROWS : int = 3 # top 3 rows are for spawning pieces

var next_object_id : int = 1

var phase : int = Phases.PLAYER_MOVE
var level : int = 1
var moves : Array = [MoveType.GOOD_PAWN, MoveType.GOOD_PAWN, MoveType.GOOD_PAWN]
var next_move : int = MoveType.GOOD_PAWN
var enemy_ids : Array = [] # list of ids
var player_id : int = 0
var player : PieceLogic = PieceLogic.new({
	'id': player_id,
	'is_player': true,
	'pos': IntVec2.new(1,1),
	'type': MoveType.GOOD_PAWN
})
var pieces = {  # keys are piece ids
	player_id: player
}
var board : Array = [] # 2D array, with piece IDs in occupied spaces, null if empty

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
	var type = moves[slot]
	var legal_player_moves = get_legal_moves(pos, type, true)
	for move in legal_player_moves:
		if move.equals(pos):
			return true
	return false


# Type is a MoveType
# Returns: 
#   array of IntVec2
func get_legal_moves(pos: IntVec2, type: int, is_player: bool) -> Array:
	var moves = []
	if type == MoveType.BAD_PAWN:
		var move = IntVec2.new(pos.x, pos.y - 1)
		if is_on_board_and_empty(move):
			moves.push_back(IntVec2.new(pos.x, pos.y - 1))
		var attacks = [
			IntVec2.new(pos.x-1, pos.y-1), IntVec2.new(pos.x+1, pos.y-1)
		]
		for attack in attacks:
			if is_on_play_area_and_attackable(attack, is_player):
				moves.push_back(move)
	elif type == MoveType.GOOD_PAWN:
		var move = IntVec2.new(pos.x, pos.y + 1)
		if is_on_play_area_and_empty(move):
			moves.push_back(IntVec2.new(pos.x, pos.y + 1))
		var attacks = [
			IntVec2.new(pos.x-1, pos.y+1), IntVec2.new(pos.x+1, pos.y+1)
		]
		for attack in attacks:
			if is_on_play_area_and_attackable(attack, is_player):
				moves.push_back(move)
	elif type == MoveType.KNIGHT:
		var potentialMoves = [
			IntVec2.new(pos.x+1, pos.y+2), IntVec2.new(pos.x+2,pos.y+1),
			IntVec2.new(pos.x-1, pos.y+2), IntVec2.new(pos.x-2,pos.y+1),
			IntVec2.new(pos.x+1, pos.y-2), IntVec2.new(pos.x+2,pos.y-1),
			IntVec2.new(pos.x-1, pos.y-2), IntVec2.new(pos.x-2,pos.y-1),
		]
		for move in potentialMoves:
			if is_on_play_area_and_attackable(move, is_player):
				moves.push_back(move)
	elif type == MoveType.KING:
		var potentialMoves = [
			IntVec2.new(pos.x, pos.y+1), IntVec2.new(pos.x+1, pos.y+1),
			IntVec2.new(pos.x+1, pos.y), IntVec2.new(pos.x+1, pos.y-1),
			IntVec2.new(pos.x, pos.y-1), IntVec2.new(pos.x-1, pos.y-1),
			IntVec2.new(pos.x-1, pos.y), IntVec2.new(pos.x-1, pos.y-1)
		]
		for move in potentialMoves:
			if is_on_play_area_and_attackable(move, is_player):
				moves.push_back(move)
	elif type == MoveType.ROOK || type == MoveType.QUEEN:
		var directions = [
			IntVec2.new(1,0), IntVec2.new(0,1), IntVec2.new(-1,0), IntVec2.new(0,-1)
		]
		for dir in directions:
			var move = IntVec2.new(pos.x, pos.y)
			while true:
				move = move.add(dir)
				if is_on_play_area_and_empty(move):
					moves.push_back(move)
				elif is_on_play_area_and_attackable(move, is_player):
					moves.push_back(move)
					break
				else:
					break
	elif type == MoveType.BISHOP || type == MoveType.QUEEN:
		var directions = [
			IntVec2.new(1,1), IntVec2.new(1,-1), IntVec2.new(-1,1),IntVec2.new(-1,-1)
		]
		for dir in directions:
			var move = IntVec2.new(pos.x, pos.y)
			while true:
				move = move.add(dir)
				if is_on_play_area_and_empty(move):
					moves.push_back(move)
				elif is_on_play_area_and_attackable(move, is_player):
					moves.push_back(move)
					break
				else:
					break
	else:
		print("Called get_legal_moves with invalid type %s" % type)
		get_tree().quit()
	return moves

func is_on_board_and_empty(pos: IntVec2) -> bool:
	return is_on_board(pos) && board[pos.x][pos.y] == null

func is_on_board(pos: IntVec2) -> bool:
	return pos.x >= 0 && pos.y >= 0 && pos.x < WIDTH && pos.y < HEIGHT

func is_on_play_area_and_empty(pos: IntVec2) -> bool: 
	return is_on_play_area(pos) && board[pos.x][pos.y] == null

# if is_player is true, then enemy squares and empty squares are attackable
func is_on_play_area_and_attackable(pos: IntVec2, is_player: bool) -> bool:
	if is_on_play_area(pos):
		if board[pos.x][pos.y] == null:
			return true
		else:
			var attacked_piece_id = board[pos.x][pos.y]
			var attacked_piece = pieces[attacked_piece_id]
			if attacked_piece.is_player != is_player:
				return true
	return false 

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
