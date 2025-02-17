extends Node2D

@onready var player_spawn = $PlayerSpawn
@onready var bubble_container = $BubbleContainer
@onready var player = $Player

@export var enemy_spawners: Array[Marker2D] = []
@export var enemy_markers: Array[Marker2D] = []

@onready var enemies_container = $EnemiesContainer
@onready var enemy_spawn_sfx = $EnemySpawnSFX
@onready var enemy_spawn_timer = $EnemySpawnTimer
@onready var enemy_spawn_accelerator = $EnemySpawnAccelerator

var elapsedTime = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	player.global_position = player_spawn.global_position
	player.bubble_shot.connect(_on_player_bubble_shot) 

func _on_player_bubble_shot(bubble_scene, location):
	var bubble = bubble_scene.instantiate()
	bubble.global_position = location
	bubble_container.add_child(bubble)


func _on_timer_timeout():
	var numero = randi_range(1,10)
	var enemy
	if numero<=3:
		enemy = Preloads.ENEMY_BROWN.instantiate()
	elif numero <=6:
		enemy = Preloads.ENEMY_GREEN.instantiate()
	else:
		enemy = Preloads.ENEMY_GREY.instantiate()
		
	var index = randi_range(0, enemy_spawners.size()-1)	
	enemy.global_position = enemy_spawners[index].global_position
	
	enemy.patrol_path.append(enemy_markers[randi_range(0, enemy_markers.size()-1)])
	enemy.patrol_path.append(enemy_markers[randi_range(0, enemy_markers.size()-1)])
	enemy.patrol_path.append(enemy_markers[randi_range(0, enemy_markers.size()-1)])
	enemy.patrol_path.append(enemy_markers[randi_range(0, enemy_markers.size()-1)])
	enemy.patrol_path.append(enemy_markers[randi_range(0, enemy_markers.size()-1)])
	
	enemies_container.add_child(enemy)
	enemy_spawn_sfx.play()


func _on_enemy_spawn_accelerator_timeout():
	enemy_spawn_timer.wait_time -= 0.1
