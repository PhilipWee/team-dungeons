extends Node2D

onready var MapMaker = $ViewportContainer/Viewport/Main/MapMaker
onready var player = preload("res://Player/Rogue.tscn")
onready var slime = preload("res://Enemy/Slime.tscn")
onready var HUD = preload("res://HUD/HUD.tscn")

func _ready():
	#yield(get_tree().create_timer(8), "timeout")
	pass
	
	
func setTargets():
	print ("Setting")
	$ViewportContainer/Viewport/Camera2D.target = get_tree().get_nodes_in_group("Player")[0]
	$ViewportContainer2/Viewport/Camera2D.target = get_tree().get_nodes_in_group("Player")[0]
	$ViewportContainer2/Viewport.world_2d = $ViewportContainer/Viewport.world_2d

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
	$ViewportContainer/Viewport/Main/CanvasLayer.add_child(b)
	
	# Instance the player
	var p = player.instance()
	$ViewportContainer/Viewport/Main.add_child(p)
	p.position = MapMaker.startRoom.position
	
	# Instance the slime enemy
	var e = slime.instance()
	$ViewportContainer/Viewport/Main.add_child(e)
	e.position = MapMaker.startRoom.position + Vector2(150, 0)
	
	# Update and bind the HUD
	$"ViewportContainer/Viewport/Main/CanvasLayer/HUD".setup()
	
	setTargets()