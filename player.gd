class_name Player
extends Node2D

export var color = Color.orangered
export var points_to_win = 100
var points = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	$ProgressBar.max_value = points_to_win
	

func gain_points(amount):
	points += amount
	$ProgressBar.value = points
	$PointLabel.text = str(points) + " Points" 

func lose_points(amount):
	points -= amount
	$ProgressBar.value = points
	$PointLabel.text = str(points) + " Points" 

func set_nb(nb):
	$Title.text = $Title.text % nb
	if nb > 1:
		color = Color.cyan
	$TurnLabel.modulate = color
	$Title.modulate = color

func _on_turn_start():
	$TurnLabel.show()
	

func _on_turn_end():
	$TurnLabel.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
