extends Node

const WIDTH : int = 6
const HEIGHT : int = 12
const SPAWN_ROWS : int = 6 # top 6 rows are for spawning pieces
const MAX_LEVEL : int = 4
const COMBO_ON_CAPTURE : bool = false # player gets to move again after a capture
const COMBO_ON_BUTTON : bool = false # player gets to move again after a button press
const COMBO_ON_BUTTON_AND_CAPTURE : bool = true # move again when a piece and button are captured on the same move
var in_corners = [IntVec2.new(1,1), IntVec2.new(1,4), IntVec2.new(4,1), IntVec2.new(4,4)]
var corners = [IntVec2.new(0,0), IntVec2.new(0,5), IntVec2.new(5,0), IntVec2.new(5,5)]
var offset_corners = [IntVec2.new(0,1), IntVec2.new(1,5), IntVec2.new(5,4), IntVec2.new(4,0)]
var offset_corners2 = [IntVec2.new(1,0), IntVec2.new(5,1), IntVec2.new(4,5), IntVec2.new(0,4)]
var one_butt = [IntVec2.new(0,1)]
var full_butt = [
	IntVec2.new(0,0), IntVec2.new(0,1), IntVec2.new(0,2), IntVec2.new(0,3), IntVec2.new(0,4), IntVec2.new(0,5),
	IntVec2.new(1,0), IntVec2.new(1,1), IntVec2.new(1,2), IntVec2.new(1,3), IntVec2.new(1,4), IntVec2.new(1,5),
	IntVec2.new(2,0), IntVec2.new(2,1), IntVec2.new(2,2), IntVec2.new(2,3), IntVec2.new(2,4), IntVec2.new(2,5),
	IntVec2.new(3,0), IntVec2.new(3,1), IntVec2.new(3,2), IntVec2.new(3,3), IntVec2.new(3,4), IntVec2.new(3,5),
	IntVec2.new(4,0), IntVec2.new(4,1), IntVec2.new(4,2), IntVec2.new(4,3), IntVec2.new(4,4), IntVec2.new(4,5),
	IntVec2.new(5,0), IntVec2.new(5,1), IntVec2.new(5,2), IntVec2.new(5,3), IntVec2.new(5,4), IntVec2.new(5,5),
]
var double_offset = [
	IntVec2.new(0,1), IntVec2.new(1,5), IntVec2.new(5,4), IntVec2.new(4,0),
	IntVec2.new(2,1), IntVec2.new(4,2), IntVec2.new(3,4), IntVec2.new(1,3)
]
var double_offset_2 = [
	IntVec2.new(1,0), IntVec2.new(5,1), IntVec2.new(4,5), IntVec2.new(0,4),
	IntVec2.new(1,2), IntVec2.new(2,4), IntVec2.new(4,3), IntVec2.new(3,1)
]
var lvl1 = [
	IntVec2.new(0,2), IntVec2.new(0,3), IntVec2.new(2,0), IntVec2.new(3,0),
	IntVec2.new(2,5), IntVec2.new(3,5), IntVec2.new(5,2), IntVec2.new(5,3)
]
var lvl2 = [
	IntVec2.new(0,0), IntVec2.new(5,0), IntVec2.new(5,5), IntVec2.new(0,5),
	IntVec2.new(1,2), IntVec2.new(1,3), IntVec2.new(2,1), IntVec2.new(3,1),
	IntVec2.new(2,4), IntVec2.new(3,4), IntVec2.new(4,2), IntVec2.new(4,3)
]
var lvl3 = [
	IntVec2.new(0,2), IntVec2.new(1,1), IntVec2.new(1,4), IntVec2.new(2,0),
	IntVec2.new(2,3), IntVec2.new(2,5), IntVec2.new(3,0), IntVec2.new(3,3),
	IntVec2.new(3,5), IntVec2.new(4,1), IntVec2.new(4,4), IntVec2.new(5,2)
]
var lvl4 = [
	IntVec2.new(0,1), IntVec2.new(0,4), IntVec2.new(1,0), IntVec2.new(1,2),
	IntVec2.new(1,3), IntVec2.new(1,5), IntVec2.new(2,1), IntVec2.new(2,4),
	IntVec2.new(3,1), IntVec2.new(3,4), IntVec2.new(4,0), IntVec2.new(4,2),
	IntVec2.new(4,3), IntVec2.new(4,5), IntVec2.new(5,1), IntVec2.new(5,4)
]
var lvl5 = [
	IntVec2.new(0,0), IntVec2.new(0,2), IntVec2.new(0,3), IntVec2.new(0,5),
	IntVec2.new(1,1), IntVec2.new(1,4), IntVec2.new(2,0), IntVec2.new(2,2),
	IntVec2.new(2,3), IntVec2.new(2,5), IntVec2.new(3,0), IntVec2.new(3,2),
	IntVec2.new(3,3), IntVec2.new(3,5), IntVec2.new(4,1), IntVec2.new(4,4),
	IntVec2.new(5,0), IntVec2.new(5,2), IntVec2.new(5,3), IntVec2.new(5,5)
]

var button_positions = { # button positions for each level
	0: lvl1,
	1: lvl2,
	2: lvl3,
	3: lvl4,
	4: lvl5
}

var _next_object_id : int

var phase : int
var level : int
var turn : int 
var lives : int
var moves : Array
var next_move : int
var enemy_ids : Array # list of ids
var player_id : int
var player : PieceLogic
var pieces  # dictionary whose keys are piece ids
var board : Array # 2D array, with piece IDs in occupied spaces, null if empty
var formation_factory : PawnFormationFactory
var button_ids : Array
var buttons #dictionary whose keys are button ids
var button_map : Array
var has_been_hit_on_this_turn : bool
var piece_captured_on_this_turn : bool
var button_pressed_on_this_turn : bool
var combo_count : int

signal spawn_enemy(id, pos) # int and IntVec2
signal move_enemy(id, new_pos) # int and IntVec2
signal enemy_death(id, old_pos) # int and IntVec2
signal pawn_promotion(id, pos) # int and IntVec2
signal move_draw(type, slot, new_next_type) # MoveType and int and MoveType
signal phase_change(new_phase) # Phases
signal on_damage(id, pos, life_remaining) # int id of the enemy that attacked, IntVec2 of pos, int
signal on_death() # int if of the enemy that attacked, IntVec2 of pos
signal on_level_up(new_level) # int
signal on_button_press(id) # int id of the button
signal on_button_create(id, pos) # int id of the new button, IntVec2 of its position
signal on_life_up(life_remaining) # int the new number of lives
signal on_combo(pos, count) # the count is an int of the number of combos so far 

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

# Completely reset EVERYTHING
func reset():
	# Variables
	_next_object_id = 1
	if phase != Phases.GAME_OVER: # If it was a game over, then we do not reset the level
		level = 4
	phase = Phases.PRE_GAME
	turn  = 0
	moves = [MoveType.GOOD_PAWN, MoveType.GOOD_PAWN, MoveType.GOOD_PAWN]
	next_move = MoveType.GOOD_PAWN
	lives = moves.size()
	enemy_ids = [] # list of ids
	player_id = 0
	combo_count = 0
	player = PieceLogic.new({
		'id': player_id,
		'is_player': true,
		'pos': IntVec2.new(2,2),
		'type': MoveType.GOOD_PAWN
	})
	pieces = {  # keys are piece ids
		player_id: player
	}
	has_been_hit_on_this_turn = false
	piece_captured_on_this_turn = false
	button_pressed_on_this_turn = false
	board = [] # 2D array, with piece IDs in occupied spaces, null if empty
	formation_factory = PawnFormationFactory.new(HEIGHT - SPAWN_ROWS - 1, WIDTH)
	init_buttons()
	
	# Init the moves
	var starting_moves = [
		MoveType.KING,
		MoveType.QUEEN,
		MoveType.BISHOP,
		MoveType.ROOK,
		MoveType.KNIGHT
	]
	for i in range(0, moves.size()):
		var move_idx = randi() % starting_moves.size()
		moves[i] = starting_moves[move_idx]
		starting_moves.remove(move_idx)
	next_move = starting_moves[randi() % starting_moves.size()]
	# Init the board
	for x in range(0, WIDTH):
		var column = []
		for y in range(0, HEIGHT):
			column.push_back(null)
		board.push_back(column)
	# Add player to board
	board[player.pos.x][player.pos.y] = player_id

# Returns unique ids for pieces 
func get_next_id():
	var next = _next_object_id
	_next_object_id = _next_object_id + 1
	return next

func increment_phase():
	if phase == Phases.GAME_OVER || phase == Phases.YOU_WIN:
		print("The phase is %s" % Phases.string(phase))
		return
	
	if phase == Phases.PRE_GAME:
		phase = Phases.PLAYER_MOVE
	elif phase == Phases.PLAYER_MOVE:
		if should_level_up():
			combo_count = 0
			if level >= MAX_LEVEL:
				kill_all_enemies()
				phase = Phases.YOU_WIN
			else:
				kill_all_enemies()
				level_up()
		elif (COMBO_ON_CAPTURE && piece_captured_on_this_turn)\
		|| (COMBO_ON_BUTTON && button_pressed_on_this_turn)\
		|| (COMBO_ON_BUTTON_AND_CAPTURE && button_pressed_on_this_turn && piece_captured_on_this_turn):
			combo_count = combo_count + 1
			emit_signal("on_combo", player.pos, combo_count)
			print("COMBO %s" % combo_count)
			phase = Phases.PLAYER_MOVE
		else:
			combo_count = 0
			phase = Phases.QUEEN_MOVE
	elif phase == Phases.QUEEN_MOVE:
		phase = Phases.PAWN_MOVE
	elif phase == Phases.PAWN_MOVE:
		phase = Phases.SPAWN_ENEMY
	elif phase == Phases.SPAWN_ENEMY:
		phase = Phases.PLAYER_MOVE
	elif phase == Phases.GAME_OVER:
		phase = Phases.GAME_OVER
	elif phase == Phases.YOU_WIN:
		phase = Phases.YOU_WIN
	emit_signal("phase_change", phase)
	print("The phase is %s" % Phases.string(phase))
	do_phase()

func do_phase():
	if phase == Phases.PLAYER_MOVE:
		has_been_hit_on_this_turn = false
		piece_captured_on_this_turn = false
		button_pressed_on_this_turn = false
	elif phase == Phases.QUEEN_MOVE:
		move_queens()
	elif phase == Phases.PAWN_MOVE:
		move_pawns()
	elif phase == Phases.SPAWN_ENEMY:
		spawn_enemies()
		turn = turn + 1
		print("Turn %s" % turn)

func init_buttons():
	button_map = []
	for x in range(0, WIDTH):
		var col = []
		for y in range(0, HEIGHT - SPAWN_ROWS):
			col.push_back(null)
		button_map.push_back(col)
	button_ids = []
	buttons = {}
	for p in button_positions[level]:
		var id = get_next_id()
		button_ids.push_back(id)
		buttons[id] = ButtonLogic.new({ 'id': id, 'pos': IntVec2.new(p.x, p.y) })
		button_map[p.x][p.y] = id
		print("making a button")
		emit_signal("on_button_create", id, p)

func should_level_up() -> bool:
	for id in button_ids:
		if not buttons[id].pressed:
			return false 
	return true

func level_up():
	level = level +1
	turn = 0
	print("Level %s, Turn %s" % [level, turn])
	emit_signal("on_level_up", level)
	init_buttons()
	if lives < moves.size():
		lives = lives + 1
		emit_signal("on_life_up", lives)

func kill_all_enemies(): 
	var enemy_ids_copy = enemy_ids.duplicate()
	for id in enemy_ids_copy:
		print(pieces[id])
		kill_enemy_piece(id)

# Increments the phase and moves the player if the move is legal
# Expects:
#   int slot     which slot the player is using to move (corresponds to a piece type)
#   IntVec2 pos  where the player wants to move
# Returns:
#   true if the move succeeded, false otherwise 
func try_player_move(slot: int, pos: IntVec2) -> bool:
	var type = moves[slot]
	var legal_player_moves = get_legal_moves(pos, type, true)
	for legal_move in legal_player_moves:
		if pos.equals(legal_move):
			# Move the player
			board[player.pos.x][player.pos.y] = null
			player.pos.x = pos.x
			player.pos.y = pos.y
			var old_tenant = board[pos.x][pos.y]
			if old_tenant != null:
				# A piece was captured!
				piece_captured_on_this_turn = true
				kill_enemy_piece(old_tenant)
			if button_map[pos.x][pos.y] != null:
				# A button was pressed!
				var button_id = button_map[pos.x][pos.y]
				var button = buttons[button_id]
				if not button.pressed:
					button.pressed = true
					button_pressed_on_this_turn = true
					emit_signal("on_button_press", button_id)
			board[pos.x][pos.y] = player.id
			moves[slot] = next_move
			next_move = get_random_player_move()
			emit_signal("move_draw", moves[slot], slot, next_move)
			increment_phase()
			return true
	return false

# Returns a random MoveType for the player
func get_random_player_move() -> int:
	var bucket = [
		MoveType.GOOD_PAWN, MoveType.QUEEN,
		MoveType.KNIGHT, MoveType.KING,
		MoveType.BISHOP, MoveType.ROOK,
		MoveType.KNIGHT, MoveType.KING,
		MoveType.BISHOP, MoveType.ROOK
	]
	# Repeatedly draw from the bucket until a new move is selected, or 
	# some maximum number of draws is reached
	var counter = 0
	var max_tries = 3
	var move = 0
	while true:
		counter = counter + 1
		move = bucket[randi() % bucket.size()]
		var i = moves.find(move)
		var already_have_it = i >= 0 && i < lives
		if counter >= max_tries || not already_have_it:
			break
	return move

# Deletes an enemy piece from the game
# Expects:
#   int id  is the id of an enemy piece
func kill_enemy_piece(id : int, emit : bool = true):
	var index = enemy_ids.find(id)
	if index != -1:
		enemy_ids.remove(index)
		var pos = pieces[id].pos
		board[pos.x][pos.y] = null
		pieces[id].is_dead = true
		pieces.erase(id)
		if emit:
			emit_signal("enemy_death", id, pos)

# Returns an array of IntVec2, representing all legal moves. 
# Currently, "not moving" is always a legal move
# Expects:
#   IntVec2 pos     where you want to go
#   MoveType type   the type of piece trying to move
#   bool is_player  true if the piece is the player piece
# Returns: 
#   array of IntVec2
func get_legal_moves(pos: IntVec2, type: int, is_player: bool) -> Array:
	var moves = [IntVec2.new(pos.x, pos.y)]  #staying still is always legal?
	if type == MoveType.BAD_PAWN:
		var move = IntVec2.new(pos.x, pos.y - 1)
		if is_on_board_and_empty(move):
			moves.push_back(IntVec2.new(pos.x, pos.y - 1))
		var attacks = [
			IntVec2.new(pos.x-1, pos.y-1), IntVec2.new(pos.x+1, pos.y-1)
		]
		for attack in attacks:
			if is_on_play_area_and_attackable(attack, is_player) && not is_on_play_area_and_empty(attack):
				moves.push_back(attack)
	if type == MoveType.GOOD_PAWN:
		var move = IntVec2.new(pos.x, pos.y + 1)
		if is_on_play_area_and_empty(move):
			moves.push_back(IntVec2.new(pos.x, pos.y + 1))
		var attacks = [
			IntVec2.new(pos.x-1, pos.y+1), IntVec2.new(pos.x+1, pos.y+1)
		]
		for attack in attacks:
			if is_on_play_area_and_attackable(attack, is_player) && not is_on_play_area_and_empty(attack):
				moves.push_back(attack)
	if type == MoveType.KNIGHT:
		var potentialMoves = [
			IntVec2.new(pos.x+1, pos.y+2), IntVec2.new(pos.x+2,pos.y+1),
			IntVec2.new(pos.x-1, pos.y+2), IntVec2.new(pos.x-2,pos.y+1),
			IntVec2.new(pos.x+1, pos.y-2), IntVec2.new(pos.x+2,pos.y-1),
			IntVec2.new(pos.x-1, pos.y-2), IntVec2.new(pos.x-2,pos.y-1),
		]
		for move in potentialMoves:
			if is_on_play_area_and_attackable(move, is_player):
				moves.push_back(move)
	if type == MoveType.KING:
		var potentialMoves = [
			IntVec2.new(pos.x, pos.y+1), IntVec2.new(pos.x+1, pos.y+1),
			IntVec2.new(pos.x+1, pos.y), IntVec2.new(pos.x+1, pos.y-1),
			IntVec2.new(pos.x, pos.y-1), IntVec2.new(pos.x-1, pos.y-1),
			IntVec2.new(pos.x-1, pos.y), IntVec2.new(pos.x-1, pos.y+1)
		]
		for move in potentialMoves:
			if is_on_play_area_and_attackable(move, is_player):
				moves.push_back(move)
	if type == MoveType.ROOK || type == MoveType.QUEEN:
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
	if type == MoveType.BISHOP || type == MoveType.QUEEN:
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
		elif is_player || not has_been_hit_on_this_turn: # ensures that player can only be damaged once per turn
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
#   IntVec2 pos    can be anywhere on the board
#   MoveType type  
# Returns:
#	int            the piece ID
func add_enemy_piece(pos: IntVec2, type: int):
	var id = get_next_id()
	enemy_ids.push_back(id)
	pieces[id] = PieceLogic.new({
		'id': id,
		'is_player': false,
		'pos': pos,
		'type': type
	})
	board[pos.x][pos.y] = id
	emit_signal("spawn_enemy", id, pos)

class PieceSorter:
	static func sort_bottom_to_top(a: PieceLogic, b: PieceLogic):
		if a.pos.y < b.pos.y:
			return true
		elif a.pos.y == b.pos.y && a.pos.x < b.pos.x:
			return true
		return false 

func move_queens():
	var queens = []
	for id in enemy_ids:
		var piece = pieces[id]
		if piece.type == MoveType.QUEEN:
			queens.push_back(piece)
	queens.sort_custom(PieceSorter, "sort_bottom_to_top")
	for queen in queens:
		var moves = get_legal_moves(queen.pos, MoveType.QUEEN, false)
		var best_move = moves.pop_back()
		var best_proximity = no_sqrt_dist_to_player(best_move)
		for move in moves:
			if board[move.x][move.y] == player_id:
				best_move = move
				break
			var proximity = no_sqrt_dist_to_player(move)
			if proximity < best_proximity:
				best_move = move
				best_proximity = proximity
		move_enemy(queen, best_move)

func no_sqrt_dist_to_player(pos : IntVec2):
	var dx = player.pos.x - pos.x
	var dy = player.pos.y - pos.y
	return dx * dx + dy * dy

func move_pawns():
	var pawns = []
	for id in enemy_ids:
		var piece = pieces[id]
		if piece.is_player == false && piece.type == MoveType.BAD_PAWN:
			pawns.push_back(piece)
	pawns.sort_custom(PieceSorter, "sort_bottom_to_top")
	for pawn in pawns:
		var moves = get_legal_moves(pawn.pos, MoveType.BAD_PAWN, false)
		var best_move = moves.pop_back()
		for move in moves:
			if board[move.x][move.y] == player_id:
				best_move = move
				break
			elif move.y < best_move.y:
				best_move = move #prefer moving down to staying still
		move_enemy(pawn, best_move)
		if pawn.pos.y == 0 && not pawn.is_dead:
			# Promote that boiiiii!
			pawn.type = MoveType.QUEEN
			emit_signal("pawn_promotion", pawn.id, pawn.pos)

# Requires that the new_pos is a valid move
# Will emit move_enemy, on_damage, on_death signals as needed
func move_enemy(piece: PieceLogic, new_pos: IntVec2):
	var starts_off_board = piece.pos.y > HEIGHT - SPAWN_ROWS
	board[piece.pos.x][piece.pos.y] = null
	var is_capture = new_pos.equals(player.pos)
	if starts_off_board && new_pos.y <= HEIGHT - SPAWN_ROWS:
		piece.pos.x = new_pos.x
		piece.pos.y = new_pos.y
		board[piece.pos.x][piece.pos.y] = piece.id
		emit_signal("spawn_enemy", piece.id, piece.pos)
	if not is_capture:
		piece.pos.x = new_pos.x
		piece.pos.y = new_pos.y
		board[piece.pos.x][piece.pos.y] = piece.id
		emit_signal("move_enemy", piece.id, piece.pos)
	elif lives > 1:
		has_been_hit_on_this_turn = true
		lives = lives - 1
		emit_signal("move_enemy", piece.id, new_pos)
		emit_signal("on_damage", piece.id, new_pos, lives)
		kill_enemy_piece(piece.id, false)
	else:
		emit_signal("move_enemy", piece.id, new_pos)
		has_been_hit_on_this_turn = true		
		lives = 0
		emit_signal("on_damage", piece.id, new_pos, lives)
		emit_signal("on_death")
		phase = Phases.GAME_OVER
		emit_signal("phase_change", phase)

func spawn_enemies():
	var positions = formation_factory.generate(level, turn)
	for pos in positions:
		if (is_on_board_and_empty(pos)):
			var pawn = PieceLogic.new({
				'id': get_next_id(),
				'is_player': false,
				'pos': pos,
				'type': MoveType.BAD_PAWN
			})
			board[pawn.pos.x][pawn.pos.y] = pawn.id
			enemy_ids.push_back(pawn.id)
			pieces[pawn.id] = pawn
			if pos.y <= HEIGHT - SPAWN_ROWS:
				emit_signal("spawn_enemy", pawn.id, pawn.pos) 
