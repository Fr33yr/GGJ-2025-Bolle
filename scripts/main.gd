extends Node2D

@onready var player_spawn = $PlayerSpawn
@onready var bubble_container = $BubbleContainer
@onready var player = $Player
@export var enemy_spawners: Array[Marker2D] = []
@export var enemy_markers: Array[Marker2D] = []

var enemyScene = preload("res://scenes/enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	player.global_position = player_spawn.global_position
	player.bubble_shot.connect(_on_player_bubble_shot) 
	

func _process(delta):
	
	pass

func _on_player_bubble_shot(bubble_scene, location):
	var bubble = bubble_scene.instantiate()
	bubble.global_position = location
	bubble_container.add_child(bubble)
