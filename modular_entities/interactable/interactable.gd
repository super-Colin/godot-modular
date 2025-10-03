extends Area2D

@export var interactionFunction:Interactions.Callables



var interactionCallable:Callable
#var interactionCallable



func interaction(interactingBody):
	print("interactable - interactingBody: ", interactingBody)
	if interactionCallable:
		interactionCallable.call()
		$'.'.queue_free()



















#
