extends StaticBody2D

class_name Potion_Red

@onready var sprite_2d: Sprite2D
@onready var collision_shape_2d: CollisionShape2D
@onready var area_2d: Area2D
@onready var hit_box: CollisionShape2D
@onready var timer: Timer
@onready var sfx_pops: AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite_2d = $Sprite2D
	collision_shape_2d = $CollisionShape2D
	area_2d = $Area2D
	hit_box = $Area2D/HitBox
	timer = $Timer
	sfx_pops = $SFX_Pops


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_area_entered(area):
	var areaParent = area.get_parent()
	if areaParent is Player:
		sfx_pops.play()
		destroy_potion()

func destroy_potion():
	area_2d.monitoring = false
	area_2d.monitorable = false
	sprite_2d.visible = false
	collision_shape_2d.set_deferred("disabled",true)
	hit_box.set_deferred("disabled",true)
	await get_tree().create_timer(0.4).timeout
	queue_free()

func _on_timer_timeout():
	queue_free()
