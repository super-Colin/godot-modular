extends Node2D

enum MovementTypes {
	NONE,
	WALK,
	RUN,
	FLY
}


#region Exports
@export_group("Movement Types")
#@export var movementTypes: MovementTypes = MovementTypes.WALK

@export_group("Jumping")
@export var canJump:bool = true
@export var jumpVelocity = 200
@export var accelerationAir: float = 5.0
@export var frictionAir: float = 50.0
@export var maxSpeedAir: float = 400.0
@export_subgroup("Continous Jump")
@export var canContinousJump:bool = false
@export var jumpVelocityContinous = 40



@export_group("Walking")
@export var maxSpeed: float = 400.0
@export var acceleration: float = 100.0
@export var friction: float = 50.0



#endregion Exports



#region Variables

var direction: Vector2 = Vector2.ZERO


#endregion Variables
#region Signals
signal s_hitWall
signal s_hitLedge
#endregion Signals



#region Movement Logic

func setDirection(newDirection: Vector2) -> void:
	direction = newDirection.normalized()

func moveForward(entity:CharacterBody2D, delta: float) -> void:
	var dir = entity.getFacingDirection()
	if direction == Vector2.ZERO:
		entity.velocity = entity.velocity.move_toward(Vector2.ZERO, friction * delta)
	else:
		entity.velocity = entity.velocity.move_toward(direction * maxSpeed, acceleration * delta)







func playerControl(entity:CharacterBody2D, delta:float)->void:
	# run each frame
	#if Input.is_action_pressed("Move_Jump"):
		#if onFloor:
			#jump()
	return

func aiControl(entity:CharacterBody2D, delta:float, target)->void:
	if not target:
		print("movement - has no target, expected Node2D or relative Vector2: ", target)
		return
	var targetPosition = Vector2.ZERO
	if target is Node:
		#print("movement - target is node")
		targetPosition = entity.global_position - target.global_position
	elif target is Vector2:
		#print("movement - target is vector")
		targetPosition = target
	moveToward(entity, delta, targetPosition)

func moveToward(entity:CharacterBody2D, delta:float, target:Vector2)->void:
	print("movement - target is: ", target)
	var accel = acceleration
	var fric = friction
	if isCloseToWall(entity):
		s_hitWall.emit()
	if isCloseToLedge(entity):
		s_hitWall.emit()
	if not entity.is_on_floor():
		accel = accelerationAir
		fric = frictionAir
	if not abs(entity.velocity.x) > abs(maxSpeed):
		#var walkingInfluence = sign(entity.getFacingDirection().x) * accel * delta * 100
		var walkingInfluence = sign(target.normalized().x) * accel * delta * 100
		entity.velocity.x += walkingInfluence
		#print("movement - walkingInfluence is: ", walkingInfluence)
	else:
		#print("movement - moving too fast: ", entity.velocity.x, " > ", maxSpeed)
		#print("enemy - too fast.. velocity: ", velocity)
		#entity.velocity.x = move_toward(entity.velocity.x, maxSpeed, fric * delta * 100)
		entity.velocity.x = move_toward(entity.velocity.x, 0, fric * delta * 10)
	#if direction:
		#walkingInfluence = sign(direction.x) * accel * delta * 100
		#if (not entity.velocity.x < -maxSpeed and not entity.velocity.x > maxSpeed):
			#entity.velocity.x += walkingInfluence
		#else:
			##print("enemy - too fast.. velocity: ", velocity)
			#entity.velocity.x = move_toward(entity.velocity.x, maxSpeed, fric * delta * 100)
		##print("enemy - walkingInfluences: ", walkingInfluence)
	#else:
		##print("enemy - no direction: ", direction)
		#entity.velocity.x = move_toward(entity.velocity.x, 0, fric * delta * 100)



func turnRight(_entity:CharacterBody2D=null)->void:
	$WallCheckRay.target_position.x = abs($WallCheckRay.target_position.x)
	$LedgeCheckRay.target_position.x = abs($LedgeCheckRay.target_position.x)

func turnLeft(_entity:CharacterBody2D=null)->void:
	$WallCheckRay.target_position.x = -abs($WallCheckRay.target_position.x)
	$LedgeCheckRay.target_position.x = -abs($LedgeCheckRay.target_position.x)




#endregion Movement Logic



## Calculates movement depending on the context
#func _get_movement(fric: float, accel: float, delta: float):
	#var direction = Input.get_axis("Move_Left", "Move_Right")
	#var walkingInfluence
	#if direction:
		#walkingInfluence = sign(direction) * accel * delta * 100
		## if not at max speed 
		## if sign(direction) != sign(velocity.x) or (not velocity.x < -max_speed and not velocity.x > max_speed):
		#if (not velocity.x < -max_speed and not velocity.x > max_speed):
			#velocity.x += walkingInfluence
		#else:
			#velocity.x = move_toward(velocity.x, max_speed, fric * delta * 100)
	#else:
		#velocity.x = move_toward(velocity.x, 0, fric * delta * 100)







#region Jumping


# Adds the player's jump velocity if able
func jump(entity:CharacterBody2D):
	entity.velocity.y = jumpVelocity
#func moveToward(entity:CharacterBody2D, delta:float, target:Vector2):

func jumpContinous(entity:CharacterBody2D, delta:float):
	entity.velocity.y += jumpVelocityContinous * delta


#endregion Jumping


#region Environment Awareness
func isCloseToWall(_entity:CharacterBody2D) -> bool:
#func isCloseToWall(_entity:CharacterBody2D?=null) -> bool:
	return $WallCheckRay.is_colliding()

func isCloseToLedge(entity:CharacterBody2D) -> bool:
	return entity.is_on_floor() and not $LedgeCheckRay.is_colliding()
#endregion Environment Awareness








#
