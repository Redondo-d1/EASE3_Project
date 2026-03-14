extends CharacterBody2D

@export var MAX_SPEED: int = 400
@export var MAX_ACCELERATION: int = 10
@export var SLIDE: float = -0.5
@export var UP_GRAVITY: int = 1000
@export var DOWN_GRAVITY: int = 1200
@export var JUMP_POWER: int = 500
@export var JUMP: int = 2

@onready var sprite = $Sprite2D/AnimatedSprite2D

var health = 3
var invincibility: bool = false

signal player_death

var stopvar: bool = false
var direction: Vector2
var speed: float = 0
var acceleration: float = 0



func stop():
	stopvar = true
	velocity.y = 0
	velocity.x = 0
	speed = 0
	acceleration = 0
	await get_tree().create_timer(2.0).timeout
	stopvar = false
	
func respawn():
	stop()
	sprite.play("got_Hit")
	health = 3
	
	self.global_position = Vector2(-170,-2)

func get_hit():
	invincibility = false
	if !invincibility:
		health -= 1
		print("Player got hit!")
		if health <= 0:
			respawn()
			player_death.emit()
			return
			
		await get_tree().create_timer(2.0).timeout
	invincibility = true

func _process(delta: float) -> void:
	direction = Vector2.ZERO

	if is_on_floor():
		velocity.y = 0
		direction.y = 0
		JUMP = 2
	elif stopvar:
		return
	elif velocity.y < 0:
		velocity.y += UP_GRAVITY * delta
		direction.y = -1
	else:
		velocity.y += UP_GRAVITY * delta
		direction.y = 1

	if Input.is_action_pressed("ui_right"):
		#if !is_on_floor():
			#speed = abs(speed)
		direction.x += 1
		speed += min(MAX_ACCELERATION * direction.x, MAX_SPEED)
	if Input.is_action_just_released("ui_right") or Input.is_action_just_released("ui_left"):
		speed = 0
	if Input.is_action_pressed("ui_left"):
		#if !is_on_floor():
			#speed = -abs(speed)
		direction.x -= 1
		speed += max(MAX_ACCELERATION * direction.x,-MAX_SPEED)
	#when nothing is clicked
	if !abs(direction.x) and is_on_floor():
		speed *= SLIDE
		if abs(speed) < 0.1:
			velocity.x = 0
	
		
	if Input.is_action_just_pressed("ui_up") and JUMP > 0:
		velocity.y = 0
		velocity.y -= JUMP_POWER
		JUMP -= 1
	
	if speed > 0:
		velocity.x = min(speed, MAX_SPEED)
	elif speed < 0:
		velocity.x = max(speed, -MAX_SPEED)
	else:
		velocity.x = speed 
	
	if direction.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	
	if velocity.y > 0:
		sprite.play("JUMP_down")
	elif velocity.y == 0 and (speed > 0.1 or speed < -0.1):
		sprite.play("walk")
	elif velocity.y < 0:
		sprite.play("JUMP_up")
	else:
		sprite.play("Idle")
		
		
	#debug 
	if Input.is_action_just_pressed("Reset"):
		print("-----------------------")
		print("Direction: ")
		print(direction.x)
		print("Speed: ")
		print(speed)
		print("-----------------------")

	move_and_slide()
