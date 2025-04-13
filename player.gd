extends CharacterBody3D

# Vitesse et accélération du personnage
@export var speed = 5.0
@export var acceleration = 10.0

func _physics_process(delta):
	# Obtenir les entrées (pour tester avec clavier ou joystick plus tard)
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_axis("left", "right")
	input_vector.y = Input.get_axis("up", "down")
	
	# Normaliser pour éviter une vitesse excessive en diagonale
	if input_vector.length() > 1.0:
		input_vector = input_vector.normalized()
	
	# Convertir l'entrée 2D en mouvement 3D
	var direction = Vector3(input_vector.x, 0, input_vector.y).normalized()
	
	# Appliquer le mouvement
	if direction:
		velocity.x = lerp(velocity.x, direction.x * speed, acceleration * delta)
		velocity.z = lerp(velocity.z, direction.z * speed, acceleration * delta)
		# Faire pivoter le personnage dans la direction du mouvement
		if velocity.length() > 0.1:
			rotation.y = lerp_angle(rotation.y, atan2(velocity.x, velocity.z), 10.0 * delta)
	else:
		# Ralentir quand il n'y a pas d'entrée
		velocity.x = lerp(velocity.x, 0.0, acceleration * delta)
		velocity.z = lerp(velocity.z, 0.0, acceleration * delta)
	
	# Appliquer la gravité
	if not is_on_floor():
		velocity.y -= 9.8 * delta
	
	# Déplacer le personnage
	move_and_slide()
