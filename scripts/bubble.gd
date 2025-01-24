extends Area2D

@export var speed = 600
var muzzle: Marker2D 

func _ready():
	pass

func _physics_process(delta):
	var velocity = Vector2(-speed, 0) * delta
	global_position += velocity
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
