extends Area2D
class_name Heart

@export var state = 0
@export var sprite : Sprite2D

const heart_pixels = 10

var id : String

func _ready() -> void:
	sprite.region_rect.position.x = state * heart_pixels
	id = str(GameManager.current_room)+name
	
	if GameManager.is_collected(id):
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is PlayerController:
		GameManager.collect_heart(state,id)
		queue_free()
