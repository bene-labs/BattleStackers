extends StaticBody2D

export var points = 1

export var touched_color = Color.gray
var base_color : Color
var touching_pieces = []

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = str(points)
	base_color = modulate

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_PointArea_body_entered(body):
	if not body in touching_pieces and body.has_method("_on_pin_touched"):
		touching_pieces.append(body)
		body._on_pin_touched(self)
		modulate = touched_color
		$AudioStreamPlayer2D.pitch_scale = 1 * rand_range(0.4, 1.6)
		$AudioStreamPlayer2D.play()

func _on_PointArea_body_exited(body):
	if body in touching_pieces and body.has_method("_on_pin_lost"):
		touching_pieces.erase(body)
		body._on_pin_lost(self)
		if touching_pieces.size() == 0:
			modulate = base_color
