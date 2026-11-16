extends Node

var current_room = 1
var room_path = "res://Assets/Scenes/Rooms/"

func next_room(room_num):
	current_room = room_num
	var full_path = room_path + "room_" + str(current_room) + ".tscn"
	get_tree().change_scene_to_file(full_path)
