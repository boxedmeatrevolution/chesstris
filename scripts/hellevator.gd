extends Node2D

onready var hellevator_sprite := $HellevatorDoor

const STATE_WAIT := 0
const STATE_CLOSE := 1
const STATE_WAIT_OPEN := 2
const STATE_OPEN := 3
const HELLEVATOR_DOOR_TIME := 1.2
const HELLEVATOR_DOOR_WAIT_TIME := 1.5
var hellevator_timer := 0.0
var state = STATE_WAIT
onready var arrive_stream := $ElevatorArrivedStream
onready var travel_stream := $ElevatorRideStream

func _process(delta : float) -> void:
	if self.state == STATE_OPEN:
		hellevator_timer += delta
		self.hellevator_sprite.region_rect.position.x = 600 - 600*sin(0.5*PI*(hellevator_timer / HELLEVATOR_DOOR_TIME))
		if hellevator_timer > HELLEVATOR_DOOR_TIME:
			self.hellevator_timer = 0.0
			self.hellevator_sprite.region_rect.position.x = 0
			self.state = STATE_WAIT_OPEN
			self.travel_stream.play()
	elif self.state == STATE_WAIT_OPEN:
		hellevator_timer += delta
		if hellevator_timer > HELLEVATOR_DOOR_WAIT_TIME:
			self.state = STATE_CLOSE
			self.hellevator_timer = 0.0
	elif self.state == STATE_CLOSE:
		hellevator_timer += delta
		self.hellevator_sprite.region_rect.position.x = 600*(1 - cos(0.5*PI*(hellevator_timer / HELLEVATOR_DOOR_TIME)))
		if hellevator_timer > HELLEVATOR_DOOR_TIME:
			self.hellevator_timer = 0.0
			self.hellevator_sprite.region_rect.position.x = 600
			self.state = STATE_WAIT

func _open_door() -> void:
	self.state = STATE_OPEN
	if self.arrive_stream:
		self.arrive_stream.play()
