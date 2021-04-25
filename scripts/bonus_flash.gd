extends Node2D

const LIFE = 0.25
var timer := 0.0
onready var sprite := $Sprite

func _ready() -> void:
	self.sprite.rotation_degrees = randf() * 360

func _process(delta : float) -> void:
	self.sprite.rotation_degrees += 180 * delta
	timer += delta
	if timer > LIFE:
		queue_free()
	else:
		self.sprite.modulate.a = 1.0 - timer / LIFE
