extends Node2D

const ChessBoard := preload("res://scripts/chessboard.gd")
const PawnScene := preload("res://entities/pawn.tscn")
onready var board : ChessBoard = get_tree().get_root().find_node("ChessBoard", true, false)

func _ready() -> void:
	LogicManager.connect("spawn_enemy", self, "_logic_spawn")

func _process(delta : float) -> void:
	pass

func _logic_spawn(idx : int, ipos : IntVec2) -> void:
	var pawn := PawnScene.instance()
	pawn.idx = idx
	pawn.ipos = ipos
	pawn.target_pos = board.get_pos(ipos)
