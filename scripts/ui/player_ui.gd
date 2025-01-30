extends Control

@onready var player = $"../../Player"
@onready var life_ui_container = $HBoxContainer
@onready var count_downlabel = $Time
@onready var countdown_timer = $CountdownTimer

var hp_system : Node

# Called when the node enters the scene tree for the first time.
func _ready():
	hp_system = player.get_node("HP_System")
	hp_system.damage_taken.connect(lost_a_life)	
	countdown_timer.timeout.connect(_on_countdown_timeout)
	update_countdown_label()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_countdown_label()

func lost_a_life(current_hp):
	var last_child = life_ui_container.get_child(life_ui_container.get_child_count()-1)
	life_ui_container.remove_child(last_child)
	
func _on_countdown_timeout():
	get_tree().change_scene_to_file(Paths.VICTORY)

func update_countdown_label(): # Updates time label, time in seconds
	count_downlabel.text = "TIME " + str(int(countdown_timer.time_left)) 
