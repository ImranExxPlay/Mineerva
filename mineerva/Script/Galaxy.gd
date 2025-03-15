extends Node3D  # Use Node3D in Godot 4 instead of Spatial

var star_system_scene = preload("res://Scenes/StarSystem.tscn")
var player_ship

func _ready():
	# Ensure player_ship is correctly assigned
	player_ship = $PlayerShip
	if not player_ship:
		print("Error: PlayerShip not found!")
		return
	
	# Generate star systems
	for i in range(Global.galaxy_size):
		var star = star_system_scene.instantiate()
		add_child(star)
		star.position = Vector3(randf_range(-Global.galaxy_size / 10, Global.galaxy_size / 10), randf_range(-Global.galaxy_size / 10, Global.galaxy_size / 10), randf_range(-Global.galaxy_size / 10, Global.galaxy_size / 10))
		star.get_node(".").visible = false

func _process(delta):
	# Loop only through star systems, excluding non-spatial nodes
	for star in get_children():
		if star == player_ship or not star is Node3D:  # Skip player_ship and non-Node3D nodes
			continue
		var distance = player_ship.position.distance_to(star.position)
		if distance < 5:
			star.get_node(".").visible = true
