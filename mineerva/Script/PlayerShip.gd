extends Node3D


func _process(delta):
	if Input.is_action_pressed("ui_up"):
		position.z -= 0.1
	if Input.is_action_pressed("ui_down"):
		position.z += 0.1
	if Input.is_action_pressed("ui_left"):
		position.x -= 0.1
	if Input.is_action_pressed("ui_right"):
		position.x += 0.1
