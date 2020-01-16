extends MarginContainer

onready var mapMaker = $"../../MapMaker"

var roomIcon = preload("res://HUD/RoomIcon.tscn")

var Size = Vector2(1000, 1000)
var DisplaySize = 100
var scale

func _ready():
	pass
	$".".rect_size = Vector2(DisplaySize, DisplaySize)
	yield(get_tree().create_timer(5), "timeout")
	#initMiniMap()
	
func initMiniMap():
	# Get the full rect of the rooms
	var fullRect = mapMaker.fullRect # Rect2D object
	
	# Calculate scale down unit
	var scaleVector = fullRect.size / Size
	scale = max(ceil(scaleVector.x), ceil(scaleVector.y))
	#print (max(ceil(scale.x), ceil(scale.y)))
	print (mapMaker.roomPos)
	
	for r in mapMaker.roomPos:
		var x = r.position.x
		var y = r.position.y
		var scaledDownX = x / scale
		var scaledDownY = y / scale
		
		var a = roomIcon.instance()
		a.position = Vector2(scaledDownX, scaledDownY)
		$CanvasLayer.add_child(a)
		
	
	
func updateMiniMap():
	# Get player pos wrt minimap rect
	pass