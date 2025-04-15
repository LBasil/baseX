extends StaticBody3D

var is_destroyed = false
var original_position = Vector3()
@export var player: Node3D  # Référence au joueur
@export var interaction_distance = 3.0  # Distance max pour interagir (en unités)

func _ready():
	original_position = global_transform.origin

func _process(delta):
	if not player:
		print("Player not assigned!")
		return
	
	# Calculer la distance entre le mur et le joueur
	var distance_to_player = global_transform.origin.distance_to(player.global_transform.origin)
	
	# Casser le mur si assez près
	if Input.is_action_just_pressed("destroy_wall") and not is_destroyed and distance_to_player < interaction_distance:
		destroy_wall()
	
	# Reconstruire le mur si assez près
	if Input.is_action_just_pressed("rebuild_wall") and is_destroyed and distance_to_player < interaction_distance:
		rebuild_wall()

func destroy_wall():
	hide()
	$WallCollision.disabled = true
	is_destroyed = true
	print("Wall destroyed!")

func rebuild_wall():
	show()
	$WallCollision.disabled = false
	global_transform.origin = original_position
	is_destroyed = false
	print("Wall rebuilt!")
