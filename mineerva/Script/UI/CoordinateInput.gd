extends Control


func _on_go_pressed() -> void:
	var x = float($XInput.text) if $XInput.text != "" else 0.0
	var y = float($YInput.text) if $YInput.text != "" else 0.0
	var z = float($ZInput.text) if $ZInput.text != "" else 0.0
	var target_position = Vector3(x, y, z)
	# Move the player ship to the target position
	var galaxy = get_parent()
	if galaxy and galaxy.has_node("PlayerShip"):
		galaxy.get_node("PlayerShip").position = target_position
