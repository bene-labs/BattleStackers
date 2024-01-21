extends Node2D

var turn = 0
var players

var skip_turn = false


# Called when the node enters the scene tree for the first time.
func _ready():
	players = $Players.get_children()
	for i in range(players.size()):
		players[i].set_nb(i + 1)
	loop()
	

func loop():
	$MaxTurnTimer.stop()
	skip_turn = false
	start_next_turn()


func start_next_turn():
	turn += 1
	$GameBoard.pass_turn(players[(turn - 1) % players.size()])
	$SkipButton.hide()
	yield($GameBoard, "piece_dropped")
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
