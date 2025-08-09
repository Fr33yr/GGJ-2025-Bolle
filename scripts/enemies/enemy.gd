extends CharacterBody2D

class_name Enemy

var enemy: CharacterBody2D
var sfx_laughter: AudioStreamPlayer
var hp_system: HP_System
var animated_sprite_2d: AnimatedSprite2D
var collision_shape_2d: CollisionShape2D
var hp_bar: ProgressBar
var hitbox: CollisionShape2D
var area_2d: Area2D

var speed: float
var chase_speed: float
var patrol_path: Array[Marker2D]
var patrol_wait_time: float
var damage: int
var hp_max: int

var current_patrol_target: int
var wait_timer: float

var chasing: bool
var player: Player

# Called when the node enters the scene tree for the first time.
func _ready():
	enemy = $"."
	sfx_laughter = $SFX_Laughter
	hp_system = $HP_System
	animated_sprite_2d = $AnimatedSprite2D
	collision_shape_2d = $CollisionShape2D
	hp_bar = $HP_Bar
	hitbox = $Area2D/Hitbox
	area_2d = $Area2D
	
	hp_system.init(hp_max)
	hp_bar.max_value = hp_max
	hp_bar.value = hp_max
	
	hp_system.died.connect(on_Died)


# Calls to HPSystem to apply damage.
func apply_damage(damage_recieved: int):
	hp_system.apply_damage(damage_recieved)
	

# Disables all functions. Called from signal.
func on_Died():
	manage_drops()
	area_2d.monitoring = false
	area_2d.monitorable = false
	animated_sprite_2d.visible = false
	collision_shape_2d.set_deferred("disabled",true)
	hitbox.set_deferred("disabled",true)
	hp_bar.visible = false
	await get_tree().create_timer(0.5).timeout
	queue_free()

func manage_drops():
	var numero = randi_range(1,10)
	var drop: StaticBody2D
	
	if numero <= 1:
		drop = preload("res://scenes/drops/heart.tscn").instantiate()
	elif numero >= 2 && numero<= 5:
		drop = preload("res://scenes/drops/potion_red.tscn").instantiate()
	elif numero >= 6 && numero<= 7:
		drop = preload("res://scenes/drops/potion_purple.tscn").instantiate()
		
	if drop != null:
		drop.global_position = enemy.global_position
		var container: Node = enemy.get_parent()
		container.add_child(drop,false,Node.INTERNAL_MODE_DISABLED)

func _on_area_2d_area_entered(area: Area2D) -> void:
	var areaParent = area.get_parent()
	if areaParent is Bubble_Blue || areaParent is Bubble_Red || areaParent is Bubble_Purple:
		var damage_recieved = (areaParent as Bubble).damage
		hp_system.apply_damage(damage_recieved)

func take_damage(damage_recieved: int) -> void:
	animated_sprite_2d.play("dead")
	hp_bar.value -= damage_recieved

func _physics_process(delta: float) -> void:
	if !chasing && patrol_path.size() > 1:
		animated_sprite_2d.play("idle")
		move_along_path(delta)
	elif chasing:
		animated_sprite_2d.play("chasing")
		chase_player(delta)
	

func move_along_path(delta: float):
	var target_position = patrol_path[current_patrol_target].global_position
	var direction = (target_position - position).normalized()
	var distance_to_target = position.distance_to(target_position)
	
	if distance_to_target > speed * delta:
		velocity = direction * speed
		move_and_slide()
	else:
		position = target_position
		wait_timer += delta
		if wait_timer >= patrol_wait_time:
			wait_timer = 0.0
			current_patrol_target = (current_patrol_target + 1) % patrol_path.size()
		

func chase_player(delta: float):
	var player_position = player.global_position
	var direction = (player_position - position).normalized()
	var distance_to_target = position.distance_to(player_position)
	
	if distance_to_target > chase_speed * delta:
		velocity = direction * speed
		move_and_slide()

func _on_player_detector_body_entered(body):
	if body is Player:
		chasing = true
		player = body
		sfx_laughter.play()


func _on_player_detector_body_exited(body):
	if body is Player:
		chasing = false
	
