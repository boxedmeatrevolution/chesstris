extends Node2D

onready var needle_sprite := $NeedleSprite

const ANGLES := [174, 220, 269, -44, 6]

func _ready() -> void:
	self.set_floor(0)
	LogicManager.connect("on_level_up", self, "_on_level_up")

func set_floor(floor_idx : int) -> void:
	floor_idx = min(floor_idx, ANGLES.size() - 1)
	self.needle_sprite.rotation_degrees = ANGLES[floor_idx]

func _on_level_up(floor_idx : int) -> void:
	self.set_floor(floor_idx)
