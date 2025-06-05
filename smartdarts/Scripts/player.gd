extends CharacterBody2D

const SPEED = 6000.0
const SKEW_SPEED = 2  # 0.2 deg/s
const MAX_SKEW = 2
var target_position = Vector2(0, 0)
var MAX_DISPLACEMENT = 80	
var over = false
var reward = 0

var time = [0]

var poss_x = []
var poss_y = []
var disp_x = []
var disp_y = []
var clicks = []
var targets_x = []
var targets_y = []

var hit_number = 0
var target_number = 0

var targets_ns = []
var hit_ns = []


@onready var ai_controller = $AIController2D

signal hit
signal reset_game

func _ready() -> void:
	#show()
	ai_controller.init(self)
	ai_controller.reset_after = 1e4
	ai_controller.reward = 0
	print("Player starting positions ! 	", position)
	
func game_over():
	print("player game over ! ")
	if ai_controller.heuristic == "human":
		hide()
	ai_controller.done = true
	#ai_controller.needs_reset = true

	
func _input(event: InputEvent) -> void:
	if ai_controller.heuristic == "human":
		clicks.append(false)
		if Input.is_action_just_pressed("hit_target"):
			clicks.append(true)
			hit.emit() 
		if event is InputEventMouseMotion:
				#print("time : ", Time.get_ticks_msec())
			var disp = event.position - position
			position = event.position
			poss_x.append(position.x)
			poss_y.append(position.y)
			disp_x.append(disp.x)
			disp_y.append(disp.y)
			time.append(Time.get_ticks_usec())
			targets_x.append(target_position.x)
			targets_y.append(target_position.y)

	return
		
func _process(delta: float) -> void:
	time.append(delta + time[0])
	var window_size = get_viewport().size
	#print("windows size ?", window_size)
	#print("player position ? ", position)
	if position.x > window_size.x or position.x < 0 or  position.y > window_size.y or position.y < 0:
		#print("out of bonds")
		if RenderingServer.render_loop_enabled != true:
				ai_controller.reward += -0.0001
		else:
			ai_controller.reward += -0.01
		#ai_controller.reward += 0.0		
		#ai_controller.done = true
		#ai_controller.needs_reset = true
		#reset_game.emit()
		
	
func _physics_process(_delta: float) -> void:
	var movement : Vector2
	#print("ai reward ", ai_controller.reward)
	if ai_controller.needs_reset and ai_controller.heuristic != "human":
		ai_controller.reset()
		reset_game.emit()

	#print("ai controller in player script",  ai_controller.heuristic)
	if ai_controller.heuristic == "human":
		pass # in this case this one is made by eery time an input is detected
	else:
		if ai_controller.click_action:
				hit.emit()
				clicks.append(true)
		else: 
			clicks.append(false)
		movement = ai_controller.move_action
		position += movement
		poss_x.append(position.x)
		poss_y.append(position.y)
		disp_x.append(movement.x)
		disp_y.append(movement.y)
		time.append(Time.get_ticks_usec())
		targets_x.append(target_position.x)
		targets_y.append(target_position.y)
		hit_ns.append(hit_number)
		targets_ns.append(target_number)
	
func start(pose):
	#print("Player pos ")
	position = pose
	show()

func save():
	var save_dict = {"pos_x" : poss_x, 
					"pos_y" : poss_y, 
					"clicks" : clicks,
					'disp_x' : disp_x,
					'disp_y' : disp_y,
					'target_x' : targets_x,
					'target_y' : targets_y,
					'targets_numbers' : targets_ns,
					'hit_number' : hit_ns,
					'time' : time}
	return save_dict

func reset():
	game_over()
