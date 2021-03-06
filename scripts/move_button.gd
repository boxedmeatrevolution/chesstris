extends Node2D

const Player := preload("res://scripts/player.gd")

export var index := 0
var disabled := false
var active := false
onready var player : Player = get_tree().get_root().find_node("Player", true, false)
onready var move_sprite := $MoveSprite
onready var outline_sprite := $OutlineSprite
onready var click_stream := $ClickStream

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
	LogicManager.connect("on_damage", self, "_on_damage")
	LogicManager.connect("on_life_up", self, "_on_life_up")

func _move_draw(type : int, slot : int, next_move : int) -> void:
	if not self.disabled:
		if self.index == slot:
			self.move_sprite.frame = _convert_move_sprite_index(LogicManager.moves[self.index])
		self.outline_sprite.frame = 0

func _on_click(obj : Node, event : InputEvent, idx : int) -> void:
	if event is InputEventMouseButton && event.pressed && event.button_index == BUTTON_LEFT:
		if not disabled && self.active:
			player.select_move_index(self.index)
			self.click_stream.play()
		elif player.state == player.STATE_SELECT_MOVE_TARGET:
			player.undo_select_move_index()
			player.select_move_index(self.index)
			self.click_stream.play()

func _on_mouse_enter() -> void:
	if not self.disabled && self.active:
		self.outline_sprite.frame = 1

func _on_mouse_leave() -> void:
	if not self.disabled && self.active:
		self.outline_sprite.frame = 0

func _start_select_move_index() -> void:
	if not self.disabled:
		self.active = true
		self.outline_sprite.frame = 0

func _start_select_move_target(move_index : int) -> void:
	if not self.disabled:
		if self.index == move_index:
			self.outline_sprite.frame = 1
		self.active = false

func _on_damage(id, ipos, lives) -> void:
	if lives <= self.index:
		self.disabled = true
		self.active = false
		self.move_sprite.frame = 6
		
func _on_life_up(lives) -> void:
	if lives > self.index:
		self.disabled = false
		self.active = true
		self.move_sprite.frame = _convert_move_sprite_index(LogicManager.moves[self.index])
