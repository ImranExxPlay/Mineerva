extends Control

func _on_WeaponsButton_pressed():
	if ShipStats.crew > total_assigned():
		ShipStats.crew_assigned_weapons += 1
		print("Crew on Weapons: ", ShipStats.crew_assigned_weapons)
		update_visibility()

func _on_EnginesButton_pressed():
	if ShipStats.crew > total_assigned():
		ShipStats.crew_assigned_engines += 1
		print("Crew on Engines: ", ShipStats.crew_assigned_engines)
		update_visibility()

func _on_RepairsButton_pressed():
	if ShipStats.crew > total_assigned():
		ShipStats.crew_assigned_repairs += 1
		print("Crew on Repairs: ", ShipStats.crew_assigned_repairs)
		update_visibility()

func total_assigned():
	return ShipStats.crew_assigned_weapons + ShipStats.crew_assigned_engines + ShipStats.crew_assigned_repairs

func update_visibility():
	$WeaponsButton.visible = ShipStats.crew > total_assigned()
	$EnginesButton.visible = ShipStats.crew > total_assigned()
	$RepairsButton.visible = ShipStats.crew > total_assigned()
