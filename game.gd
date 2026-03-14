extends Node

var Direction

@onready var Left_Spawn = $Left/PathFollow2D
@onready var Right_Spawn = $Right/PathFollow2D

func spawn_mob():
	var Mob = preload("res://mob.tscn").instantiate()
	Direction = randf()
	print(Direction)
	if Direction > 0.5:
		#Left
		Left_Spawn.progress_ratio = randf()
		Mob.global_position = Left_Spawn.global_position
		Mob.get_node("Sprite2D").get_node("AnimatedSprite2D").flip_h = true
		add_child(Mob)
	else: 
		Right_Spawn.progress_ratio = randf()
		Mob.global_position = Right_Spawn.global_position
		add_child(Mob)


	


func _on_timer_timeout() -> void:
	spawn_mob()
