class_name Modular
extends Node



enum Types {CREATURE, PLANT, FOOD, ITEM, LOOT, COLLECTABLE, INTERACTABLE}


const Groups = { # These can be added to the editor Project Settings for convience
	Types.CREATURE : "Creature",
	Types.PLANT : "Plant",
	Types.FOOD : "Food",
	Types.LOOT : "Loot",
	Types.COLLECTABLE : "Collectable",
	Types.INTERACTABLE : "Interactable",
}


const Layers = {
	Types.CREATURE : 10,
	Types.PLANT : 11,
	Types.FOOD : 12,
	Types.LOOT : 13,
	Types.COLLECTABLE : 14,
	Types.INTERACTABLE : 15,
}




static func set_collision_layer(node:CollisionObject2D, type:Types):
	print('Modular - setting collision layers for: ', node, "on: ", Layers[type])
	node.set_collision_layer_value(Layers[type], true)


static func set_collision_mask_layer(node:CollisionObject2D, type:Types):
	print('Modular - setting collision mask layers for: ', node, "on: ", Layers[type])
	node.set_collision_mask_value(Layers[type], true)





#EntityTypes.Groups














#
