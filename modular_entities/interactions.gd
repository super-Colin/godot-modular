class_name Interactions
extends Node

var debug_string = "Interactions - "

enum Types {HEAL, HURT, INVULNERABLE}





func heal(entity:ModularEntity2D, amount:int=5):
	print(debug_string, "calling heal interaction")
	if entity.components.has(Component2DHealth):
		entity.components[Component2DHealth].heal(amount)
	else:
		print(debug_string, "entity didn't have health component")
	return


func hurt(entity:ModularEntity2D, amount:int=5):
	print(debug_string, "calling hurt interaction")
	if entity.components.has(Component2DHealth):
		entity.components[Component2DHealth].heal(amount)
	else:
		print(debug_string, "entity didn't have health component")
	return












#
