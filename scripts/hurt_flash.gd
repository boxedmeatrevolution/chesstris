extends Node2D

const LIFE = 0.3
var timer := 0.0
onready var sprite := $Sprite

func _process(delta : float) -> void:
	timer += delta
	if timer > LIFE:
		queue_free()
	else:
		self.sprite.modulate.a = timer / delta
