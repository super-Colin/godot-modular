class_name Modular
extends Node



enum EntityTypes {CREATURE, PLANT, FOOD, ITEM, LOOT, COLLECTABLE, INTERACTABLE}
enum ComponentTypes {BEHAVIOR, MOVEMENT, INTERACTS, INTERACTABLE, HEALTH, DAMAGES}


const Groups = {
	EntityTypes.CREATURE : "Creature",
	EntityTypes.PLANT : "Plant",
	EntityTypes.FOOD : "Food",
	EntityTypes.LOOT : "Loot",
	EntityTypes.COLLECTABLE : "Collectable",
	EntityTypes.INTERACTABLE : "Interactable",
}

const EntityLayers = {
	EntityTypes.CREATURE : 10,
	EntityTypes.PLANT : 11,
	EntityTypes.FOOD : 12,
	EntityTypes.LOOT : 13,
	EntityTypes.COLLECTABLE : 14,
	EntityTypes.INTERACTABLE : 15,
}




static func set_collision_layer(node:CollisionObject2D, type:EntityTypes):
	print('Modular - setting collision layers for: ', node, "on: ", EntityLayers[type])
	node.set_collision_layer_value(EntityLayers[type], true)


static func set_collision_mask_layer(node:CollisionObject2D, type:EntityTypes):
	print('Modular - setting collision mask layers for: ', node, "on: ", EntityLayers[type])
	node.set_collision_mask_value(EntityLayers[type], true)















#
