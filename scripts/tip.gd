extends Node2D

func _ready():
	if LogicManager.level <= 1 || DialogueManager.seen_tip:
		queue_free()
	else:
		DialogueManager.seen_tip = true

func _input(event : InputEvent) -> void:
	get_tree().set_input_as_handled()
	if event is InputEventMouseButton && event.pressed && event.button_index == BUTTON_LEFT:
		queue_free()
