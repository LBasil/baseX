extends StaticBody3D

var is_destroyed = false
var original_position = Vector3()
@export var player: Node3D
@export var interaction_distance = 3.0
@export var camera: Camera3D
@export var aim_tolerance = 3.0

func _ready():
	original_position = global_transform.origin
	set_collision_layer_value(1, true)
	set_collision_mask_value(1, true)

func _process(delta):
	if not player or not camera:
		return
	
	var distance_to_player = global_transform.origin.distance_to(player.global_transform.origin)
	var is_aimed = is_aimed_by_mouse()
	
	if Input.is_action_just_pressed("destroy_wall") and not is_destroyed and distance_to_player < interaction_distance and is_aimed:
		destroy_wall()
	
	if Input.is_action_just_pressed("rebuild_wall") and is_destroyed and distance_to_player < interaction_distance and is_aimed:
		rebuild_wall()

func is_aimed_by_mouse() -> bool:
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_direction = camera.project_ray_normal(mouse_pos)
	var ray_end = ray_origin + ray_direction * 100.0
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	query.collide_with_areas = false
	query.collide_with_bodies = true
	query.collision_mask = 1
	var result = space_state.intersect_ray(query)
	
	if not is_destroyed:
		if result and result.collider == self:
			return true
	else:
		if result:
			var hit_point = result.position
			var distance_to_original = hit_point.distance_to(original_position)
			if distance_to_original < aim_tolerance:
				return true
	return false

func destroy_wall():
	hide()
	$WallCollision.disabled = true
	is_destroyed = true
	player.add_resources(1)  # Donne 1 ressource au joueur

func rebuild_wall():
	if player.resources >= 1:  # Nécessite 1 ressource
		show()
		$WallCollision.disabled = false
		global_transform.origin = original_position
		is_destroyed = false
		player.resources -= 1  # Consomme 1 ressource
		print("Wall rebuilt, resources left:", player.resources)
