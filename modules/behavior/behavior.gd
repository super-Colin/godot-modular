extends Node2D

#region Enums

enum Behaviors {
	BASIC,
	SWEEP,
	WANDER, 
}

#enum Intentions {
	##PATROL, 
	#SEEK, 
	#CHASE, 
	#MOVE_FOWARD, 
	##SAY_HELLO, 
	##SPEAK, 
	##SWEEP
#}

#endregion Enums


@export var defaultBehavior: Behaviors = Behaviors.BASIC
## Will it attempt to attack it's target?
@export var isHostile: bool = true
## What groups are it's targets?
@export var targetGroups:Array[String] = ["Player", "Food"]
## Range the creature can confirm a sighting of something
@export var visionRange: float = 800.0
@export var visionAngle: float = 120.0
## How close something can be before it attacks
@export var aggroRange: float = 600.0
## Range that the creature will keep track of target through walls
@export var memoryRange: float = 1000.0
## Range that the creature will stop or not care about a target
@export var dontCareRange: float = 1500.0


#var currentIntention = Intentions.MOVE_FOWARD
var currentTargetNode:Node2D
var currentPointOfInterest:Vector2
var targetSighted:bool=false



func getPOI(entity: CharacterBody2D)->Vector2:
	#if not currentTargetNode or not isValidTargetNode(currentTargetNode):
	if not currentTargetNode:
		findNewTargetNode(entity)
	# check is still valid
	else:
		# update position
		currentPointOfInterest = currentTargetNode.global_position - entity.global_position
		if tooFarToCare(currentPointOfInterest.length()):
			currentPointOfInterest = Vector2.ZERO
	return currentPointOfInterest


func findNewTargetNode(entity: CharacterBody2D, index = 0): 
	# index in case one isn't possible for some reason
	var targets = getTargetNodes()
	if targets.size() > index:
		currentTargetNode = targets[index]
		currentPointOfInterest = currentTargetNode.global_position - entity.global_position
		print("behavior - found new target node: ", currentTargetNode, ", as POI: ", currentPointOfInterest)
	else:
		currentPointOfInterest = Vector2.ZERO




func getTargetGroups():
	return targetGroups

func getCurrentTarget():
	return currentTargetNode


func getTargetNodes()->Array:
	var targets = []
	for group in targetGroups:
		targets.append_array(get_tree().get_nodes_in_group(group))
	return targets




func findNewPOI(entity: CharacterBody2D):
	var targets = getTargetNodes()
	if targets.size() > 0:
		currentPointOfInterest = targets[0].global_position - entity.global_position
	else:
		currentPointOfInterest = Vector2(50,0) * entity.getFacingDirection()
	return currentPointOfInterest


func getBehavior():
	return defaultBehavior




#region Environment Awareness

func tooFarToCare(distance):
	return distance > dontCareRange

func canSeeNode(entity: CharacterBody2D, node:Node) -> bool:
	if not node:
		return false
	var toNodeVector = node.global_position - global_position
	var distance = toNodeVector.length()
	if distance > visionRange:
		return false
	# Check angle between enemy's "facing direction" and the vector to the player
	var angle = rad_to_deg(entity.getFacingDirection().angle_to(toNodeVector.normalized()))
	if abs(angle) > visionAngle / 2.0:
		return false
	# check it's not too far to see
	# then check nothing is block LOS
	# Line-of-sight check using RayCast2D
	if has_node("LineOfSightRay"):
		var ray = $LineOfSightRay
		ray.target_position = toNodeVector
		ray.force_raycast_update()
		if ray.is_colliding():
			print("behavior - ray is colliding: ", ray.get_collider())
			#var collider = ray.get_collider()
			if ray.get_collider() == node:
				return true
		else:
			return true
	return false



#endregion Environment Awareness



















#
