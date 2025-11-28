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


static func set_collision_mask_by_type(node:CollisionObject2D, type:Types):
	#node.set_collision_layer_value(0, false)
	node.set_collision_layer_value(Layers[type], true)
static func set_collision_layers_by_type(node:CollisionObject2D, type:Types):
	#node.set_collision_layer_value(0, false)
	node.set_collision_layer_value(Layers[type], true)







#EntityTypes.Groups
