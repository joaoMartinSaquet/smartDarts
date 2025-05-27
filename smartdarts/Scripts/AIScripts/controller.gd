extends AIController2D
# Stores the action sampled for the agent's policy, running in python
var move_action  = Vector2(0, 0)
var click_action = false

func get_obs() -> Dictionary:
	"observation are the target position and the player position"
	
	# get the balls position and velocity in the paddle's frame of reference
	var target_pos = _player.target_position
	var player_pos = _player.global_position
	var obs = [target_pos.x, target_pos.y, player_pos.x, player_pos.y]
	#print("obs ", obs)
	return {"obs":obs}

func get_reward() -> float:
	return reward

func get_action_space() -> Dictionary:
	return {
			"move_action" : {
				"size": 2,
				"action_type": "continuous"
			},
			"click_action" : {
				"size" : 1,
				"action_type" : "discrete"
			}
		}

func set_action(action) -> void:
	#move_action = clamp(action.move_action, -_player.MAX_DISPLACEMENT, _player.MAX_DISPLACEMENT)
	#print("here !set actioin ", aéction)
	move_action = Vector2(action["move_action"][0], action["move_action"][1])
	click_action = action["click_action"]
