extends Area2D
class_name HurtBox


func _on_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		GameManager.take_damage()
