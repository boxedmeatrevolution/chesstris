extends Node2D

export(Array, String) var text := [
	"Blah blah blah I am saying things to test but what gotta make this long for testing purposes!",
	"AM I REALLY TALKING??"
]

const STATE_ARRIVING := 0
const STATE_SCROLLING := 1
const STATE_WAITING := 2
const STATE_LEAVING := 3

const START_Y := 800.0
const END_Y := 200.0
const TRAVEL_TIME := 0.75
const FRAMES_PER_LETTER := 2

var immune := false
var immune_timer := 0.0
var timer := 0.0
var state := STATE_ARRIVING
var index := 0
var frame := 0
onready var label := $SpeechSprite/Label

signal done_talking()

func _ready() -> void:
	self.label.text = ""
	self.position.y = 700

func _input(event : InputEvent) -> void:
	get_tree().set_input_as_handled()
	if !self.immune && event is InputEventMouseButton && event.pressed && event.button_index == BUTTON_LEFT:
		if self.state == STATE_SCROLLING:
			self.label.text = self.text[self.index]
			self.state = STATE_WAITING
			self.timer = 0.0
		elif self.state == STATE_WAITING:
			self.index += 1
			self.label.text = ""
			if self.index >= self.text.size():
				self.state = STATE_LEAVING
			else:
				self.state = STATE_SCROLLING
			self.timer = 0.0

func _process(delta : float) -> void:
	timer += delta
	if self.immune:
		immune_timer -= delta
		if self.immune_timer < 0.0:
			self.immune = false
	if self.state == STATE_ARRIVING:
		self.position.y = START_Y + (END_Y - START_Y) * sin(0.5*PI*(timer/TRAVEL_TIME))
		if timer > TRAVEL_TIME:
			self.timer = 0.0
			self.index = 0
			self.state = STATE_SCROLLING
			self.position.y = END_Y
	elif self.state == STATE_SCROLLING:
		self.frame += 1
		if self.frame == FRAMES_PER_LETTER:
			self.frame = 0
			if self.label.text.length() == self.text[self.index].length():
				self.state = STATE_WAITING
				self.timer = 0.0
				self.immune = true
				self.immune_timer = 0.2
			else:
				self.label.text += self.text[self.index][self.label.text.length()]
	elif self.state == STATE_WAITING:
		pass
	elif self.state == STATE_LEAVING:
		self.position.y = END_Y + (START_Y - END_Y) * (1.0 - cos(0.5*PI*(timer/TRAVEL_TIME)))
		if timer > TRAVEL_TIME:
			emit_signal("done_talking")
			queue_free()
