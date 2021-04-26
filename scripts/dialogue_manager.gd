extends Node

const ElevatorOperatorScene := preload("res://entities/elevator_operator.tscn")

var in_dialogue := false

func _ready() -> void:
	LogicManager.connect("on_level_up", self, "_on_level_up")

func say_dialogue(dialogue : Array) -> void:
	var operator := ElevatorOperatorScene.instance()
	operator.text = dialogue
	var root : Node = get_tree().get_root()
	root.add_child(operator)
	self.in_dialogue = true
	operator.connect("done_talking", self, "_dialogue_over")

func _dialogue_over() -> void:
	self.in_dialogue = false

func _on_level_up(new_level : int) -> void:
	self.say_dialogue(["Welcome to level %s." % new_level, "This time I'm sure you will finally lose."])
