extends Bubble

class_name Bubble_Purple

@onready var player: CharacterBody2D

func _ready():
	super()
	damage = 3


func _on_area_2d_area_entered(area):
	var areaParent = area.get_parent()
	if areaParent is Enemy:
		sfx_pop.play()
		destroy_bubble()
