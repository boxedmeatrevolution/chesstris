extends Node2D

const ChessBoard := preload("res://scripts/chessboard.gd")
const PawnScene := preload("res://entities/pawn.tscn")
const ElevatorButtonScene := preload("res://entities/elevator_button.tscn")

onready var board : ChessBoard = get_tree().get_root().find_node("ChessBoard", true, false)
onready var hellevator = get_tree().get_root().find_node("Hellevator", true, false)
onready var pawns := get_tree().get_root().find_node("Pawns", true, false)
onready var buttons := get_tree().get_root().find_node("Buttons", true, false)

const TIME_PER_PHASE := 0.1
const GAME_OVER_TIME := 2.0
const YOU_WIN_TIME := 2.0

var phase_timer := 0.0
var finishing_level := false
var losing := false
var winning := false

func _ready() -> void:
	LogicManager.connect("spawn_enemy", self, "_logic_spawn")
	LogicManager.connect("on_button_create", self, "_logic_create_button")
	LogicManager.connect("on_level_up", self, "_logic_level_up")
	LogicManager.reset()

func _logic_level_up(level : int) -> void:
	hellevator._open_door()
	self.finishing_level = true

func _process(delta : float) -> void:
	if !DialogueManager.in_dialogue && losing:
		get_tree().change_scene("res://levels/gameover.tscn")
	elif !DialogueManager.in_dialogue && winning:
		get_tree().change_scene("res://levels/youwin.tscn")
	elif self.finishing_level:
		if hellevator.state == hellevator.STATE_WAIT:
			self.finishing_level = false
			if !DialogueManager.said_level_dialogue[LogicManager.level]:
				DialogueManager.said_level_dialogue[LogicManager.level] = true
				DialogueManager.say_dialogue(DialogueManager.level_dialgoue[LogicManager.level], LogicManager.level >= 5)
	elif LogicManager.phase == Phases.PRE_GAME:
		LogicManager.increment_phase()
	elif LogicManager.phase == Phases.GAME_OVER:
		phase_timer += delta
		if phase_timer > GAME_OVER_TIME && !losing:
			losing = true
			DialogueManager.say_dialogue(["Loser!"])
	elif LogicManager.phase == Phases.YOU_WIN:
		phase_timer += delta
		if phase_timer > YOU_WIN_TIME && !winning:
			winning = true
			if !DialogueManager.said_level_dialogue[6]:
				DialogueManager.said_level_dialogue[6] = true
				DialogueManager.say_dialogue(DialogueManager.level_dialgoue[6], true)
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
