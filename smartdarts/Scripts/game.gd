extends Node
@export var target_scene: PackedScene

var target_spawn_positions = []
var target_number = 0
var targets_column = 2
var targets_row = 2
var player_in = false

var reward_gathered = 0

var number_of_hit = 0 # number of hit for a target
var N_HIT_MAX = 5 # to tune 
var window_size = Vector2(0,0)
var time_to_reach_target = 0
signal hitted
signal missed 

func save_game():
	var file_name =  $Player.ai_controller.heuristic + "_trace_" +  str(targets_row) + "x" + str(targets_column) + "_"  + str(N_HIT_MAX) + "h" + Time.get_datetime_string_from_system(true) + ".log"
	var saving_file = FileAccess.open("res://logs/" + file_name, FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("game_trace")
	print("saving file ")
	for i in save_nodes:
		var node_data = i.call("save");
		var json_string = JSON.stringify(node_data)
		saving_file.store_line(json_string)
	saving_file.close()
	
func _ready() -> void:
	Input.use_accumulated_input = false
	#Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	#Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	start_episode()
	
func _process(delta: float) -> void:
	time_to_reach_target += 1 
	
	
func start_episode():
	window_size = get_viewport().size
	var y_target_iter =  (window_size.x) / (targets_column + 1)
	var x_target_iter =  (window_size.y) / (targets_row  + 1 )
	set_player_hit_and_target_num()
	for i in range(targets_column):
		for j in range(targets_column):
			target_spawn_positions.append(Vector2(y_target_iter*(j + 1), x_target_iter*(i+1)))
	target_number = 0
	number_of_hit = 0
	var target_pose = target_spawn_positions[target_number]
	$Target.spawn(target_pose)
	spawn_player(true)
	$Player.target_position = target_pose
	
		
func _on_player_hit() -> void:
	var start_episode : bool
	
	if player_in: 
		number_of_hit += 1 
		hitted.emit()
		start_episode = false
		if number_of_hit >= N_HIT_MAX:
			target_number = (target_number + 1)
			if target_number == targets_column * targets_row:
				gameover()
				start_episode = true
			target_number = target_number  % (targets_column * targets_row)
			$Target.spawn(target_spawn_positions[target_number])
			$Player.target_position = target_spawn_positions[target_number]
			number_of_hit = 0
		spawn_player(start_episode)
	else: 
		missed.emit()
	
		
func _on_target_player_in() -> void:
	player_in = true
	
func _on_target_player_out() -> void:
	player_in = false # Replace with function body.

func spawn_player(start): 
	var start_position = Vector2(randi_range(0, window_size.x - 50), randi_range(0, window_size.y - 50))
	#print("ar we wtarting ? ", start)
	set_player_hit_and_target_num()
	if $Player.ai_controller.heuristic == "human":
		Input.warp_mouse(start_position)
		$Player.start(start_position)
		if start:
			$Player.start(start_position)
			#print("Game script warping mouse, starting :  ", start_position)
			start = false
	else:
		$Player.start(start_position)


func _on_hitted() -> void:
	
	print("hitted n : ",number_of_hit)
	if $Player.ai_controller.heuristic != "human":
		time_to_reach_target *= 0.064 # Speedup x dt ( 8 * 0.008)
	else:
		time_to_reach_target *= 0.008
	$Player.ai_controller.reward += exp(-0.1*time_to_reach_target)
	reward_gathered += exp(-0.1*time_to_reach_target) 
	time_to_reach_target = 0
	

func _on_missed() -> void:
	
	$Player.ai_controller.reward -= 0

func gameover():
	print("game over ! ")
	if $Player.ai_controller.heuristic == "human":
		save_game()
		print("gathered reward  : ", $Player.ai_controller.reward)
		#get_tree().quit()
	else: 
		$Player.ai_controller.done = true
	#print("gathered reward  : ", reward_gathered)
	target_number = 0
	#$Player.reset()
	start_episode()

func set_player_hit_and_target_num() -> void:
	$Player.hit_number = number_of_hit
	$Player.target_number = target_number
	


func _on_player_reset_game() -> void:
	start_episode()
