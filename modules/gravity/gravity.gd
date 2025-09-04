extends Node


#region Exports

@export var gravityScale:float = 1.0
@export var maxFallSpeed:float = 200.0

#endregion Exports






func applyGravity(entity: CharacterBody2D, delta: float) -> void:
	if entity.is_on_floor():
		return
	var gravVector: Vector2 = entity.get_gravity()
	entity.velocity += gravVector * gravityScale * delta
	# Clamp velocity in gravity direction
	#var gravSpeed = entity.velocity.dot(gravVector.normalized())
	#if gravSpeed > maxFallSpeed:
		#entity.velocity -= gravVector.normalized() * (gravSpeed + maxFallSpeed)









#
