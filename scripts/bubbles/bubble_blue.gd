extends Bubble

class_name Bubble_Blue

@onready var player: CharacterBody2D

func _ready():
	super()
	player = $"../../Player"
	direction = player.aim_direction

func _on_area_2d_area_entered(area):
	var areaParent = area.get_parent()
	if areaParent is Enemy || areaParent is Bubble_Green || areaParent is Potion_Green:
		sfx_pop.play()
		destroy_bubble()
