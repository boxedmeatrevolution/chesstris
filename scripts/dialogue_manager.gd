extends Node

const ElevatorOperatorScene := preload("res://entities/elevator_operator.tscn")

var in_dialogue := false

var said_level_dialogue := [false, false, false, false, false, false, false]
var level_dialgoue := [
	[
		"So you've got a problem with the rules of chess?",
		"You think that pawns like you should be able to move willy-nilly where-ever they please?",
		"Well that's the type of thinking that got you sent here. Hell.",
		"Pawns should move forward, once square at a time.",
		"If another piece is in the way, they get stuck.",
		"And they can only attack diagonally, a maximum of one square!",
		"If you've got a problem with those rules, take it up with the Queen.",
		"Now, Hell-pawns, attack!"
	],
	[
		"You know you're not special. All pieces can break the rules, but the rules are in place for the good of all.",
		"A pawn like you makes up the front line of attack. Your role is to break the enemy's line of defense with your life.",
		"Just like my role is to defend the Queen's private elevator."
	],
	[
		"Perhaps you rebel because you think pawns are weak. Well you couldn't be further from the truth.",
		"Individually, pawns are weak, but in a strong formation, pawns are unstoppable.",
		"Each pawn protects its neighbours for the good of the line."
	],
	[
		"What do you think will happen when this elevator reaches the last floor?",
		"Do you think the Queen will listen to the arguments of a pawn?",
		"The Queen will punish you and me both."
	],
	[
		"How can a lowly pawn defy destiny, while the Queen's most distinguished elevator operator cannot?",
		"Will I be defeated?",
		"No! I know how every chess piece is permitted to move! I know the strengths and weaknesses of every pawn formation!",
		"Hell-pawns, show this renegade the meaning of true pawn power."
	],
	[
		"Why is my chess game being interupted by this elevator operator and his pawn?",
		"Throw the elevator operator into the magma pits.",
		"As for this pawn, I will show it why Queen's have the right to rule."
	],
	["Finally done"]
]

func _ready() -> void:
	LogicManager.connect("on_level_up", self, "_on_level_up")

func say_dialogue(dialogue : Array, queen := false) -> void:
	var operator := ElevatorOperatorScene.instance()
	operator.text = dialogue
	var root : Node = get_tree().get_root()
	root.add_child(operator)
	if queen:
		operator.sprite.frame = 1
	self.in_dialogue = true
	operator.connect("done_talking", self, "_dialogue_over")

func _dialogue_over() -> void:
	self.in_dialogue = false
