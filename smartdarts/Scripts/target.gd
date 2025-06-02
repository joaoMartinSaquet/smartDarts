extends StaticBody2D

var poss_x = [];
var poss_y = [];

signal player_in
signal player_out

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide() # Replace with function body.

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()

func _on_area_2d_body_entered(_body: Node2D) -> void:
	player_in.emit()
	
func _on_area_2d_body_exited(_body: Node2D) -> void:
	player_out.emit()
	
func spawn(pose):
	show()
	position = pose
	
func save():
	var save_dir = {"poss_x" : poss_x, "poss_y" : poss_y}
	return save_dir
