class_name MovementComponent2D
extends ComponentNode2D


#region Component Contracts
var velocity_influence: Vector2 = Vector2.ZERO # Used by parent entity to add influence
#endregion Component Contracts


#region Exports
@export var max_speed: float = 400.0
@export var acceleration: float = 100.0
@export var friction: float = 50.0
@export_group("Jumping")
@export var canJump:bool = true
@export var jumpVelocity = 200
@export_subgroup("Continous Jump")
## Can hold and release jump for variable jump height
@export var canContinousJump:bool = false
@export var canContinousJumpLength:float = 0.5
@export var jumpVelocityContinous = 40
@export_group("Gravity")
@export var gravity_enabled: bool = true
@export var gravity_use_default: bool = true
@export var gravity_force: float = 500.0  # pixels/sec^2
@export var max_fall_speed: float = 1000.0
@export var gravity_multiplier: float = 1.0
#endregion Exports

#region Signals
#signal gravity_changed(new_gravity: float) # Emitted when gravity value changes
signal s_movement_direction_changed(direction: Vector2) # Emitted when movement direction changes
#endregion Signals


#region Internal-Variables
var is_moving: bool = false # Flag to track if character is currently moving
var is_jumping: bool = false # Flag to track if character is currently jumping upward
var target_position: Vector2 = Vector2.ZERO
var target_direction: Vector2 = Vector2.ZERO
#endregion Internal-Variables


## Called in the parent modular entity's _ready() function
func init_component(player_controlled:bool=false):
	_init_component(player_controlled)
	if gravity_use_default:
		gravity_force = ProjectSettings.get_setting("physics/2d/default_gravity")






func tick_physics(delta: float) -> void:
	velocity_influence = Vector2.ZERO
	if _player_controlled:
		var input_x_influence = Input.get_axis("ui_left", "ui_right")
		target_direction = Vector2(input_x_influence * 10000, 0)
		move_towards( Vector2(input_x_influence, 0), delta)
	else:
		move_towards(target_position, delta)
	apply_gravity(delta)
	#print("movement - velocity_influence: ", velocity_influence)


func apply_gravity(delta):
	velocity_influence.y += gravity_force * delta


#func move_towards_target(delta: float) -> void:
	#pass

func move_towards(target: Vector2, delta: float) -> void:
	#print("movement - moving toward: ", target)
	check_if_direction_changed(target)
	target_position = target
	velocity_influence.x = target.normalized().x * delta * max_speed
	if target == Vector2.ZERO:
		is_moving = false
	else:
		is_moving = true

func check_if_direction_changed(direction: Vector2) -> bool:
	if direction.x == 0:
		return false
	if direction.x > 0 and target_position.x > 0:
		return false
	elif direction.x < 0 and target_position.x < 0:
		return false
	s_movement_direction_changed.emit(direction)
	return true



func calc_gravity_influence(delta:float) -> Vector2:
	if not gravity_enabled:
		return Vector2.ZERO
	var gravity_effect = Vector2.ZERO
	# Apply gravitational force based on time delta and gravity strength
	gravity_effect.y += gravity_force * delta
	# Limit maximum falling speed
	if gravity_effect.y > max_fall_speed:
		gravity_effect.y = max_fall_speed
	return gravity_effect




#func get_project_gravity()->Vector2:
	#return ProjectSettings.get_setting("physics/2d/default_gravity_vector") * ProjectSettings.get_setting("physics/2d/default_gravity")





#
