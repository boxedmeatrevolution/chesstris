extends Node2D

onready var label := $Label

func _ready() -> void:
	self.label.text = "Death count: %s" % (LogicManager.death_count)
