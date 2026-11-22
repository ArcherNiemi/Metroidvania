extends Area2D
class_name RoomExit

@export var next_room_num: int = 1
@export var entrance_num: int = 0

func _on_body_entered(body: Node2D) -> void:
	if body is PlayerController:
		GameManager.load_room_by_entrance(next_room_num,entrance_num)
