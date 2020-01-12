extends Control

var viewportSize

func _ready():
	viewportSize = get_viewport().size
	$"Joystick".position = Vector2(viewportSize.x * 0.15, viewportSize.y * 0.8)
	$"Attack Button".position = Vector2(viewportSize.x * 0.8, viewportSize.y * 0.7)