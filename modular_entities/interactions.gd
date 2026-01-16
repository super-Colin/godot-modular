class_name Interactions
extends Node

var debug_string = "Interactions - "

enum Types {HEAL, HURT, INVULNERABLE}





func heal(entity:ModularEntity2D, amount:int=5):
	print(debug_string, "calling heal")
	if entity.components.has(HealthComponent2D):
		entity.components[HealthComponent2D].heal(amount)
	else:
		print(debug_string, "entity didn't have health component")
	return













#
