extends Node2D

onready var MapMaker = $ViewportContainer/Viewport/Main/MapMaker
onready var player = preload("res://Player/Rogue.tscn")
onready var slime = preload("res://Enemy/Slime.tscn")
onready var HUD = preload("res://HUD/HUD.tscn")

func _ready():
	#yield(get_tree().create_timer(8), "timeout")
	pass
	
	
func setTargets():
	$ViewportContainer/Viewport/Camera2D.target = get_tree().get_nodes_in_group("Player")[0]
	$ViewportContainer2/Viewport/Camera2D.target = get_tree().get_nodes_in_group("Player")[0]
	$ViewportContainer2/Viewport.world_2d = $ViewportContainer/Viewport.world_2d

func genMap():
	MapMaker.start()
	
func loadScreen():
	$"Loading Screen".start()
	
func quitToMainScreen():
	print ("Quitting to main screen")
	MapMaker.clearMap()
	for e in get_tree().get_nodes_in_group("Enemy"):
		e.queue_free()
	get_tree().get_nodes_in_group("Player")[0].queue_free()
	get_tree().get_nodes_in_group("HUD")[0].queue_free()
	
	$ViewportContainer/Viewport/Camera2D.target = null
	$ViewportContainer2/Viewport/Camera2D.target = null
	
	$"Menu Screen".show()
	
	
func _on_New_Game_Button_pressed():
	$"Menu Screen".hide()
	loadScreen()
	# Generate the map
	genMap()
	yield(get_tree().create_timer(1), "timeout")
	# Setup the HUD
	var b = HUD.instance()
	$ViewportContainer/Viewport/Main/CanvasLayer.add_child(b)
	
	# Instance the player
	var p = player.instance()
	$ViewportContainer/Viewport/Main.add_child(p)
	p.position = MapMaker.startRoom.position
	
	# Instance the slime enemy
	$ViewportContainer/Viewport/Main/EnemyHandler.spawnEnemies()
#	for i in range(5):
#		var e = slime.instance()
#		$ViewportContainer/Viewport/Main.add_child(e)
#		e.position = MapMaker.startRoom.position + Vector2(150 + i * 10, 0)
	
	# Update and bind the HUD
	$"ViewportContainer/Viewport/Main/CanvasLayer/HUD".setup(p)
	
	setTargets()