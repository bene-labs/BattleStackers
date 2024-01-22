class_name GamePiece
extends RigidBody2D

signal picked_up(piece)
signal idle
signal dropped


export var idle_requirement = 3.0

var was_placed = false 
var is_follow_mouse = false
var is_hovered = false

var owning_player : Player


func init(player):
	owning_player = player

func _ready():
	mode = RigidBody2D.MODE_STATIC
	


func _physics_process(delta):
	if is_follow_mouse:
		global_transform.origin = get_global_mouse_position()


func _input(event):
	if was_placed:
		return
	if is_hovered and event.is_action_pressed("pickup_piece"):
		emit_signal("picked_up", self)
		
		is_follow_mouse = true
	if is_follow_mouse and event.is_action_released("pickup_piece"):
		drop()

func drop():
	if not is_follow_mouse:
		return
	is_follow_mouse = false
	was_placed = true
	mode = RigidBody2D.MODE_RIGID
	apply_central_impulse(Input.get_last_mouse_speed())
	emit_signal("dropped")

func _on_mouse_entered():
	is_hovered = true


func _on_mouse_exited():
	is_hovered = false


func _on_SquarePiece_input_event(viewport, event, shape_idx):
	if was_placed:
		return
	if event is InputEventMouseButton and event.button_index == 1:
		if event.pressed:
			is_follow_mouse = true


func _on_pin_touched(pin):
	owning_player.gain_points(pin.points)


func _on_pin_lost(pin):
	owning_player.lose_points(pin.points)


func _on_MouseArea_body_entered(body):
	if body.get_class() != get_class() or body == self:
		return
	$HitSound.pitch_scale = rand_range(0.5, 1.5)
	$HitSound.play()
	print("Bonk!")
