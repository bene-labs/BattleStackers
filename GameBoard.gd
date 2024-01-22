class_name GameBoard
extends Node2D

signal piece_dropped

var active_player : Player
onready var piece_spawner : GamePieceSpawner = $PieceSpawner


func _ready():
	$PieceSpawner.connect("piece_dropped", self, "on_piece_dropped")

func on_piece_dropped():
	emit_signal("piece_dropped")

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
		$DeleteArea/DropSound.play()
		body.queue_free()
