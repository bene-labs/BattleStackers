extends StaticBody2D

export var points = 1

export var touched_color = Color.gray
var base_color : Color

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = str(points)
	base_color = modulate

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_PointArea_body_entered(body):
	if body.has_method("_on_pin_touched"):
		body._on_pin_touched(self)
		modulate = touched_color

func _on_PointArea_body_exited(body):
	if body.has_method("_on_pin_lost"):
		body._on_pin_lost(self)
		modulate = base_color
