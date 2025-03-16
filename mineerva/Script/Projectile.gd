extends Node3D

var speed = 20.0  # Speed of the projectile (units per second)
var lifetime = 2.0  # How long it lasts before disappearing (seconds)

func _process(delta):
	# Move forward (negative Z in Godot’s 3D space)
	position -= transform.basis.z * speed * delta
	lifetime -= delta
	if lifetime <= 0:
		queue_free()  # Remove the projectile after its lifetime
