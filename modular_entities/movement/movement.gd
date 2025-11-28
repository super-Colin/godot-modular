class_name MovementComponent2D
extends ComponentNode2D

var debug_string = "Movement - "

#region Component Contracts
var velocity_influence: Vector2 = Vector2.ZERO # Used by parent entity to add influence
#endregion Component Contracts


#region Exports
@export var max_speed: float = 400.0
@export var acceleration: float = 100.0
@export var friction: float = 500.0
@export_group("Jumping")
@export var can_jump:bool = true
@export var jump_velocity = 1000
#@export_subgroup("Continous Jump")
### Can hold and release jump for variable jump height
#@export var canContinousJump:bool = false
#@export var canContinousJumpLength:float = 0.5
#@export var jumpVelocityContinous = 40
@export_group("Flying")
@export var can_fly:bool = false
@export var always_flying:bool = false
@export var fly_velocity = 200
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
var target_global_position: Vector2 = Vector2.ZERO
var target_direction: Vector2 = Vector2.ZERO

#endregion Internal-Variables


func update_target(new_global_position):
	target_global_position = new_global_position
	print("movement - target updated: ", new_global_position)





## Called in the parent modular entity's _ready() function
func init_component(player_controlled:bool=false):
	_init_component(player_controlled)
	if gravity_use_default:
		gravity_force = ProjectSettings.get_setting("physics/2d/default_gravity")






func tick_physics(delta: float) -> void:
	velocity_influence = Vector2.ZERO
	is_moving = false
	var friction_influence = apply_friction(delta)
	if _player_controlled:
		var input_x_influence = Input.get_axis("ui_left", "ui_right")
		target_direction = Vector2(input_x_influence * 10000, 0)
		move_towards( Vector2(input_x_influence, 0), delta)
	else:
		move_towards_target(delta)
		#print($'.', " - moving toward: ", target_global_position)
	if needs_to_jump:
		jump()
	else:
		apply_gravity(delta)
	if not is_moving:
		velocity_influence += friction_influence
	#print("movement - velocity_influence: ", velocity_influence)


func apply_gravity(delta):
	velocity_influence.y += gravity_force * delta

func _turn_around():
	#_parent_modular_entity.facing_direction *= -1
	set_target_directly_in_front()

func _move_forward():
	set_target_directly_in_front()


func apply_friction(delta)->Vector2:
	var friction_influence = Vector2.ZERO
	if not _parent_modular_entity.velocity.x == 0:
		if _parent_modular_entity.velocity.x > 0:
			friction_influence.x -= friction * delta
		else:
			friction_influence.x += friction * delta
	return friction_influence


func move_towards_target(delta: float) -> void:
	if target_global_position == Vector2.ZERO:
		return
	move_towards($'.'.global_position - target_global_position, delta)

func set_target_directly_in_front():
	#target_global_position = _parent_modular_entity.get_facing_direction() * 500
	#target_global_position = _parent_modular_entity.global_position + (_parent_modular_entity.facing_direction * 200)
	target_global_position = _parent_modular_entity.global_position - (_parent_modular_entity.facing_direction * 200)

func move_towards(target: Vector2, delta: float) -> void:
	#print("movement - moving toward: ", target)
	check_if_direction_changed(target)
	#target_position = target
	velocity_influence.x = target.normalized().x * delta * max_speed
	if target == Vector2.ZERO:
		is_moving = false
	else:
		is_moving = true

func check_if_direction_changed(direction: Vector2) -> bool:
	if direction.x == 0:
		return false
	if direction.x > 0 and target_global_position.x > 0:
		return false
	elif direction.x < 0 and target_global_position.x < 0:
		return false
	s_movement_direction_changed.emit(direction)
	return true



func calc_gravity_influence(delta:float) -> Vector2:
	if not gravity_enabled:
		return Vector2.ZERO
	if always_flying:
		return Vector2.ZERO
	var gravity_effect = Vector2.ZERO
	# Apply gravitational force based on time delta and gravity strength
	gravity_effect.y += gravity_force * delta
	# Limit maximum falling speed
	if gravity_effect.y > max_fall_speed:
		gravity_effect.y = max_fall_speed
	return gravity_effect






var needs_to_jump = false
func _jump_requested():
	needs_to_jump = true

func jump():
	$'.'.velocity_influence.y -= jump_velocity
	print(debug_string, "jumping, velocity: ", $'.'.velocity_influence)
	needs_to_jump = false





#func get_project_gravity()->Vector2:
	#return ProjectSettings.get_setting("physics/2d/default_gravity_vector") * ProjectSettings.get_setting("physics/2d/default_gravity")





#
