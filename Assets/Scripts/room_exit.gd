extends Area2D
class_name RoomExit

@export var next_room_num = 1

func _on_body_entered(body: Node2D) -> void:
	if body is PlayerController:
		GameManager.next_room(next_room_num)
