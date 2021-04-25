extends Node2D

onready var sprite := $Sprite

func _convert_move_sprite_index(idx : int) -> int:
	if idx == MoveType.GOOD_PAWN:
		return 0
	elif idx == MoveType.KNIGHT:
		return 1
	elif idx == MoveType.BISHOP:
		return 2
	elif idx == MoveType.ROOK:
		return 3
	elif idx == MoveType.QUEEN:
		return 4
	elif idx == MoveType.KING:
		return 5
	else:
		print("Invalid move index")
		get_tree().quit()
		return 0

func _ready() -> void:
	self.sprite.frame = _convert_move_sprite_index(LogicManager.next_move)
	LogicManager.connect("move_draw", self, "_move_draw")

func _move_draw(move : int, slot : int, next_move : int) -> void:
	self.sprite.frame = _convert_move_sprite_index(next_move)
