extends Node3D

# Variables for movement
var speed = 5.0  # How fast the ship moves (units per second)

# Variables for camera rotation (keeping your existing setup)
var camera_sensitivity = 0.005
var yaw = 0.0
var pitch = 0.0
var max_pitch = deg_to_rad(50)  # Up/down limit: ±80 degrees
var max_yaw = deg_to_rad(50)    # Left/right limit: ±90 degrees
var can_rotate = true

# Variables for primary fire
var projectile_scene = preload("res://Scenes/Projectile.tscn")
var fire_rate = 0.1  # Seconds between shots
var fire_timer = 0.0  # Tracks time since last shot

# Variables for secondary fire
var secondary_projectile_scene = preload("res://Scenes/SecondaryProjectile.tscn")
var secondary_cooldown = 1.0  # 1 second between shots
var secondary_timer = 0.0    # Tracks cooldown

var can_shoot = true

# Damage alert variables
var alert_timer = 0.0  # How long the alert shows
var alert_duration = 2.0  # 2 seconds

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	# Adjusted speed and fire rate based on crew
	var speed = ShipStats.base_speed * (1.0 + ShipStats.crew_assigned_engines * 0.5)  # +50% per crew
	var fire_rate = ShipStats.base_fire_rate / (1.0 + ShipStats.crew_assigned_weapons * 0.5)  # Faster fire
	var fire_timer = 0.0  # Reset each frame (local var)
	
	# Movement with WASD
	var direction = Vector3.ZERO
	if Input.is_action_pressed("move_forward"):  # W
		direction.z -= 1
	if Input.is_action_pressed("move_backward"):  # S
		direction.z += 1
	if Input.is_action_pressed("move_left"):  # A
		direction.x -= 1
	if Input.is_action_pressed("move_right"):  # D
		direction.x += 1

	# Normalize direction to keep speed consistent diagonally
	if direction.length() > 0:
		direction = direction.normalized() * speed * delta
		position += direction
		
	# Primary fire
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and can_shoot:
		fire_timer -= delta
		if fire_timer <= 0:
			fire_projectile()
			fire_timer = fire_rate
			
	elif Input.is_action_pressed("fire_secondary") and secondary_timer <= 0:
		fire_secondary_projectile()
		secondary_timer = secondary_cooldown
		
	secondary_timer -= delta
	
	# Test damage with a key (e.g., Space)
	if Input.is_action_just_pressed("ui_accept"):
		take_damage(20.0)
		
	# Update alert timer
	if alert_timer > 0:
		alert_timer -= delta
		if alert_timer <= 0:
			hide_alert()
	
	# Repair shields if crew is assigned
	if ShipStats.crew_assigned_repairs > 0 and ShipStats.shields < ShipStats.max_shields:
		ShipStats.shields += ShipStats.repair_rate * delta
		if ShipStats.shields > ShipStats.max_shields:
			ShipStats.shields = ShipStats.max_shields
			
	if ShipStats.crew_assigned_repairs >  0:
		show_alert("Repairing... (" + str(ShipStats.shields) + "%)")
	
func _input(event):
	if event is InputEventMouseMotion and can_rotate:
		yaw -= event.relative.x * camera_sensitivity
		pitch -= event.relative.y * camera_sensitivity
		# Clamp both pitch and yaw
		pitch = clamp(pitch, -max_pitch, max_pitch)
		yaw = clamp(yaw, -max_yaw, max_yaw)
		var camera = $Camera3D
		if camera:
			camera.rotation = Vector3(pitch, yaw, 0)
	if event.is_action_pressed("cancel_cursor") and can_rotate:  # Esc to exit
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		can_rotate = false
		can_shoot = false
	elif event.is_action_pressed("cancel_cursor") and can_rotate == false:  # Esc to exit
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		can_rotate = true
		can_shoot = true

	# Secondary fire on right-click

func fire_projectile():
	var projectile = projectile_scene.instantiate()
	get_parent().add_child(projectile)  # Add to Galaxy scene, not PlayerShip
	projectile.position = position - $Camera3D.transform.basis.z * 1.0  # Move 1 unit forward
	projectile.rotation = $Camera3D.rotation

func fire_secondary_projectile():
	var projectile = secondary_projectile_scene.instantiate()
	get_parent().add_child(projectile)
	projectile.position = position
	projectile.rotation = $Camera3D.rotation
	
func take_damage(amount):
	ShipStats.shields -= amount
	if ShipStats.shields < 0:
		ShipStats.shields = 0
	show_alert("Shields Damaged! (" + str(ShipStats.shields) + "%)")
	var repair_button = get_parent().get_node("RepairUI/RepairButton")
	if repair_button and ShipStats.crew > ShipStats.crew_assigned_repairs:
		repair_button.visible = true
	# Show crew UI
	var crew_ui = get_parent().get_node("CrewUI")
	if crew_ui:
		crew_ui.update_visibility()

func show_alert(message):
	var alert = get_parent().get_node("DamageUI/DamageLabel")
	if alert:
		alert.text = message
		alert.visible = true
		alert_timer = alert_duration

func hide_alert():
	var alert = get_parent().get_node("DamageUI/DamageLabel")
	if alert:
		alert.visible = false
