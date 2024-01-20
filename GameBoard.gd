class_name GameBoard
extends Node2D

var active_player : Player
onready var piece_spawner : GamePieceSpawner = $PieceSpawner

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func pass_turn(player: Player):
	player._on_turn_start()
	$PieceSpawner.spawn_pieces(player)


func _on_Line_body_entered(body):
	if body.has_method("drop"):
		body.drop()

func is_idle():
	return piece_spawner.is_active_piece_dropped and piece_spawner.are_all_pieces_idle()


func _on_DeleteArea_body_entered(body):
	if body is GamePiece:
		body.queue_free()
