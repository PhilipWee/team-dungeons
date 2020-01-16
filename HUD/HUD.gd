extends Control

var viewportSize
var player

signal backToMenuScreen

func _ready():
	# Connect the signal
	connect("backToMenuScreen", $"../../", "quitToMainScreen")
	viewportSize = get_viewport().size
	$"Joystick".position = Vector2(viewportSize.x * 0.15, viewportSize.y * 0.8)
	$"Attack Button".position = Vector2(viewportSize.x * 0.8, viewportSize.y * 0.7)
	
	
func setup():
	$"Attack Button".setup()
	player = get_tree().get_nodes_in_group("Player")[0]
	
	# Setup world viewport
	#$"../../ViewportContainer/Viewport/Camera2D".target = player
	
	# Setup minimap
	#$"MiniMap Container/Viewport".world_2d = $"../../ViewportContainer/Viewport".world_2d
	
func _process(delta):
	#updateHealth()
	pass
	
	
func updateHealth():
	# Function updates health
	var health = player.Health
	$HBoxContainer/HealthBar/TextureProgress.value = health

func _on_Quit_Button_pressed():
	emit_signal("backToMenuScreen")
