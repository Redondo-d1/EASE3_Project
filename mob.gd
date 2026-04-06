extends CharacterBody2D


const SPEED = 100
const JUMP_VELOCITY = -400.0

const SMOKE_OFFSET:Vector2 = Vector2(0,0)

@onready var sprite = $Sprite2D/AnimatedSprite2D

var alive: bool = true

func _physics_process(_delta: float) -> void:
	if !alive:
		return
	if sprite.flip_h:
		velocity.x = SPEED
	else:
		velocity.x = -SPEED
	move_and_slide()

func SetShader_BlinkIntensity(newValue : float):
	sprite.material.set_shader_parameter("blink_intensity", newValue)
	
func blink_self():
	var tween = get_tree().create_tween()
	tween.tween_method(SetShader_BlinkIntensity, 1.0, 0.0, 1)

func _ready() -> void:
	var smoke_effect = preload("res://smoke.tscn").instantiate()
	#smoke_effect.global_position = self.global_position + SMOKE_OFFSET
	if sprite.flip_h:
		smoke_effect.rotation_degrees = -180
	else:
		smoke_effect.rotation_degrees = 0
	smoke_effect.get_node("GPUParticles2D").emitting = true
	add_child(smoke_effect)
	
func destroy_self():
	alive = false
	velocity.x = 0
	for i in range(10):
		blink_self()
		await get_tree().create_timer(0.5-(i*0.1)+0.01).timeout
	
	queue_free()

func _on_timer_timeout() -> void:
	destroy_self()


func _on_upper_hitbox_body_entered(body: Node2D) -> void:
	if body.name == "Player" && alive:
		var player = body
		player.JUMP = 2
		destroy_self()

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.get_hit()
	if body.name == "Mob" && !body == self:
		destroy_self()
	
