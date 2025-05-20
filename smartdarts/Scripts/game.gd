extends Node
@export var target_scene: PackedScene

var target_spawn_positions = []
var target_number = 0
var targets_column = 2
var targets_row = 2
var player_in = false


var number_of_hit = 0 # number of hit for a target
var N_HIT_MAX = 5 # to tune 
var window_size = Vector2(0,0)
signal hitted
signal missed 

func save_game():
	var file_name =  $Player.ai_controller.heuristic + "_trace_" +  str(targets_row) + "x" + str(targets_column) + "_"  + str(N_HIT_MAX) + "h" + Time.get_datetime_string_from_system(true) + ".log"
	var saving_file = FileAccess.open("res://logs/" + file_name, FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("game_trace")
	print("saving file ")
	for i in save_nodes:
		
		var node_data = i.call("save");
		#print('node data ', node_data)
		var json_string = JSON.stringify(node_data)
		saving_file.store_line(json_string)
	saving_file.close()
	


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.use_accumulated_input = false
	#Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	start_episode()
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print("player position process ", $Player.position)
	pass 
	
	
func start_episode():
	print("start ep ! ")
	window_size = get_viewport().size

	#print("windows size : ", window_size.x / targets_column)
	var y_target_iter =  (window_size.x) / (targets_column + 1)
	var x_target_iter =  (window_size.y) / (targets_row  + 1 )
	#print("y_target_size : ", y_target_iter)
	for i in range(targets_column):
		for j in range(targets_column):
			target_spawn_positions.append(Vector2(y_target_iter*(j + 1), x_target_iter*(i+1)))
	target_number = 0
	var target_pose = target_spawn_positions[target_number]
	$Target.spawn(target_pose)
	spawn_player(true)
	$Player.target_position = target_pose
	
#func _on_start_timer_timeout() -> void: # Replace with function body.
	#start_episode()
	
func _on_player_hit() -> void:
	var start_episode : bool
	
	if player_in: 

		number_of_hit += 1 
		#print("hitted ! ", number_of_hit)
		hitted.emit()
		start_episode = false
		if number_of_hit >= N_HIT_MAX:
			#print("number of hit > to hit max")
			target_number = (target_number + 1) 
			if target_number == targets_column * targets_row:
				gameover()
				start_episode = true
			#print("spawning targets ")
			$Target.spawn(target_spawn_positions[target_number%(targets_column * targets_row)])
			$Player.target_position = target_spawn_positions[target_number%(targets_column * targets_row)]
			number_of_hit = 0
		spawn_player(start_episode)
	else: 
		#print("target missed ! ")
		missed.emit()
	
		
func _on_target_player_in() -> void:
	player_in = true
	
func _on_target_player_out() -> void:
	player_in = false # Replace with function body.

func spawn_player(start): 
	var start_position = Vector2(randi_range(0, window_size.x - 50), randi_range(0, window_size.y - 50))
	
	#print("ai controller on spawn", $Player.ai_controller.heuristic)
	#print("is player ",IS_PLAYER)
	
	if $Player.ai_controller.heuristic == "human":
		$Player.spawning = true
		print("Game script warping mouse ")
		Input.warp_mouse(start_position)
		$Player.start(start_position)
		#$Player.start(start_position)
		#print("starting ? ", start)
		if start:
			$Player.start(start_position)
			start = false
	else:
		$Player.start(start_position)
	#$Player.position = start_position
	
	#print("player position = ", $Player.position)
	#print("start position = ", start_position)
	#$Player.warping_mouse = false


func _on_hitted() -> void:
	$Player.ai_controller.reward += 1
	

func _on_missed() -> void:
	$Player.ai_controller.reward -= 0

func gameover():
	save_game()
	print("Game ends ! ")
	if $Player.ai_controller.heuristic == "human":
		get_tree().quit()
	target_number = 0
	$Player.reset()
	#$Player.ai_controller.need_reset = true
	#$Player.ai_controller.done = true


func _on_global_ep_timer_timeout() -> void:
	gameover()
