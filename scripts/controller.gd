extends Node2D

const ChessBoard := preload("res://scripts/chessboard.gd")
const PawnScene := preload("res://entities/pawn.tscn")
const ElevatorButtonScene := preload("res://entities/elevator_button.tscn")

onready var board : ChessBoard = get_tree().get_root().find_node("ChessBoard", true, false)
onready var pawns := get_tree().get_root().find_node("Pawns", true, false)
onready var buttons := get_tree().get_root().find_node("Buttons", true, false)

const TIME_PER_PHASE := 0.4

var phase_timer := 0.0

func _ready() -> void:
	LogicManager.connect("spawn_enemy", self, "_logic_spawn")
	LogicManager.reset()

func _process(delta : float) -> void:
	if LogicManager.phase == Phases.PRE_GAME: 
		LogicManager.increment_phase()
	elif LogicManager.phase != Phases.PLAYER_MOVE:
		phase_timer += delta
		if phase_timer > TIME_PER_PHASE:
			LogicManager.increment_phase()
			phase_timer = 0.0

func _logic_create_button(idx : int, ipos : IntVec2) -> void:
	var button := ElevatorButtonScene.instance()
	button.index = idx
	button.ipos = ipos
	self.buttons.add_child(button)

func _logic_spawn(idx : int, ipos : IntVec2) -> void:
	var pawn := PawnScene.instance()
	pawn.idx = idx
	pawn.ipos = ipos
	pawn.target_pos = board.get_pos(ipos)
	self.pawns.add_child(pawn)
	#print(pawn.idx, " ", pawn.ipos.x, " ", pawn.ipos.y, " ", pawn.target_pos.x, " ", pawn.target_pos.y)
	
