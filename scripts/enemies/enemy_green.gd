extends Enemy

class_name Enemy_Green

@onready var sfx_shoot_bubble: AudioStreamPlayer
@onready var enemy_green: CharacterBody2D
@onready var bubbles_container: Node
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
	enemy_green = $"."
	bubbles_container = $Bubbles_Container
	timer = $Timer

func on_Died():
	timer.stop()
	manage_drops()
	super()

func manage_drops():
	var potion = Preloads.POTION_GREEN.instantiate()
	potion.global_position = enemy_green.global_position
	var container: Node = enemy_green.get_parent()
	container.add_child(potion,false,Node.INTERNAL_MODE_DISABLED)


func _on_timer_timeout_shoot_bubble():
	if  player != null:
		var player_position = player.global_position
		var direction = (player_position - position).normalized()
		var bubble = Preloads.BUBBLE_GREEN.instantiate()
		
		bubble.global_position = enemy_green.global_position
		bubble.direction = direction
		
		bubbles_container.add_child(bubble)
		sfx_shoot_bubble.play()
