extends Node3D

var star_system_scene = preload("res://Scenes/StarSystem.tscn")
var player_ship
var stars = []  # Array to hold all star system nodes
var cordinate_screen_visible = false

func _ready():
	player_ship = $PlayerShip
	if not player_ship:
		print("Error: PlayerShip not found!")
		return
	for i in range(Global.galaxy_size):
		var star = star_system_scene.instantiate()
		add_child(star)
		star.position = Vector3(randf_range(-Global.galaxy_size / 10, Global.galaxy_size / 10), randf_range(-Global.galaxy_size / 10, Global.galaxy_size / 10), randf_range(-Global.galaxy_size / 10, Global.galaxy_size / 10))
		star.get_node(".").visible = false
		stars.append(star)  # Add the star to our array

func _process(delta):
	for star in stars:  # Loop only over star systems
		var distance = player_ship.position.distance_to(star.position)
		if distance < 5:
			star.get_node(".").visible = true
			if star.has_coordinate:
				print("Collected: ", star.coordinate_piece)
				star.has_coordinate = false

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("cordinates_screen") and cordinate_screen_visible == false:
		$CoordinateInput.visible = true
	if Input.is_action_just_pressed("cordinates_screen") and cordinate_screen_visible == true:
		$CoordinateInput.visible = false
