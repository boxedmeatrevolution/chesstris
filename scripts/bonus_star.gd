extends Node2D

var velocity := Vector2.ZERO
var life := 0.0
const LIFETIME := 1.0

func _ready() -> void:
	self.rotation_degrees = randf() * 360
	self.velocity = 500 * Vector2(randf() - 0.5, randf() - 0.5)

func _process(delta : float) -> void:
	self.position += self.velocity * delta
	self.velocity *= exp(-delta / (0.5 * LIFETIME))
	self.modulate.a *= exp(-delta / (0.5 * LIFETIME))
	self.rotation_degrees += 100 * delta
	life += delta
	if life > LIFETIME:
		queue_free()
