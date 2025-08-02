extends Enemy

class_name Enemy_Grey


func _init() -> void:
	speed = 350.0
	chase_speed = 550.0
	patrol_path = []
	patrol_wait_time = 0
	damage = 1
	hp_max = 3
	current_patrol_target = 0
	wait_timer = 0.0
	chasing = false
