extends Node2D

onready var needle_sprite := $NeedleSprite

const ANGLES := [174, 220, 269, -44, 6]
var broken := false
var state := 0
var velocity := 0.0
var timer := 0.0

func _ready() -> void:
	self.set_floor(LogicManager.level)
	LogicManager.connect("on_level_up", self, "_on_level_up")

func _process(delta : float) -> void:
	if self.broken:
		if state == 0:
			timer += delta
			self.needle_sprite.rotation_degrees = ANGLES[4] + 10 * timer * (randf() - 0.5)
			if timer > 2.5:
				state = 1
				velocity = 140
		elif state == 1:
			velocity += 100 * delta * randf()
			velocity = clamp(velocity, 80, 250)
			self.needle_sprite.rotation_degrees += velocity * delta

func set_floor(floor_idx : int) -> void:
	if floor_idx == 5:
		self.broken = true
	else:
		floor_idx = min(floor_idx, ANGLES.size() - 1)
		self.needle_sprite.rotation_degrees = ANGLES[floor_idx]

func _on_level_up(floor_idx : int) -> void:
	self.set_floor(floor_idx)
