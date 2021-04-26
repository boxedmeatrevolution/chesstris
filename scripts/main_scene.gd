extends Camera2D


var decay = 2  # How quickly the shaking stops
var max_offset = Vector2(100, 75)  # Maximum hor/ver shake in pixels.
var max_roll = 0.1  # Maximum rotation in radians (use sparingly).
var trauma = 0.0  # Current shake strength.


# Called when the node enters the scene tree for the first time.
func _ready():
	LogicManager.connect("enemy_death", self, "_enemy_death")
	LogicManager.connect("on_combo", self, "_on_combo")
	LogicManager.connect("on_button_press", self, "_on_button_press")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	trauma = min(trauma, 0.8)
	trauma = max(trauma - decay * delta, 0)
	if trauma > 0:
		shake()

func shake():
	var amount = trauma * trauma
	rotation = max_roll * amount * rand_range(-1, 1)
	offset.x = max_offset.x * amount * rand_range(-1, 1)
	offset.y = max_offset.y * amount * rand_range(-1, 1)
	
func _enemy_death(idx : int, ipos : IntVec2) -> void:
	if LogicManager.should_level_up():
		return
	trauma += 0.0 # screen shake doesn't really work with the sound effect

func _on_button_press(idx : int) -> void:
	trauma += 0.3

func _on_combo(ipos : IntVec2, count : int) -> void:
	trauma += 0.1 + count * 0.2
