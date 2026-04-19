extends CharacterBody2D

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var grappling_hook: Node2D = $GrapplingHook

var direction: int = 1
var is_hooking: bool
var gravity: float = 980.0

const SPEED = 600.0
const JUMP_VELOCITY = -400.0


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	handle_movement(delta)
	handle_gravity(delta)
	#handle_raycast()


func handle_movement(delta: float) -> void:
	if not is_hooking:
		var move_direction = Input.get_vector("left", "right", "up", "down")
		position += move_direction * SPEED * delta
	
		move_and_slide()
	elif is_hooking:
		pass


func handle_gravity(delta: float) -> void:
	if not is_hooking:
		velocity.y += gravity * delta
	else:
		velocity.y = 0


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("hook"):
		grappling_hook.look_at(get_global_mouse_position())


func _on_grappling_hook_hooked(hooked_position: Variant) -> void:
	var tween = get_tree().create_tween()
	await tween.tween_property(self, "position", hooked_position, 0.5)
	is_hooking = true


#func handle_raycast() -> void:
	#ray_cast_2d.look_at(get_global_mouse_position())
	#if ray_cast_2d.is_colliding() && Input.is_action_pressed("hook"):
		#var hook_point = ray_cast_2d.get_collision_point()
		#is_hooking = true
		#move_to_point(hook_point)
#
#
#func move_to_point(hook_point: Vector2) -> void:
	#var hook_dir = (hook_point - global_position).normalized()
	#velocity = hook_dir * 300
	#
	#if global_position.distance_to(hook_point) < 30:
		#is_hooking = false
		#velocity = Vector2.ZERO
