class_name MovementComponent2D
extends ComponentNode2D


#region Component Contracts
var velocity_influence: Vector2 = Vector2.ZERO # Used by parent entity to add influence
#endregion Component Contracts


#region Exports
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
signal movement_direction_changed(direction: Vector2) # Emitted when movement direction changes
#endregion Signals


#region Internal-Variables
var is_moving: bool = false # Flag to track if character is currently moving
var is_jumping: bool = false # Flag to track if character is currently jumping upward
#endregion Internal-Variables

## Called in the parent modular entity's _ready() function
func init_component(player_controlled:bool=false):
	_init_component(player_controlled)
	if gravity_use_default:
		gravity_force = ProjectSettings.get_setting("physics/2d/default_gravity")






func tick_physics(delta: float) -> void:
	#_tick_physics(delta)
	velocity_influence = calc_veloctiy_influence(delta)


func calc_veloctiy_influence(delta: float)->Vector2:
	var input_x_influence = Input.get_axis("ui_left", "ui_right")
	var movement = input_x_influence * delta
	return Vector2.ZERO






func calc_gravity_influence1(delta:float) -> Vector2:
	if not gravity_enabled:
		return Vector2.ZERO
	# TODO: Implement gravity calculation based on gravity_enabled flag
	# The calculation should consider:
	# - Current velocity and time delta
	# - Maximum falling speed limit
	# - Whether the character is jumping or falling
	var gravity_effect = Vector2.ZERO
	# TODO: Add actual gravity physics calculation here
	# This should accumulate downward force over time when falling
	# and reset when the character hits the ground using _entity.is_on_floor()
	return gravity_effect



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
