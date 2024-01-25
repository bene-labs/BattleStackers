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


func recolor_by_touching_pieces():
	var colors_to_use = {}
	if touching_pieces.size() == 0:
		modulate = base_color
		return
	
	for piece in touching_pieces:
		if not "color" in piece: 
			continue
		if piece.color in colors_to_use:
			colors_to_use[piece.color] += 0.25
			continue
		colors_to_use[piece.color] = 0.25
	if colors_to_use.size() == 0:
		modulate = touched_color
		return
	modulate = base_color
	modulate = modulate.linear_interpolate(colors_to_use.keys()[0], colors_to_use.values()[0])
	for i in range(1, colors_to_use.size()):
		modulate = modulate.linear_interpolate(colors_to_use.keys()[i], colors_to_use.values()[i])

func _on_PointArea_body_entered(body):
	if not body in touching_pieces and body.has_method("_on_pin_touched"):
		touching_pieces.append(body)
		body._on_pin_touched(self)
		recolor_by_touching_pieces()
		$AudioStreamPlayer2D.pitch_scale = 1 * rand_range(0.4, 1.6)
		$AudioStreamPlayer2D.play()

func _on_PointArea_body_exited(body):
	if body in touching_pieces and body.has_method("_on_pin_lost"):
		touching_pieces.erase(body)
		body._on_pin_lost(self)
		recolor_by_touching_pieces()
		
