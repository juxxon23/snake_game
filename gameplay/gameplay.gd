class_name Gameplay
extends Node2D

@onready var head: Head = %Head as Head # 'as Head' helps with the autocomplete of Head's functions
@onready var bounds: Bounds = %Bounds as Bounds
@onready var spawner: Spawner = $Spawner as Spawner

var time_between_moves: float = 1000.0
var time_since_last_move: float = 0
var speed: float = 5000.0
var move_dir: Vector2 = Vector2.RIGHT
var snake_parts: Array[SnakePart] = []


func _ready() -> void:
	head.food_eaten.connect(_on_food_eaten)
	head.collide_with_tail.connect(_on_tail_collide)
	spawner.tail_added.connect(_on_tail_added)
	spawner.spawn_food()
	snake_parts.push_back(head)


func _process(_delta: float) -> void:
	var new_dir: Vector2 = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		new_dir = Vector2.UP
	elif Input.is_action_pressed("ui_down"):
		new_dir = Vector2.DOWN
	elif Input.is_action_pressed("ui_right"):
		new_dir = Vector2.RIGHT
	elif Input.is_action_pressed("ui_left"):
		new_dir = Vector2.LEFT
		
	# Don't allow reverse directions
	if new_dir + move_dir != Vector2.ZERO and new_dir != Vector2.ZERO:
		move_dir = new_dir


func _physics_process(delta: float) -> void:
	time_since_last_move += delta * speed
	if time_since_last_move >= time_between_moves:
		update_snake()
		time_since_last_move = 0


func update_snake() -> void:
	var new_pos: Vector2 = head.position + move_dir * Global.GRID_SIZE
	new_pos = bounds.wrap_vector(new_pos)
	head.move_to(new_pos)
	
	for i in range(1, snake_parts.size(), 1):
		snake_parts[i].move_to(snake_parts[i-1].last_position)


func _on_food_eaten() -> void:
	spawner.call_deferred("spawn_food")
	spawner.call_deferred("spawn_tail", snake_parts[snake_parts.size()-1].last_position)
	speed += 500.0

	
func _on_tail_added (tail: Tail) -> void:
	snake_parts.push_back(tail)


func _on_tail_collide() -> void:
	print("Game over")
