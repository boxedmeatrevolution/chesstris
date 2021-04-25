extends Node2D

const ChessBoard := preload("res://scripts/chessboard.gd")

var index : int
var ipos := IntVec2.new(0, 0)
onready var board : ChessBoard = get_tree().get_root().find_node("ChessBoard", true, false)
onready var sprite := $Sprite

func _ready() -> void:
	self.global_position = self.board.get_pos(self.ipos)
	LogicManager.connect("on_button_press", self, "_on_button_press")
	LogicManager.connect("on_level_up", self, "_on_level_up")

func _on_button_press(idx : int) -> void:
	if self.idx == index:
		self.sprite.frame = 1

func _on_level_up(floor_idx : int) -> void:
	queue_free()
