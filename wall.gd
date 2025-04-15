extends StaticBody3D

var is_destroyed = false
var original_position = Vector3()

func _ready():
	# Sauvegarder la position initiale du mur
	original_position = global_transform.origin

func _process(delta):
	# Détecter l'action pour casser
	if Input.is_action_just_pressed("destroy_wall") and not is_destroyed:
		destroy_wall()
	
	# Détecter l'action pour reposer
	if Input.is_action_just_pressed("rebuild_wall") and is_destroyed:
		rebuild_wall()

func destroy_wall():
	# Cacher le mur et désactiver la collision
	hide()  # Cache le MeshInstance3D
	$WallCollision.disabled = true  # Désactive la collision
	is_destroyed = true

func rebuild_wall():
	# Réafficher le mur et réactiver la collision
	show()  # Réaffiche le MeshInstance3D
	$WallCollision.disabled = false  # Réactive la collision
	global_transform.origin = original_position  # Repositionne au cas où
	is_destroyed = false
