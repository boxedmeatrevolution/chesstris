extends Node2D

const ChessBoard := preload("res://scripts/chessboard.gd")

var ipos := IntVec2.new(0, 0)
var parent : Node = null
var death_timer := 0.0
onready var board : ChessBoard = get_tree().get_root().find_node("ChessBoard", true, false)
onready var outline_sprite := $Sprite

func _ready() -> void:
	self.global_position = self.board.get_pos(self.ipos)
	self.parent.connect("start_select_move_index", self, "_start_select_move_index")
	self.parent.connect("start_select_move_target", self, "_start_select_move_target")
	self.parent.connect("finish_select_move", self, "_finish_select_move")

func _process(delta : float) -> void:
	if death_timer != 0.0:
		death_timer -= delta
		if death_timer <= 0.0:
			queue_free()

func _on_click(obj : Node, event : InputEvent, idx : int) -> void:
	if event is InputEventMouseButton && event.pressed:
		self.parent.select_move_target(self.ipos)

func _on_mouse_enter() -> void:
	self.outline_sprite.frame = 1

func _on_mouse_leave() -> void:
	self.outline_sprite.frame = 0

func _start_select_move_index() -> void:
	queue_free()

func _start_select_move_target() -> void:
	pass

func _finish_select_move(index : int, target : IntVec2) -> void:
	if self.ipos.equals(target):
		death_timer = 0.1
		outline_sprite.frame = 2
	else:
		queue_free()
