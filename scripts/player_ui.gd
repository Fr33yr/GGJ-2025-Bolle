extends Control

@onready var player = $"../../Player"
@onready var life_ui_container = $HBoxContainer
var hp_system : Node

# Called when the node enters the scene tree for the first time.
func _ready():
	hp_system = player.get_node("HP_System")
	hp_system.damage_taken.connect(lost_a_life)	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func lost_a_life(current_hp):
	var last_child = life_ui_container.get_child(life_ui_container.get_child_count()-1)
	life_ui_container.remove_child(last_child)
