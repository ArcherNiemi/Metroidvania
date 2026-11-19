extends Node

var starting_room = 1
var current_room = 1
var room_path = "res://Assets/Scenes/Rooms/"

var room_container : Node2D
var player : CharacterBody2D

const TRANSITION_POSITION = Vector2(1000000, 1000000)

func _ready() -> void:
	room_container = get_tree().get_first_node_in_group("room_container")
	player = get_tree().get_first_node_in_group("player")
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
