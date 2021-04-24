extends Node2D

const ChessBoard := preload("res://scripts/chessboard.gd")
const BoardButtonScene := preload("res://entities/board_button.tscn")

const PLACE_TIME := 0.1

const STATE_WAIT := 0
const STATE_SELECT_MOVE_INDEX := 1
const STATE_SELECT_MOVE_TARGET := 2
const STATE_MAKE_MOVE := 3

signal start_select_move_index()
signal start_select_move_target(move_idx)
signal finish_select_move(move_idx, move_target)

var target_pos : Vector2
var state := STATE_WAIT
var selected_move_index := 0
var move_index := 0
var move_ipos := IntVec2.new(0, 0)
onready var board : ChessBoard = get_tree().get_root().find_node("ChessBoard", true, false)
onready var board_buttons := get_tree().get_root().find_node("BoardButtons", true, false)

func _ready() -> void:
	self.target_pos = board.get_pos(LogicManager.player.pos)
	self.global_position = self.target_pos

func _process(delta: float) -> void:
	if self.state == STATE_WAIT:
		pass
	elif self.state == STATE_MAKE_MOVE:
		if self.target_pos != self.global_position:
			var delta_pos := self.global_position - self.target_pos
			if delta_pos.length_squared() <= 10:
				if not LogicManager.try_player_move(move_index, move_ipos):
					print("Somehow inputted an invalid move")
					get_tree().quit()
				self.global_position = self.target_pos
				self.state = STATE_WAIT
			else:
				self.global_position = self.target_pos + delta_pos * exp(-delta / PLACE_TIME)

func select_move_index(index : int) -> void:
	self.move_index = index
	# Create board buttons.
	var move : int = LogicManager.moves[self.move_index]
	var legal_moves := LogicManager.get_legal_moves(LogicManager.player.pos, move)
	for legal_move in legal_moves:
		var board_button := BoardButtonScene.instance()
		board_button.ipos = legal_move
		board_button.parent = self
		board_buttons.add_child(board_button)
	emit_signal("start_select_move_target", index)

func select_move_target(ipos : IntVec2) -> void:
	self.move_ipos = ipos
	self.target_pos = self.board.get_pos(self.move_ipos)
	emit_signal("finish_select_move", move_index, move_ipos)
