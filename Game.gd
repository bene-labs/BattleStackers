extends Node2D

var turn = 0
var players


# Called when the node enters the scene tree for the first time.
func _ready():
	players = $Players.get_children()
	for i in range(players.size()):
		players[i].set_nb(i + 1)
	loop()


func loop():
	start_next_turn()


func start_next_turn():
	turn += 1
	$GameBoard.pass_turn(players[(turn - 1) % players.size()])
	while !$GameBoard.is_idle():
		yield(get_tree().create_timer(0.2), "timeout")
	loop()
	
	
