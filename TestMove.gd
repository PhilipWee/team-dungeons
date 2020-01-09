extends Node2D

onready var joystick = $"Joystick Base"

func _ready():
	pass
	
func _process(delta):
	$"Test Obj".move_and_slide(joystick.getValue() * 400)
