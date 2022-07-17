extends Node


remote func provide_skill_damage(skill_name, player_id):
	var basic_skill_damage = ServerGameData.data[skill_name].Damage
	var player = get_node("../" + str(player_id))
	var player_level = player.player_stats.level
	var total_damage = basic_skill_damage * player_level
	return  total_damage


