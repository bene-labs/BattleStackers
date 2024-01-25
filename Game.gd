extends Node2D

export var game_boards = []

var turn = 0
var players

var skip_turn = false
var is_piece_falling = false

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var board = game_boards[randi() % game_boards.size()].instance()
	add_child(board)
	move_child(board, 0)
	
	
	players = $Players.get_children()
	for i in range(players.size()):
		players[i].set_nb(i + 1)
	loop()
	

func loop():
	$MaxTurnTimer.stop()
	skip_turn = false
	start_next_turn()


func _input(event):
	if !is_piece_falling:
		return
	if event.is_action_pressed("pickup_piece") or \
			(event is InputEventScreenTouch and event.pressed):
		$SkipButton.show()


func start_next_turn():
	turn += 1
	is_piece_falling = false
	$GameBoard.pass_turn(players[(turn - 1) % players.size()])
	$SkipButton.hide()
	yield($GameBoard, "piece_dropped")
	is_piece_falling = true
	yield(get_tree().create_timer(0.2), "timeout")
	$MaxTurnTimer.start()
	while !$GameBoard.is_idle() and !skip_turn:
		yield(get_tree().create_timer(0.2), "timeout")
	for player in $Players.get_children():
		if player.points >= player.points_to_win:
			$WinPopup/Label.text = $WinPopup/Label.text % ((turn - 1) % players.size() + 1)
			$WinPopup.show()
			return
	loop()
	
	


func _on_SkipButton_button_down():
	skip_turn = true


func _on_MaxTurnTimer_timeout():
	$SkipButton.show()


func _on_RestartButton_button_down():
	get_tree().reload_current_scene()
