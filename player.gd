class_name Player
extends Node2D

export var color = Color .red
var points = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func gain_points(amount):
	points += amount
	$PointLabel.text = str(points) + " Points" 

func lose_points(amount):
	points -= amount
	$PointLabel.text = str(points) + " Points" 

func set_nb(nb):
	$Title.text = $Title.text % nb

func _on_turn_start():
	$TurnLabel.show()
	

func _on_turn_end():
	$TurnLabel.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
