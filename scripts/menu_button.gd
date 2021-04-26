extends Node2D

onready var sprite := $Sprite
export var scene_to := ""

func _area_input(v : Node2D, e : InputEvent, idx : int) -> void:
	if e is InputEventMouseButton && e.pressed && e.button_index == BUTTON_LEFT:
		get_tree().change_scene(self.scene_to)

func _mouse_enter() -> void:
	self.sprite.frame = 0

func _mouse_leave() -> void:
	self.sprite.frame = 1
