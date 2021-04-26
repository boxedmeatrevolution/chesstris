extends Node2D

const LIFE = 0.6
var timer := 0.0
onready var sprite := $Sprite
const BonusStarScene := preload("res://entities/bonus_star.tscn")

func _ready() -> void:
	self.sprite.rotation_degrees = 30*(randf() - 0.5)
	for i in range(0, 6):
		var bonus_star : Node2D = BonusStarScene.instance()
		self.get_parent().add_child(bonus_star)
		bonus_star.position = self.position + 40 * Vector2(randf() - 0.5, randf() - 0.5)

func _process(delta : float) -> void:
	self.sprite.rotation_degrees -= 10 * delta
	timer += delta
	if timer > LIFE:
		queue_free()
	else:
		self.sprite.modulate.a = 1.0 - tanh(timer / LIFE)
