class_name Creature
extends CharacterBody2D


#region Enums



enum CreatureStates {
	IDLE,
	MOVING,
	SWEEPING,
	CHASING,
	PERSUING_TARGET,
	ATTACKING,
	STUNNED,
	DEAD
}

#endregion Enums


#region Exports
@export var playerControlled:bool = false

#@export_group("Behavior")
#@export var defaultBehavior: Behaviors = Behaviors.BASIC
#@export var isHostile: bool = true
#@export var visionRange: float = 800.0
#@export var aggroRange: float = 600.0

@export_group("Sounds")
@export var sfxHello: AudioStream
@export var sfxAttack: AudioStream
@export var sfxDie: AudioStream
@export var sfxHurt: AudioStream
@export var sfxRoar: AudioStream
@export var sfxAggro: AudioStream

#endregion Exports


#region Signals

#signal health_changed(current_health: int, max_health: int)
signal s_died
signal s_stateChanged(old_state: CreatureStates, new_state: CreatureStates)

#endregion Signals


#region Internal Variables

var currentState: CreatureStates = CreatureStates.IDLE
var targetNode: Node = null
#var time_since_last_attack: float = 0.0
var pointOfInterest:Vector2 = Vector2.ZERO

#endregion Internal Variables



func _ready() -> void:
	$'.'.add_to_group("Creatures", true)
	$Health.died.connect(_died)
	if playerControlled:
		$Movement.playerControlled = true
		$Damage.playerControlled = true


func _physics_process(delta: float) -> void:
	$Gravity.applyGravity($'.', delta)
	if playerControlled:
		$Movement.playerControl($'.', delta)
		$Damage.playerControl($'.', delta)
		move_and_slide()
		return
	# AI control
	if not has_node("Behavior"):
		print("creature - has no behavior node")
		return
	# get or find new target to explore
	var targetPosition = $Behavior.getPOI($'.') # will change state if needed
	if targetPosition == Vector2.ZERO:
		print("creature - behavior returned target as zero, just moving forward")
		targetPosition = Vector2(100,0) * getFacingDirection()
	else:
		faceDirection(targetPosition)
	# move toward target
	if currentState == CreatureStates.ATTACKING and not $Damage.isDoneAttacking(): 
		# stay still if attacking
		$Movement.aiControl($'.', delta, Vector2.ZERO)
	else:
		#$Movement.aiControl($'.', delta, pointOfInterest)
		$Movement.aiControl($'.', delta, targetPosition)
	# attack if in range
	move_and_slide()




func ensurePOI():
	if not targetNode or not isValidTargetNode(targetNode):
		for n in $Behavior.getTargetNodes():
			if isValidTargetNode(n):
				targetNode = n
				pointOfInterest = $'.'.global_position - n.global_position
				changeState(CreatureStates.PERSUING_TARGET)
				return
	# if no valid target node just move forward
	print("creature - no valid poi ")
	pointOfInterest = Vector2(100, 0) * getFacingDirection()
	changeState(CreatureStates.SWEEPING)

func isValidTargetNode(newTarget:Node2D):
	if not is_instance_valid(newTarget):
		print("creature - not valid instance: ", newTarget)
		return false
	if $Behavior.tooFarToCare(($'.'.global_position - newTarget.global_position).length()):
		print("creature - too far to care: ", newTarget)
		return false
	# TODO add some kind of check for ledges from $Movement
	if not $Behavior.canSeeNode($'.', newTarget, getFacingDirection()):
		print("creature - cant see: ", newTarget)
		return false
	return true

func validatePOI(newPOI:Vector2):
	if $Behavior.tooFarToCare(newPOI):
		return false
	return true

func pursueTargets(delta):
	# Get target from behavior
	if not $Behavior.getCurrentTarget():
		#$Behavior.findNewPOI()
		var targets = $Behavior.getTargetNodes()
		if targets.size() > 0:
			pointOfInterest = targets[0].global_position - global_position
	$Movement.setDirection(pointOfInterest)
	#$Movement.moveToward($'.', delta, $Behavior.)
	faceDirection(pointOfInterest)
	#print("creature - target: ", pointOfInterest, ", self position: ", position, ", targets: ", targets)








func getMovementDirection() -> Vector2:
	if pointOfInterest == null:
		return Vector2.ZERO
	var directionToTarget = pointOfInterest - global_position
	# Don't bother moving if already very close
	if directionToTarget.length() < 10.0:
		return Vector2.ZERO
	return directionToTarget.normalized()




#region Environment Awareness
#
#func _canSeeNode(node:Node) -> bool:
	#if not node:
		#return false
	#var toNode = node.global_position - global_position
	#var distance = toNode.length()
	#if distance > visionRange:
		#return false
	## Check angle between enemy's "facing direction" and the vector to the player
	#var facingDirection = getFacingDirection()
	#var angle = rad_to_deg(facingDirection.angle_to(toNode.normalized()))
	#if abs(angle) > visionRange / 2.0:
		#return false
	## Line-of-sight check using RayCast2D
	#if has_node("LineOfSight"):
		#var ray = $LineOfSight
		#ray.target_position = toNode
		#ray.force_raycast_update()
		#if ray.is_colliding():
			##var collider = ray.get_collider()
			#if ray.get_collider() == toNode:
				#return true
	#return false



#func isCloseToWall() -> bool:
	#return $WallCheck.is_colliding()
#
#func isCloseToLedge() -> bool:
	#return is_on_floor() and not $LedgeCheck.is_colliding()

#endregion Environment Awareness



#region State Management

func changeState(new_state: CreatureStates) -> void:
	if new_state == currentState:
		return
	var old_state = currentState
	currentState = new_state
	s_stateChanged.emit(old_state, new_state)

#endregion State Management



func _died():
	#$Sprite.play("died")
	s_died.emit()
	print("creature - dead")




#region Facing

func getFacingDirection() -> Vector2:
	return Vector2.RIGHT if not $Sprite.flip_h else Vector2.LEFT

func faceDirection(dir: Vector2) -> void:
	if dir.x == 0:
		return
	elif dir.x > 0:
		turnRight()
	else:
		turnLeft()


func turnRight():
	if getFacingDirection().x > 0:
		return
	$Sprite.flip_h = false
	$Movement.turnRight()
	#$Damage.turnRight()
	#if $'.'.has_node("EyeLight"):
		#$EyeLight.position.x = abs($EyeLight.position.x)

func turnLeft():
	if getFacingDirection().x < 0:
		return
	$Sprite.flip_h = true
	$Movement.turnLeft()
	#$Damage.turnLeft()
	#if $'.'.has_node("EyeLight"):
		#$EyeLight.position.x = -abs($EyeLight.position.x)

#endregion Facing













		# attack if in range
		#match currentState:
			#CreatureStates.ATTACKING:
				#$Movement.move($'.', delta, Vector2.ZERO)
				#if $Damage.doneAttacking():
					#changeState(CreatureStates.IDLE)
			#CreatureStates.CHASING:
				#if $Damage.isInAttackRange(targetNode):
					#print("creature - attacking")
				#else:
					#$Movement.move($'.', delta, targetNode)
			#CreatureStates.ATTACKING:
				#$Movement.setDirection(Vector2.ZERO)
			#CreatureStates.MOVING, CreatureStates.IDLE:
				##pursueTargets(delta)
				#$Movement.move($'.', delta, pointOfInterest)
			#CreatureStates.STUNNED, CreatureStates.DEAD:
				#$Movement.setDirection(Vector2.ZERO)
			#_:
				#$Movement.setDirection(Vector2.ZERO)




#
