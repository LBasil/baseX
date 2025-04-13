extends Camera3D

@export var target: Node3D  # Le nœud à suivre (le Player)
@export var offset = Vector3(0, 5, 5)  # Décalage par rapport au joueur

func _physics_process(delta):
	if target:
		# Positionne la caméra au joueur + décalage
		global_transform.origin = target.global_transform.origin + offset
