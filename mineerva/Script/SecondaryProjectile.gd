extends Node3D

var speed = 15.0  # Slower but powerful
var lifetime = 3.0  # Lasts longer than primary

func _ready():
	$MeshInstance3D.mesh.material = StandardMaterial3D.new()
	$MeshInstance3D.mesh.material.albedo_color = Color.YELLOW

func _process(delta):
	position -= transform.basis.z * speed * delta
	lifetime -= delta
	if lifetime <= 0:
		queue_free()
