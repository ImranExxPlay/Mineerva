extends Button




func _on_pressed() -> void:
	if ShipStats.crew > ShipStats.crew_assigned:
		ShipStats.crew_assigned += 1
		print("Crew assigned to repairs: ", ShipStats.crew_assigned)
		visible = false  # Hide button after assignment
