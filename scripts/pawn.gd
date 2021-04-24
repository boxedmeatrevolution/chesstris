extends Node2D

const ChessBoard := preload("res://scripts/chessboard.gd")
const QueenTexture := preload("res://sprites/queen.png")

const PLACE_TIME := 0.1

const STATE_PAWN := 0
const STATE_QUEEN := 1

var idx := 0
var state := STATE_PAWN
var ipos := IntVec2.new(0, 0)
var target_pos : Vector2
onready var sprite := $Sprite
onready var board : ChessBoard = get_tree().get_root().find_node("ChessBoard", true, false)

func _ready() -> void:
	self.target_pos = board.get_pos(self.ipos)
	LogicManager.connect("move_enemy", self, "_logic_move")
	LogicManager.connect("enemy_death", self, "_logic_death")
	LogicManager.connect("pawn_promotion", self, "_logic_promotion")

func _process(delta : float) -> void:
	if self.target_pos != self.global_position:
		var delta_pos := self.global_position - self.target_pos
		if delta_pos.length_squared() <= 10:
			self.global_position = self.target_pos
		else:
			self.global_position = self.target_pos + delta_pos * exp(-delta / PLACE_TIME)

func _logic_move(idx : int, old_ipos : IntVec2, ipos : IntVec2) -> void:
	if idx == self.idx:
		self.target_pos = board.get_pos(ipos)

func _logic_death(idx : int, ipos : IntVec2) -> void:
	if idx == self.idx:
		queue_free()

func _logic_promotion(idx : int, ipos : IntVec2) -> void:
	if idx == self.idx:
		self.state = STATE_QUEEN
		sprite.texture = QueenTexture
