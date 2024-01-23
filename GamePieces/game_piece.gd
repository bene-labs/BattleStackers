class_name GamePiece
extends RigidBody2D

signal picked_up(piece)
signal idle
signal dropped


export var idle_requirement = 3.0

var was_placed = false
var is_follow_mouse = false
var is_hovered = false
var is_touched = false
var last_touch_position = Vector2.ZERO
var last_touch_drag_velocity = Vector2.ZERO

var owning_player : Player


func init(player):
	owning_player = player

func _ready():
	mode = RigidBody2D.MODE_STATIC


func _physics_process(delta):
	if is_follow_mouse:
		global_transform.origin = get_global_mouse_position()
	if is_touched:
		global_transform.origin = last_touch_position

func _input(event):
	if was_placed:
		return
	
	# Mobile
	if event is InputEventScreenDrag:
		if not is_touched and Geometry.is_point_in_polygon(to_local(event.position), $MouseArea/CollisionPolygon2D.polygon):
			mode = RigidBody2D.MODE_RIGID
			is_touched = true
			emit_signal("picked_up", self)
		elif not is_touched:
			return
		last_touch_drag_velocity = event.speed
		linear_velocity = Vector2.ZERO
		last_touch_position = event.position
	if is_touched and event is InputEventScreenTouch:
		if not event.pressed:
			drop()
#	# PC
	if is_hovered and event.is_action_pressed("pickup_piece"):
		emit_signal("picked_up", self)
		is_follow_mouse = true
		mode = RigidBody2D.MODE_RIGID
	if is_follow_mouse and event.is_action_released("pickup_piece"):
		drop()

func drop():
	if not is_follow_mouse and not is_touched:
		return
	#$MouseArea.monitoring = false
	is_touched = false
	is_hovered = false
	is_follow_mouse = false
	was_placed = true
	linear_velocity = Vector2.ZERO
	apply_central_impulse(Input.get_last_mouse_speed() if last_touch_drag_velocity == Vector2.ZERO else last_touch_drag_velocity)
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
	if linear_velocity.length() < 5:
		return
	
	if (body.get_class() != get_class() or body == self) and not body is Wall:
		return
	$HitSound.pitch_scale = rand_range(0.5, 1.5)
	$HitSound.play()
	print("Bonk!")
