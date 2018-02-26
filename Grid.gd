extends TileMap

var tile_size

var grid_size = Vector2(16,9)
var grid = []

enum Entity_types {PLAYER, OBSTACLE, COLLECTABLE}

onready var Obstacle = preload("res://obstacle.tscn")

func _ready():
	print("Tiles are: ", cell_size.x)
	tile_size = cell_size
	
	for x in range(grid_size.x):
		grid.append([])
		for y in range(grid_size.y):
			grid[x].append(null)
	
	var player = get_node("Player")
	var start_pos = update_child_pos(player)
	
	player.position = start_pos
	
	populate_grid()		
	
func populate_grid():
	var positions = []
	for n in range(5):
		var waste = randi()
		var grid_pos = Vector2(randi() % int(grid_size.x), randi() % int(grid_size.y))
		if not grid_pos in positions:
			positions.append(grid_pos)
			
	for pos in positions:
		var new_obstacle = Obstacle.instance()
		new_obstacle.position = map_to_world(pos)
		grid[pos.x][pos.y] = OBSTACLE
		add_child(new_obstacle)
		
func is_cell_vacant(pos, direction):
	var grid_pos = world_to_map(pos) + direction.rotated(1/6)
	
	if is_pos_on_grid(grid_pos):
		return grid[grid_pos.x][grid_pos.y] == null
		
func update_child_pos(child_node):
	var grid_pos = world_to_map(child_node.position)
	print(grid_pos)
	grid[grid_pos.x][grid_pos.y] = null
	
	var new_grid_pos = grid_pos + child_node.direction.rotated(1/6)
	grid[new_grid_pos.x][new_grid_pos.y] = child_node.type
	
	var target_pos = map_to_world(new_grid_pos)
	return target_pos
		
func is_pos_on_grid(pos):
	return pos.x < grid_size.x and pos.x >= 0 and pos.y < grid_size.y and pos.y >= 0