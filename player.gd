extends CharacterBody3D

var speed = 5.0
var resources = 0  # Inventaire pour stocker les ressources

func _physics_process(delta):
	# Mouvement existant
	var input_dir = Vector2.ZERO
	if Input.is_action_pressed("up"):
		input_dir.y -= 1
	if Input.is_action_pressed("down"):
		input_dir.y += 1
	if Input.is_action_pressed("left"):
		input_dir.x -= 1
	if Input.is_action_pressed("right"):
		input_dir.x += 1
	
	input_dir = input_dir.normalized()
	var direction = Vector3(input_dir.x, 0, input_dir.y)
	
	velocity = direction * speed
	move_and_slide()

func add_resources(amount):
	resources += amount
	print("Resources:", resources)  # Débogage temporaire
