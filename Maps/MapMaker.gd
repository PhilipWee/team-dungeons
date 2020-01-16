extends Node2D

var Room = preload("res://Maps/Room.tscn")
onready var Map = $YSort/TileMap

var startRoom = null
var endRoom = null

var fullRect = null
var roomPos = []

var tileSize = 32
var numRooms = 30
var minSize = 10
var maxSize = 20
var hspread = 400
var cull = 0.5 # Cull half the rooms

var path # Astar pathfinding object

var playMode = true


func _ready():
	randomize()		
	if playMode:
		$Camera2D.current = false
		
func start():
	makeRooms()
	yield(get_tree().create_timer(1), "timeout")
	makeMap()
	$Camera2D.current = false
	
	
func makeRooms():
	for i in range(numRooms):
		var pos = Vector2(rand_range(-hspread, hspread), 0)
		var r = Room.instance()
		var w = minSize + randi() % (maxSize - minSize)
		var h = minSize + randi() % (maxSize - minSize)
		r.makeRoom(pos, Vector2(w, h) * tileSize)
		$Rooms.add_child(r)
		
	# Wait for finish generation
	yield(get_tree().create_timer(0.3), "timeout")
	# Cull the rooms
	var roomPos = []
	for room in $Rooms.get_children():
		if randf() < cull:
			room.queue_free()
			
		else:
			room.mode = RigidBody2D.MODE_STATIC
			roomPos.append(Vector3(room.position.x, room.position.y, 0))
			# Disable collision shape
			room.get_node("CollisionShape2D").disabled = true
			
	yield(get_tree(), "idle_frame")
	
	# Generate a minimum spanning tree connecting rooms
	path = findMst(roomPos)
		
func _draw():
	if not playMode:
		for room in $Rooms.get_children():
			draw_rect(Rect2(room.position - room.size, room.size * 2),
							Color(0, 255, 0), false)
							
		if path:
			for p in path.get_points():
				for c in path.get_point_connections(p):
					var pathPos = path.get_point_position(p)
					var connPos = path.get_point_position(c)
					draw_line(Vector2(pathPos.x, pathPos.y), 
							Vector2(connPos.x, connPos.y), Color(1, 1, 0), 15, true)
						
func _process(delta):
	update()
	pass
	
func _input(event):
	if event.is_action_pressed("ui_select"):
		#Spacebar
		if not playMode:
			for n in $Rooms.get_children():
				n.queue_free()
			path = null
			makeRooms()

	if event.is_action_pressed("ui_focus_next"):
		if not playMode:
			makeMap()
	pass
		
func findMst(nodes):
	#Prim's algorithm
	var path = AStar.new()
	path.add_point(path.get_available_point_id(), nodes.pop_front())
	
	# Repeat
	while nodes:
		var minDist = INF # Min dist so far
		var minPos = null # Position of that node
		var pos = null # Current position
		
		# Loop through all the points in the path
		for p1 in path.get_points():
			p1 = path.get_point_position(p1)
			# Loop through remaining nodes in array
			for p2 in nodes:
				if p1.distance_to(p2) < minDist:
					minDist = p1.distance_to(p2)
					minPos = p2
					pos = p1
					
		var n = path.get_available_point_id()
		path.add_point(n, minPos)
		path.connect_points(path.get_closest_point(pos), n)
		nodes.erase(minPos)
		
	return path
	
func makeMap():
	# Create Tilemap from the generated rooms and path
	Map.clear()
	# Get start and end rooms
	getStartRoom()
	getEndRoom()	
	# Fill the map with walls then carve the rooms
	fullRect = Rect2()
	for room in $Rooms.get_children():
		var r = Rect2(room.position-room.size, 
					room.get_node("CollisionShape2D").shape.extents*2)
		fullRect = fullRect.merge(r)
		roomPos.append(r)
		
	var topLeft = Map.world_to_map(fullRect.position)
	var botRight = Map.world_to_map(fullRect.end)
	for x in range(topLeft.x, botRight.x):
		for y in range(topLeft.y, botRight.y):
			Map.set_cellv(Vector2(x, y), 3)
		
	# Carve rooms
	var corridors = [] # Keeps track of which corridors are done
	for room in $Rooms.get_children():
		var size = (room.size / tileSize).floor()
		var pos = Map.world_to_map(room.position)
		var upperLeft = (room.position / tileSize).floor() - size
		
		for x in range(2, size.x * 2 - 1):
			for y in range(2, size.y * 2 -1):
				Map.set_cellv(Vector2(upperLeft.x + x, upperLeft.y + y), 2)
		
		
		# Carve the connections
		var p = path.get_closest_point(Vector3(room.position.x, room.position.y, 0))
		for conn in path.get_point_connections(p):
			if not conn in corridors:
				var start = Map.world_to_map(Vector2(path.get_point_position(p).x,
												 path.get_point_position(p).y))
				var end = Map.world_to_map(Vector2(path.get_point_position(conn).x,
												 path.get_point_position(conn).y))
				carvePath(start, end)
		corridors.append(p)
		
	Map.update_bitmask_region()
			
func carvePath(pos1, pos2):
	# Carve a path between 2 points
	var xDiff = sign(pos2.x - pos1.x)
	var yDiff = sign(pos2.y - pos1.y)
	if xDiff == 0:
		# If vertically aligned rooms
		xDiff = pow(-1, randi() % 2) # -1 to random between 0 and 1
	if yDiff == 0:
		# If vertically aligned rooms
		yDiff = pow(-1, randi() % 2) # -1 to random between 0 and 1
		
	# Choose either x -> y or y -> x
	var x_y = pos1
	var y_x = pos2
	if (randi() % 2) > 0:
		x_y = pos2 
		y_x = pos1
		
	for x in range(pos1.x, pos2.x, xDiff):
		Map.set_cell(x, x_y.y, 0)
		Map.set_cell(x, x_y.y + yDiff, 0) # Widen corridor
		
	for y in range(pos1.y, pos2.y, yDiff):
		Map.set_cell(y_x.x, y, 0)
		Map.set_cell(y_x.x + xDiff, y, 0) # Widen corridor
	
		
func getStartRoom():
	var min_x = INF
	for room in $Rooms.get_children():
		if room.position.x < min_x:
			startRoom = room
			min_x = room.position.x

func getEndRoom():
	var max_x = -INF
	for room in $Rooms.get_children():
		if room.position.x > max_x:
			endRoom = room
			max_x = room.position.x
			
func clearMap():
	Map.clear()
	for room in $Rooms.get_children():
		room.queue_free()