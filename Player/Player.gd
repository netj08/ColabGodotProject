extends CharacterBody3D

var distance_to_detach : float = 4.0
var pulling_strength : int = 4
var target = null
var is_holding_item = false
var canPickup = false
var team = 0
var throwStrength = 20
var crouching = false


@onready var camera = $Camera
@onready var raycast = $Camera/RayCast3D
@onready var marker = $Camera/RayCast3D/Marker3D

var SPEED = 5.0
const JUMP_VELOCITY = 8

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$Body.hide()
	$Camera/Head.hide()
	$Name.hide()

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * .005)
		camera.rotate_x(-event.relative.y * .005)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	if Input.is_action_just_pressed("throw"):throw()
	if Input.is_action_just_pressed("Crouch"):crouch()
	if Input.is_action_just_released("Crouch"):crouch()

	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("Left", "Right", "Up", "Down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
	if Input.is_action_just_pressed("pickup"):
		if raycast.is_colliding():
			if raycast.get_collider().get_node_or_null("canPickup"):
				target = raycast.get_collider()
	
	if Input.is_action_just_released("pickup"):
		if target is RigidBody3D:
			target = null
	
	if target != null:
		if target is RigidBody3D:
			var a = marker.global_transform.origin
			var b = target.global_transform.origin
			target.linear_velocity = (a - b) * pulling_strength
			if (a - b).x > distance_to_detach or (a - b).y > distance_to_detach or (a - b).z > distance_to_detach or (a - b).x < -distance_to_detach or (a - b).y < -distance_to_detach or (a - b).z < -distance_to_detach:
				target = null
		else:
			target = null
			
func throw():
	if target != null:
		var dir = -camera.global_transform.basis.z.normalized() * throwStrength + Vector3(0,2,0)
		target.apply_central_impulse(dir)
		target = null
		
func crouch():
	var collider = $BodyCollider
	var body = $Body 
	
	if crouching:
		SPEED = SPEED*2
		collider.scale.y = collider.scale.y * 2
		body.scale.y = body.scale.y * 2
		camera.position.y = camera.position.y + 0.25
		crouching = false
	else:
		SPEED = SPEED/2
		collider.scale.y = collider.scale.y/2
		body.scale.y = body.scale.y/2
		camera.position.y = camera.position.y - 0.25
		crouching = true
	
	
