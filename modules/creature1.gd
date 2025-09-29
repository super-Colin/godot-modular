#extends CharacterBody2D # Creature
#
#
#
#
# http://127.0.0.1:11434
#
##region Exports
#@export var playerControlled:bool = false
##endregion Exports
#
#
##region Signals
#signal s_died
##endregion Signals
#
#
#func _ready() -> void:
	#$'.'.add_to_group("Creatures", true)
	#setup_health()
	#setup_movement()
	#setup_behavior()
#
#
##region Behavior
#func setup_behavior() -> void:
	#pass  # Optional state customization later
##endregion
#
#
##region Movement
#func setup_movement() -> void:
	#pass  # You could init movement here or call from AI logic later
#
#func move_to_point(point: Vector2) -> void:
	#$Movement.move_towards(point)
#
#func stop_movement() -> void:
	#$Movement.stop()
##endregion Movement
#
#
##region Health
#func setup_health():
	#$Health.died.connect(_on_death)
	#$Health.health_changed.connect(_on_health_changed)
#
#func _on_death():
	#print("Creature died")
#
#func _on_health_changed(current: int, max: int) -> void:
	#print("Health: %d / %d" % [current, max])
##endregion Health
#
#
#
##region Debugging
#func _unhandled_input(event: InputEvent) -> void:
	#if event is InputEventMouseButton and event.pressed:
		#move_to_point(event.position)
##endregion Debugging
#
#
#
#
#
#
#
##
##func _physics_process(delta: float) -> void:
	##$Gravity.applyGravity($'.', delta)
	##if playerControlled:
		##$Movement.playerControl($'.', delta)
		##$Damage.playerControl($'.', delta)
		##move_and_slide()
		##return
	### AI control
	##if not has_node("Behavior"):
		##print("creature - has no behavior node")
		##return
	### get or find new target to explore
	##var targetPosition = $Behavior.getPOI($'.') # will change state if needed
	##if targetPosition == Vector2.ZERO:
		##targetPosition = Vector2(100,0) * getFacingDirection()
	##else:
		##faceDirection(targetPosition)
	### move toward target
	##if currentState == CreatureStates.ATTACKING: 
		### stay still if attacking
		##$Movement.aiControl($'.', delta, Vector2.ZERO)
	##else:
		##$Movement.aiControl($'.', delta, targetPosition)
	##move_and_slide()
#
#
#
###region Damage
##func setupDamage():
	##$Damage.s_healthAreaEntered.connect(attack)
##
##func attack(healthArea):
	##changeState(CreatureStates.ATTACKING)
	##$Damage.attackHealthArea(healthArea)
	##$Sprite.play("attacking")
##
##func doneAttacking():
	##changeState(CreatureStates.PERSUING_TARGET)
##
##
###endregion Damage
##
##func ensurePOI():
	##if not targetNode or not isValidTargetNode(targetNode):
		##for n in $Behavior.getTargetNodes():
			##if isValidTargetNode(n):
				##targetNode = n
				##pointOfInterest = $'.'.global_position - n.global_position
				##changeState(CreatureStates.PERSUING_TARGET)
				##return
	### if no valid target node just move forward
	##print("creature - no valid poi ")
	##pointOfInterest = Vector2(100, 0) * getFacingDirection()
	##changeState(CreatureStates.SWEEPING)
##
##func isValidTargetNode(newTarget:Node2D):
	##if not is_instance_valid(newTarget):
		##print("creature - not valid instance: ", newTarget)
		##return false
	##if $Behavior.tooFarToCare(($'.'.global_position - newTarget.global_position).length()):
		##print("creature - too far to care: ", newTarget)
		##return false
	### TODO add some kind of check for ledges from $Movement
	##if not $Behavior.canSeeNode($'.', newTarget, getFacingDirection()):
		##print("creature - cant see: ", newTarget)
		##return false
	##return true
##
##func validatePOI(newPOI:Vector2):
	##if $Behavior.tooFarToCare(newPOI):
		##return false
	##return true
##
##func pursueTargets(delta):
	### Get target from behavior
	##if not $Behavior.getCurrentTarget():
		###$Behavior.findNewPOI()
		##var targets = $Behavior.getTargetNodes()
		##if targets.size() > 0:
			##pointOfInterest = targets[0].global_position - global_position
	##$Movement.setDirection(pointOfInterest)
	###$Movement.moveToward($'.', delta, $Behavior.)
	##faceDirection(pointOfInterest)
	###print("creature - target: ", pointOfInterest, ", self position: ", position, ", targets: ", targets)
##
##
##
##
##
##
##
##
##func getMovementDirection() -> Vector2:
	##if pointOfInterest == null:
		##return Vector2.ZERO
	##var directionToTarget = pointOfInterest - global_position
	### Don't bother moving if already very close
	##if directionToTarget.length() < 10.0:
		##return Vector2.ZERO
	##return directionToTarget.normalized()
##
##
##
##
##
##
###region State Management
##
##func changeState(new_state: CreatureStates) -> void:
	##if new_state == currentState:
		##return
	##var old_state = currentState
	##currentState = new_state
	##s_stateChanged.emit(old_state, new_state)
##
###endregion State Management
##
##
##
##func _died():
	###$Sprite.play("died")
	##currentState = CreatureStates.DEAD
	##s_died.emit()
	##print("creature - dead")
##
##
##
##
###region Facing
##
##func getFacingDirection() -> Vector2:
	##return Vector2.RIGHT if not $Sprite.flip_h else Vector2.LEFT
##
##func faceDirection(dir: Vector2) -> void:
	##if dir.x == 0:
		##return
	##elif dir.x > 0:
		##turnRight()
	##else:
		##turnLeft()
##
##
##func turnRight():
	##if getFacingDirection().x > 0:
		##return
	##$Sprite.flip_h = false
	##$Movement.turnRight() # flip wall and ledge check rays
	##$Damage.position.x = abs($Damage.position.x)
	###if $'.'.has_node("EyeLight"):
		###$EyeLight.position.x = abs($EyeLight.position.x)
##
##func turnLeft():
	##if getFacingDirection().x < 0:
		##return
	##$Sprite.flip_h = true
	##$Movement.turnLeft() # flip wall and ledge check rays
	##$Damage.position.x = -abs($Damage.position.x)
	###if $'.'.has_node("EyeLight"):
		###$EyeLight.position.x = -abs($EyeLight.position.x)
##
###endregion Facing
##
##
##
##
##
##
##
##
##
##
##
##
##
##
##
##
###
