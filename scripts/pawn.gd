extends Node2D

const ChessBoard := preload("res://scripts/chessboard.gd")
const QueenTexture := preload("res://sprites/queen.png")
const HurtFlashInstance := preload("res://entities/hurt_flash.tscn")

const PLACE_TIME := 0.1

const STATE_PAWN := 0
const STATE_QUEEN := 1

var idx := 0
var hurt := false
var dying := false
var state := STATE_PAWN
var ipos := IntVec2.new(0, 0)
var target_pos : Vector2
onready var sprite := $Sprite
onready var enemy_death_stream := $EnemyDeathStream
onready var board : ChessBoard = get_tree().get_root().find_node("ChessBoard", true, false)
onready var effects : Node2D = get_tree().get_root().find_node("Effects", true, false)

func _ready() -> void:
	self.target_pos = board.get_pos(self.ipos)
	self.global_position = self.target_pos
	LogicManager.connect("move_enemy", self, "_logic_move")
	LogicManager.connect("enemy_death", self, "_logic_death")
	LogicManager.connect("pawn_promotion", self, "_logic_promotion")
	LogicManager.connect("on_damage", self, "_logic_on_damage")

func _process(delta : float) -> void:
	if self.dying:
		self.position += 1000 * self.target_pos * delta
		self.target_pos.y += 2 * delta
		self.rotation_degrees += 360 * delta
		self.scale *= exp(-delta / 3.0)
		if self.position.y > 2000:
			queue_free()
	else:
		if self.target_pos != self.global_position:
			var delta_pos := self.global_position - self.target_pos
			if delta_pos.length_squared() <= 10:
				self.global_position = self.target_pos
				if self.hurt:
					var hurt_flash : Node2D = HurtFlashInstance.instance()
					self.effects.add_child(hurt_flash)
					hurt_flash.global_position = self.global_position
					queue_free()
					
			else:
				self.global_position = self.target_pos + delta_pos * exp(-delta / PLACE_TIME)

func _logic_move(idx : int, ipos : IntVec2) -> void:
	if idx == self.idx:
		self.target_pos = board.get_pos(ipos)

func _logic_death(idx : int, ipos : IntVec2) -> void:
	if idx == self.idx:
		self.dying = true
		var angle = randf() * 2 * PI
		self.target_pos = Vector2(cos(angle), sin(angle))
		self.enemy_death_stream.play()

func _logic_promotion(idx : int, ipos : IntVec2) -> void:
	if idx == self.idx:
		self.state = STATE_QUEEN
		sprite.texture = QueenTexture

func _logic_on_damage(idx : int, ipos : IntVec2, life : int) -> void:
	if idx == self.idx:
		self.target_pos = board.get_pos(ipos)
		self.hurt = true
