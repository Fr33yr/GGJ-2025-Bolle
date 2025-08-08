extends Enemy

class_name Enemy_Green

@onready var sfx_shoot_bubble: AudioStreamPlayer
@onready var timer: Timer

var bubble_speed: float

func _init() -> void:
	speed = 350.0
	chase_speed = 400.0
	patrol_path = []
	patrol_wait_time = 0
	damage = 1
	hp_max = 5
	current_patrol_target = 0
	wait_timer = 0.0
	chasing = false
	bubble_speed = 100.0

func _ready() -> void:
	super()
	sfx_shoot_bubble = $SFX_ShootBubble
	timer = $Timer

func on_Died():
	timer.stop()
	super()

func manage_drops():
	var numero = randi_range(1,10)
	var drop: StaticBody2D
	
	if numero <= 2:
		drop = preload("res://scenes/drops/heart.tscn").instantiate()
	elif numero >= 3 && numero<= 4:
		drop = preload("res://scenes/drops/potion_red.tscn").instantiate()
	elif numero >= 5 && numero <= 8:
		drop = preload("res://scenes/drops/potion_green.tscn").instantiate()
	
	if drop != null:
		drop.global_position = enemy.global_position
		var container: Node = enemy.get_parent()
		container.add_child(drop,false,Node.INTERNAL_MODE_DISABLED)

func _on_timer_timeout_shoot_bubble():
	if  player != null:
		var player_position = player.global_position
		var direction = (player_position - position).normalized()
		var bubble = preload("res://scenes/bubbles/bubble_green.tscn").instantiate()
		
		bubble.global_position = enemy.global_position
		bubble.direction = direction
		
		var container: Node = enemy.get_parent()
		
		container.add_child(bubble)
		sfx_shoot_bubble.play()
