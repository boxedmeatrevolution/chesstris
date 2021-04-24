extends Node2D

# onready var _logic_manager : LogicManager

const ChessBoard := preload("res://scripts/chessboard.gd")

const PLACE_TIME := 0.1

const STATE_WAIT := 0
const STATE_PICKED_UP := 1

var ipos := IntVec2.new(0, 0)
var target_pos : Vector2
var state := STATE_WAIT
onready var board : ChessBoard = get_tree().get_root().find_node("ChessBoard", true, false)

func _ready() -> void:
	self.target_pos = board.get_pos(self.ipos)
	# self.global_position = self.target_pos

func _process(delta: float) -> void:
	if self.state == STATE_WAIT:
		if self.target_pos != self.global_position:
			var delta_pos := self.global_position - self.target_pos
			if delta_pos.length_squared() <= 10:
				self.global_position = self.target_pos
			else:
				self.global_position = self.target_pos + delta_pos * exp(-delta / PLACE_TIME)
	elif self.state == STATE_PICKED_UP:
		self.global_position = self.target_pos

func _on_input_event_area(viewport : Node, event : InputEvent, shape_idx : int) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			if self.state == STATE_WAIT:
				self.state = STATE_PICKED_UP
				self.target_pos = event.position

func _input(event : InputEvent) -> void:
	if event is InputEventMouseMotion:
		if self.state == STATE_PICKED_UP:
			self.target_pos = event.position
	elif event is InputEventMouseButton:
		if !event.pressed:
			if self.state == STATE_PICKED_UP:
				self.state = STATE_WAIT
				var new_ipos := board.get_ipos(event.position)
				if new_ipos.x >= 0:
					self.ipos = new_ipos
				self.target_pos = board.get_pos(self.ipos)
