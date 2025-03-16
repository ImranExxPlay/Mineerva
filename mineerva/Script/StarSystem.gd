extends Node3D

var has_coordinate = false  # Does this star have a clue?
var coordinate_piece = ""   # The clue it holds (e.g., "X: 34")

func _ready():
	# Randomly decide if this star has a coordinate (e.g., 20% chance)
	if randf() < 0.2:
		has_coordinate = true
		# Randomly assign X, Y, or Z with a value
		var axis = ["X", "Y", "Z"][randi() % 3]
		var value = randi_range(0, Global.galaxy_size / 10)
		coordinate_piece = axis + ": " + str(value)
