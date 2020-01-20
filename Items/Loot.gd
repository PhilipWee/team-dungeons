extends Node2D

var value = null
var EXPValue = null

func _ready():
	pass


func _on_PickUp_Area_body_entered(body):
	body.pickUp(name, value, EXPValue)
	queue_free()
