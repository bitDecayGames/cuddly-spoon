extends KinematicBody2D

const UP = Vector2(0, -1)
const DOWN = Vector2(0, 1)
const LEFT = Vector2(-1, 0)
const RIGHT = Vector2(1, 0)

var grid
var type

var is_moving = false
var target_pos = Vector2()
var target_dir = Vector2()

var direction = Vector2()

var velocity = Vector2()
var max_speed = 200

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	grid = get_parent()
	type = grid.PLAYER
	pass

func _process(delta):
	direction.x = 0
	direction.y = 0
	if Input.is_action_pressed("move_up"):
		direction += UP
	if Input.is_action_pressed("move_down"):
		direction += DOWN
	if Input.is_action_pressed("move_left"):
		direction += LEFT
	if Input.is_action_pressed("move_right"):
		direction += RIGHT
		
	if not is_moving and direction != Vector2():
		target_dir = direction
		if grid.is_cell_vacant(position, target_dir):
			target_pos = grid.update_child_pos(self)
			is_moving = true
	elif is_moving:
		velocity = max_speed * target_dir * delta
		
		var distance_to_target = Vector2(abs(target_pos.x - position.x), abs(target_pos.y - position.y))
		
		if abs(velocity.x) > distance_to_target.x:
			velocity.x = distance_to_target.x * target_dir.x
			is_moving = false
			
		if abs(velocity.y) > distance_to_target.y:
			velocity.y = distance_to_target.y * target_dir.y
			is_moving = false
		
		move_and_collide(velocity)