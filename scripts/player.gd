extends Node2D

const ChessBoard := preload("res://scripts/chessboard.gd")
const BoardButtonScene := preload("res://entities/board_button.tscn")
const BonusFlashScene := preload("res://entities/bonus_flash.tscn")

const PLACE_TIME := 0.1

const STATE_WAIT := 0
const STATE_SELECT_MOVE_INDEX := 1
const STATE_SELECT_MOVE_TARGET := 2
const STATE_MAKE_MOVE := 3

signal start_select_move_index()
signal start_select_move_target(move_idx)
signal finish_select_move(move_idx, move_target)

const bonus_sound := preload("res://sounds/bonus_move2.wav")
const combo_sound := preload("res://sounds/combo.wav")

var target_pos : Vector2
var state := STATE_WAIT
var selected_move_index := 0
var move_index := 0
var move_ipos := IntVec2.new(0, 0)
onready var board : ChessBoard = get_tree().get_root().find_node("ChessBoard", true, false)
onready var board_buttons := get_tree().get_root().find_node("BoardButtons", true, false)
onready var move_target_click_stream := $MoveTargetClickStream
onready var effects := get_tree().get_root().find_node("Effects", true, false)
onready var combo_stream := $ComboStream
onready var hurt_stream := $HurtStream

func _ready() -> void:
	self.target_pos = board.get_pos(LogicManager.player.pos)
	self.position = self.target_pos
	LogicManager.connect("phase_change", self, "_phase_change")
	LogicManager.connect("on_damage", self, "_on_damage")
	LogicManager.connect("on_death", self, "_on_death")
	LogicManager.connect("on_combo", self, "_on_combo")

func _on_death() -> void:
	pass#self.visible = false

func _on_kill() -> void:
	self.visible = false

func _on_damage(id, pos, life_remaining) -> void:
	self.hurt_stream.play()

func _on_combo(ipos : IntVec2, count : int) -> void:
	if count == 1:
		self.combo_stream.stream = bonus_sound
	else:
		self.combo_stream.stream = combo_sound
	var bonus : Node2D = BonusFlashScene.instance()
	bonus.position = self.position
	self.combo_stream.play()
	self.effects.add_child(bonus)

func _phase_change(new_phase : int) -> void:
	if new_phase == Phases.PLAYER_MOVE:
		self.state = STATE_SELECT_MOVE_INDEX
		self.emit_signal("start_select_move_index")

func _process(delta: float) -> void:
	if self.state == STATE_WAIT:
		pass
	elif self.state == STATE_MAKE_MOVE:
		if self.target_pos != self.position:
			var delta_pos := self.position - self.target_pos
			if delta_pos.length_squared() <= 10:
				self.position = self.target_pos
			else:
				self.position = self.target_pos + delta_pos * exp(-delta / PLACE_TIME)
		else:
			if not LogicManager.try_player_move(move_index, move_ipos):
				print("Somehow inputted an invalid move")
				get_tree().quit()
			self.state = STATE_WAIT

func _input(event : InputEvent) -> void:
	if event is InputEventMouseButton && event.pressed && event.button_index == BUTTON_RIGHT:
		if self.state == STATE_SELECT_MOVE_TARGET:
			self.undo_select_move_index()

func select_move_index(index : int) -> void:
	self.move_index = index
	# Create board buttons.
	var move : int = LogicManager.moves[self.move_index]
	var legal_moves := LogicManager.get_legal_moves(LogicManager.player.pos, move, true)
	for legal_move in legal_moves:
		var board_button := BoardButtonScene.instance()
		board_button.ipos = legal_move
		board_button.parent = self
		board_buttons.add_child(board_button)
	self.state = STATE_SELECT_MOVE_TARGET
	emit_signal("start_select_move_target", index)

func undo_select_move_index() -> void:
	self.state = STATE_SELECT_MOVE_INDEX
	emit_signal("start_select_move_index")

func select_move_target(ipos : IntVec2) -> void:
	self.move_ipos = ipos
	self.target_pos = self.board.get_pos(self.move_ipos)
	self.state = STATE_MAKE_MOVE
	emit_signal("finish_select_move", move_index, move_ipos)
