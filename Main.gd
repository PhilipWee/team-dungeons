extends Node2D

#onready var player = preload("res://Player/Adventurer.tscn")
onready var player = preload("res://Player/Rogue.tscn")
onready var slime = preload("res://Enemy/Slime.tscn")
onready var HUD = preload("res://HUD/HUD.tscn")

onready var MapMaker = $MapMaker

func _ready():
	pass

	
func genMap():
	MapMaker.start()
	
func loadScreen():
	$"Loading Screen".start()
	
func quitToMainScreen():
	MapMaker.clearMap()
	$Player.queue_free()
	$"Menu Screen".show()
	
	
func _on_New_Game_Button_pressed():
	$"Menu Screen".hide()
	loadScreen()
	# Generate the map
	genMap()
	yield(get_tree().create_timer(5), "timeout")
	# Setup the HUD
	var b = HUD.instance()
	$CanvasLayer.add_child(b)
	
	# Instance the player
	var p = player.instance()
	add_child(p)
	p.position = MapMaker.startRoom.position
	
	# Instance the slime enemy
	var e = slime.instance()
	add_child(e)
	e.position = MapMaker.startRoom.position + Vector2(150, 0)
	
	# Update and bind the HUD
	$"CanvasLayer/HUD".setup()
	
	$"../../../".setTargets()
