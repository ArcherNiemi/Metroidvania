extends Area2D
class_name Heart

@export var state = 0
@export var sprite : Sprite2D

const heart_pixels = 10

func _ready() -> void:
	sprite.region_rect.position.x = state * heart_pixels

func _on_body_entered(body: Node2D) -> void:
	if body is PlayerController:
		GameManager.collect_heart(state)
		queue_free()
