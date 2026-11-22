extends Area2D
class_name Checkpoint

func _on_body_entered(body: Node2D) -> void:
	if body is PlayerController:
		GameManager.update_checkpoint(global_position)
		GameManager.full_heal()
