extends CharacterBody2D


const SPEED = 100
const JUMP_VELOCITY = -400.0

@onready var sprite = $Sprite2D/AnimatedSprite2D

func _physics_process(delta: float) -> void:
	if sprite.flip_h:
		velocity.x = SPEED
	else:
		velocity.x = -SPEED
	move_and_slide()

func destroy_self():
	#effects stuff
	velocity.x = 0
	await get_tree().create_timer(2.0).timeout
	queue_free()

func _on_timer_timeout() -> void:
	destroy_self()


func _on_upper_hitbox_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var player = body
		body.get_hit()
		player.JUMP = 2
		queue_free()


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.get_hit()
	
