extends Node2D

const Player := preload("res://scripts/player.gd")

export var index := 0
var active := false
onready var player : Player = get_tree().get_root().find_node("Player", true, false)
onready var move_sprite := $MoveSprite
onready var outline_sprite := $OutlineSprite

func _convert_move_sprite_index(idx : int) -> int:
	if idx == MoveType.GOOD_PAWN:
		return 0
	elif idx == MoveType.KNIGHT:
		return 1
	elif idx == MoveType.BISHOP:
		return 2
	elif idx == MoveType.ROOK:
		return 3
	elif idx == MoveType.QUEEN:
		return 4
	elif idx == MoveType.KING:
		return 5
	else:
		print("Invalid move index")
		get_tree().quit()
		return 0

func _ready() -> void:
	self.move_sprite.frame = _convert_move_sprite_index(LogicManager.moves[self.index])
	player.connect("start_select_move_index", self, "_start_select_move_index")
	player.connect("start_select_move_target", self, "_start_select_move_target")
	player.connect("finish_select_move", self, "_finish_select_move")
	LogicManager.connect("move_draw", self, "_move_draw")

func _move_draw(type : int, slot : int) -> void:
	if self.index == slot:
		self.move_sprite.frame = _convert_move_sprite_index(LogicManager.moves[self.index])

func _on_click(obj : Node, event : InputEvent, idx : int) -> void:
	if self.active:
		player.select_move_index(self.index)

func _on_mouse_enter() -> void:
	if self.active:
		self.outline_sprite.frame = 1

func _on_mouse_leave() -> void:
	if self.active:
		self.outline_sprite.frame = 0

func _start_select_move_index() -> void:
	self.active = true
	self.outline_sprite.frame = 0
	self.outline_sprite.visible = true

func _start_select_move_target(move_index : int) -> void:
	if self.index == move_index:
		self.outline_sprite.frame = 2
	else:
		self.outline_sprite.visible = false
	self.active = false

func _finish_select_move() -> void:
	self.outline_sprite.visible = false
