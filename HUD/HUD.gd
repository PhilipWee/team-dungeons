extends Control

var HealthBar
var ExpBar
var LevelIndicator

var viewportSize
var player

signal backToMenuScreen

func _ready():
	add_to_group("HUD")
	# Connect the signal
	connect("backToMenuScreen", $"../../../../../", "quitToMainScreen")
	viewportSize = get_viewport().size
	$"Joystick".position = Vector2(viewportSize.x * 0.15, viewportSize.y * 0.8)
	$"Attack Button".position = Vector2(viewportSize.x * 0.8, viewportSize.y * 0.7)
	
	HealthBar = $"Player Stats/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/HealthProgressBar"
	ExpBar = $"Player Stats/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer2/ExpProgressBar"
	LevelIndicator = $"Player Stats/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer3/CurrentLevel"
	
	
func setup(p):
	# Setup the player node
	player = p
	
	# Setup attack button
	$"Attack Button".setup()
	
	# Setup the player stats link
	HealthBar.max_value = player.Health
	HealthBar.value = player.Health
	ExpBar.max_value = player.calcEXP()
	ExpBar.value = player.EXP
	LevelIndicator.text = String(player.Level)
	
func updateHealth():
	HealthBar.value = player.Health
	
func updateEXP(current, upperBound):
	ExpBar.max_value = upperBound
	ExpBar.value = current
	
func updateLevel(level):
	LevelIndicator.text = String(level)
	
	
func _process(delta):
	#updateHealth()
	pass

func _on_Quit_Button_pressed():
	emit_signal("backToMenuScreen")
