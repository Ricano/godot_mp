extends Control


onready var player_health = $PlayerContainer/HealthContainer/PlayerHealthStat
onready var enemy_health = $EnemyContainer/HealthContainer/EnemyHealthStat


# Called when the node enters the scene tree for the first time.
func _ready():
	player_health.text = str(get_parent().get_node("Player").health)
	enemy_health.text = str(get_parent().get_node("Borone").health)
	pass # Replace with function body.


func _process(delta):
	
	pass


func _on_Player_was_hitted(damage):
	player_health.text = str(get_parent().get_node("Player").health)
	


func _on_Borone_was_hitted(damage):
	enemy_health.text = str(get_parent().get_node("Borone").health)
	
