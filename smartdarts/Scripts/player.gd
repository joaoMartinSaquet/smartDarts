extends CharacterBody2D

const SPEED = 6000.0
const SKEW_SPEED = 2  # 0.2 deg/s
const MAX_SKEW = 2
var target_position = Vector2(0, 0)
var MAX_DISPLACEMENT = 80	
var over = false
var reward = 0
var spawning = false

var time = [0]

var poss_x = []
var poss_y = []
var disp_x = []
var disp_y = []
var clicks = []
var targets_x = []
var targets_y = []

@onready var ai_controller = $AIController2D

signal hit

func _ready() -> void:
	#show()
	ai_controller.init(self)
	
func game_over():
	if ai_controller.heuristic == "human":
		hide()
	ai_controller.done = true
	ai_controller.needs_reset = true
	
	
func _input(event: InputEvent) -> void:
	if ai_controller.heuristic == "human":
		clicks.append(false)
		if Input.is_action_just_pressed("hit_target"):
			clicks.append(true)
			hit.emit() 
		if event is InputEventMouseMotion:
			#if event.button_index == 1 and event.pressed:
			#hit.emit()
			if not spawning:
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
				
			else:
				spawning = false
		#if event.pressed:
			
		# end log the relative displacement ! 
		return
		
func _process(delta: float) -> void:
	time.append(delta + time[0])
	#print("player position : ", position)



func _physics_process(delta: float) -> void:
	if ai_controller.needs_reset:
		ai_controller.reset()
	var movement : Vector2
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

	
func start(pose):
	print("start ! ")
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
					'time' : time}
	return save_dict

func reset():
	game_over()
