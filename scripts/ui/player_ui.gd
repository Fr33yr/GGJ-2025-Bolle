extends Control

@onready var player = $"../../Player"
@onready var life_ui_container = $HBoxContainer
@onready var count_downlabel = $Time
@onready var countdown_timer = $CountdownTimer

var hp_system : HP_System

# Called when the node enters the scene tree for the first time.
func _ready():
	hp_system = player.get_node("HP_System")
	hp_system.damage_taken.connect(lost_a_life)
	hp_system.hp_restored.connect(add_a_life)
	countdown_timer.timeout.connect(_on_countdown_timeout)
	update_countdown_label()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_countdown_label()

func lost_a_life(damage: int):
	var last_child: TextureRect = life_ui_container.get_child(hp_system.hp_current-1)
	last_child.visible = false
	
func add_a_life(restored_points: int):
	var last_child: TextureRect = life_ui_container.get_child(hp_system.hp_current-2)
	last_child.visible = true
	
func _on_countdown_timeout():
	get_tree().change_scene_to_file(Paths.VICTORY)

func update_countdown_label(): # Updates time label, time in seconds
	count_downlabel.text = "TIME " + str(int(countdown_timer.time_left)) 
