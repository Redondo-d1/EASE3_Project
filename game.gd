extends Node

var Direction
var previous_count = 0.0

@onready var Left_Spawn = $Left/PathFollow2D
@onready var Right_Spawn = $Right/PathFollow2D

func spawn_mob():
	var Mob = preload("res://mob.tscn").instantiate()
	Direction = randf() + previous_count
	print(Direction)
	if Direction > 0.5:
		#Left
		Left_Spawn.progress_ratio = randf()
		Mob.global_position = Left_Spawn.global_position
		Mob.get_node("Sprite2D").get_node("AnimatedSprite2D").flip_h = true
		add_child(Mob)
		previous_count -= 0.05
	else: 
		Right_Spawn.progress_ratio = randf()
		Mob.global_position = Right_Spawn.global_position
		add_child(Mob)
		previous_count += 0.05


	


func _on_timer_timeout() -> void:
	spawn_mob()
