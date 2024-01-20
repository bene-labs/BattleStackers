class_name GamePieceSpawner
extends Node2D

export var availible_pieces = []
var piece_pool
var is_active_piece_dropped = true

var active_pieces = []
var active_player = null

onready var slots = get_children()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func are_all_pieces_idle():
	for piece in $ActivePieces.get_children():
		if piece.linear_velocity.length() > 0.01:
			return false
	return true
	

func _on_piece_picked_up(picked_piece):
	for piece in active_pieces:
		if not piece == picked_piece:
			piece.queue_free()
	active_pieces = [picked_piece]


func _on_piece_dropped():
	is_active_piece_dropped = true
	active_pieces.clear()
	active_player._on_turn_end()


func spawn_pieces(player):
	active_player = player
	is_active_piece_dropped = false
	piece_pool = availible_pieces.duplicate()
	for slot in slots:
		if piece_pool.size() == 0:
			break
		var chosen_piece = piece_pool.pop_at(randi() % piece_pool.size())
		var new_piece = chosen_piece.instance()
		new_piece.init(player)
		new_piece.connect("picked_up", self, "_on_piece_picked_up")
		new_piece.connect("dropped", self, "_on_piece_dropped")
		new_piece.global_position = slot.global_position
		new_piece.self_modulate = player.color
		active_pieces.push_back(new_piece)
		$ActivePieces.add_child(new_piece)
