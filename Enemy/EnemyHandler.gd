extends Node2D

onready var MapMaker = $"../MapMaker"
onready var Rooms = $"../MapMaker/Rooms"

onready var slime = preload("res://Enemy/Slime.tscn")

func _ready():
	pass
	
func spawnEnemies():
	for room in Rooms.get_children():
		if room != MapMaker.startRoom:
			var numEnemies = ceil(room.size.x * room.size.y / 30000)
			var size = room.size
			var pos = room.position
			for i in range(numEnemies):
				var s = slime.instance()
				# Get random position within room to spawn
				var minX = pos.x - size.x/2
				var maxX = pos.x + size.x/2
				var minY = pos.y - size.y/2
				var maxY = pos.y + size.y/2
				var x = rand_range(minX, maxX)
				var y = rand_range(minY, maxY)
				s.position = Vector2(x, y)
				add_child(s)
