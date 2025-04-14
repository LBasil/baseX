extends CharacterBody3D

@export var speed = 5.0
@export var acceleration = 10.0

# Synchroniser la position et la rotation
@onready var sync_position = position
@onready var sync_rotation = rotation

func _ready():
	# Définir l’autorité réseau (le client qui contrôle ce joueur)
	if multiplayer.get_unique_id() == get_multiplayer_authority():
		set_process(true)
	else:
		set_process(false)

func _physics_process(delta):
	# Traiter les inputs seulement pour le joueur local
	if multiplayer.get_unique_id() == get_multiplayer_authority():
		var input_vector = Vector2.ZERO
		input_vector.x = Input.get_axis("left", "right")
		input_vector.y = Input.get_axis("up", "down")
		
		if input_vector.length() > 1.0:
			input_vector = input_vector.normalized()
		
		var direction = Vector3(input_vector.x, 0, input_vector.y).normalized()
		
		if direction:
			velocity.x = lerp(velocity.x, direction.x * speed, acceleration * delta)
			velocity.z = lerp(velocity.z, direction.z * speed, acceleration * delta)
			if velocity.length() > 0.1:
				rotation.y = lerp_angle(rotation.y, atan2(velocity.x, velocity.z), 10.0 * delta)
		else:
			velocity.x = lerp(velocity.x, 0.0, acceleration * delta)
			velocity.z = lerp(velocity.z, 0.0, acceleration * delta)
		
		if not is_on_floor():
			velocity.y -= 9.8 * delta
		
		move_and_slide()
		
		# Mettre à jour les variables synchronisées
		sync_position = position
		sync_rotation = rotation
		# Envoyer au serveur
		rpc("update_position", sync_position, sync_rotation)

# RPC pour synchroniser la position et la rotation
@rpc("any_peer", "call_remote")
func update_position(pos, rot):
	if multiplayer.get_unique_id() != get_multiplayer_authority():
		sync_position = pos
		sync_rotation = rot
		position = sync_position
		rotation = sync_rotation
