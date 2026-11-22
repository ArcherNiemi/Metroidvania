extends Node

var empty_heart = "res://Assets/Sprites/Empty Heart.png"
var full_heart = "res://Assets/Sprites/Full Heart.png"

var starting_room = 1
var current_room = 1
var checkpoint_room = 1
var room_path = "res://Assets/Scenes/Rooms/"

var room_container : Node2D
var player : CharacterBody2D
var camera : Camera2D
var room_spawn_point : Vector2
var checkpoint_position = Vector2(0,0)

var health = 4
var max_health = 4

var hearts : Control

var partial_hearts = 0

const heart_size = Vector2(70,70)
var collected_items: Array[String] = [] # (room_num)(name) example: 1Heart1

const TRANSITION_POSITION = Vector2(1000000, 1000000)
const TILE_SIZE = 10

func _ready() -> void:
	room_container = get_tree().get_first_node_in_group("room_container")
	player = get_tree().get_first_node_in_group("player")
	camera = get_tree().get_first_node_in_group("camera")
	hearts= get_tree().get_first_node_in_group("hearts")
	update_hearts()
	load_room_by_entrance(starting_room,0)
	
func load_room(room_num):
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
	
func load_room_by_entrance(room_num, entrance_num):
	current_room = room_num
	
	await load_room(room_num)
	
	var position = get_entrance_position(entrance_num)

	if position != null:
		player.teleport_to_location(position)
		room_spawn_point = position
	
	redefine_camera_limits()

func load_room_by_position(room_num, position):
	current_room = room_num
	
	await load_room(room_num)
	
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
			return entrance_node.global_position
	print("no entrance node found")
	return null

func collect_heart(state, id):
	partial_hearts += state
	if partial_hearts >= 2:
		partial_hearts -= 2
		max_health += 1
	health = max_health
	collected_items.append(id)
	update_hearts()
	
func is_collected(id):
	return id in collected_items
	
func take_damage():
	health -= 1
	if health <= 0:
		health = max_health
		load_room_by_position(checkpoint_room, checkpoint_position)
	else:
		player.teleport_to_location(room_spawn_point)
	update_hearts()

func update_checkpoint(position):
	checkpoint_position = position
	checkpoint_room = current_room

func update_hearts():
	for child in hearts.get_children():
		child.queue_free()
	for i in range(max_health):
		if health > i:
			hearts.add_child(create_texture_rect(load(full_heart),Vector2(10+(i*80),10),heart_size))
		else:
			hearts.add_child(create_texture_rect(load(empty_heart),Vector2(10+(i*80),10),heart_size))

func create_texture_rect(texture: Texture2D, position: Vector2, size: Vector2) -> TextureRect:
	var tex_rect = TextureRect.new()
	tex_rect.texture = texture
	
	tex_rect.expand_mode = TextureRect.EXPAND_KEEP_SIZE
	tex_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
	
	tex_rect.size = size
	
	tex_rect.position = position
	
	return tex_rect

func full_heal():
	health = max_health
	update_hearts()
