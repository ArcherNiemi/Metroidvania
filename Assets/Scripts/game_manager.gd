extends Node

var starting_room = 1
var current_room = 1
var room_path = "res://Assets/Scenes/Rooms/"

var room_container : Node2D
var player : CharacterBody2D
var camera : Camera2D
var room_spawn_point : Vector2

const TRANSITION_POSITION = Vector2(1000000, 1000000)
const TILE_SIZE = 10

func _ready() -> void:
	room_container = get_tree().get_first_node_in_group("room_container")
	player = get_tree().get_first_node_in_group("player")
	camera = get_tree().get_first_node_in_group("camera")
	load_room(starting_room,0)

func next_room(room_num, entrance_num):
	current_room = room_num
	load_room(current_room,entrance_num)

	
func load_room(room_num, entrance_num):
	var full_path = room_path + "room_" + str(room_num) + ".tscn"
	var scene = load(full_path) as PackedScene

	if !scene:
		return

	for child in room_container.get_children():
		child.queue_free()

	await get_tree().process_frame
	
	player.teleport_to_location(TRANSITION_POSITION)

	var instance = scene.instantiate()
	room_container.add_child(instance)

	var position = get_entrance_position(entrance_num)

	if position != null:
		player.teleport_to_location(position)
		room_spawn_point = position
	
	redefine_camera_limits()
		
func redefine_camera_limits():
	var used_cells: Array[Vector2i] = get_tree().get_first_node_in_group("tiles").get_used_cells()
	
	var vertical_max = used_cells[0][1]
	var vertical_min = used_cells[0][1]
	var horizontal_max = used_cells[0][0]
	var horizontal_min = used_cells[0][0]
	for cell in used_cells:
		if cell[1] > vertical_max:
			vertical_max = cell[1]
		if cell[1] < vertical_min:
			vertical_min = cell[1]
		if cell[0] > horizontal_max:
			horizontal_max = cell[0]
		if cell[0] < horizontal_min:
			horizontal_min = cell[0]
	
	camera.limit_bottom = vertical_max * TILE_SIZE
	camera.limit_top = (vertical_min+1) * TILE_SIZE
	camera.limit_left = (horizontal_min+1) * TILE_SIZE
	camera.limit_right = horizontal_max* TILE_SIZE
	
func get_entrance_position(entrance_num):
	var entrances = room_container.get_child(0).get_node("RoomEntrances")

	for entrance_node in entrances.get_children():
		if entrance_node.name == str(entrance_num):
			print(entrance_node.position)
			return entrance_node.position
	print("no entrance node found")
	return null

func collect_heart(state):
	pass
	
func take_damage():
	player.teleport_to_location(room_spawn_point)
