extends StaticBody2D

class_name Bubble

@onready var player = $"../../Player"
@onready var collision_shape_2d = $CollisionShape2D

@export var speed = 1500
var velocity: Vector2
var direction: Vector2

@export var damage = 1

func _ready():
	direction = player.aim_direction

func _physics_process(delta):
	velocity = direction * speed
	position += velocity * delta
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()	


func _on_area_2d_area_entered(area):
	print("Bubble contacts with: ", area.get_parent().name)
	if area.get_parent() is Enemy:
		queue_free()
