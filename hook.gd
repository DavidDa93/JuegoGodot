extends Node2D

signal hooked(hooked_position)

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var ray_cast_2d: RayCast2D = $RayCast2D

var distance: float = 150

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func interpolate(length: float, duration: float) -> void:
	var tween_offset: Tween = get_tree().create_tween()
	var tween_rect: Tween = get_tree().create_tween()
	
	tween_offset.tween_property(sprite_2d, "offset", Vector2(0, length/2.0), duration)
	tween_rect.tween_property(sprite_2d, "region_rect", Rect2(0, 0,6, length), duration)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("hook"):
		interpolate(await check_distance(), 0.2)
		await get_tree().create_timer(0.2).timeout
		reverse_interpolate()


func reverse_interpolate() -> void:
	interpolate(0, 0.75)


func check_distance() -> float:
	await get_tree().create_timer(0.1).timeout
	var collision_point: Vector2
	if ray_cast_2d.is_colliding():
		collision_point = ray_cast_2d.get_collision_point()
		distance = (global_position - collision_point).length()
		hooked.emit(collision_point)
	else:
		distance = 300.0
	return distance
