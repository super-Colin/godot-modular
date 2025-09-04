extends Node



#region Exports

@export var maxHealth: int = 100
@export var defense: int = 0

#endregion Exports



#region Signals

signal healthChanged(currentHealth: int, maxHealth: int)
signal died
signal tookDamage(amount: int, source: Node)

#endregion Signals



#region Internal-Variables

var currentHealth: int

#endregion Internal-Variables



#region Built-in

func _ready() -> void:
	currentHealth = maxHealth

#endregion Built-in



#region Health Logic

func takeDamage(amount: int, source: Node = null) -> void:
	if isDead():
		return
	var finalDamage = max(amount - defense, 0)
	currentHealth = max(currentHealth - finalDamage, 0)
	emit_signal("tookDamage", finalDamage, source)
	emit_signal("healthChanged", currentHealth, maxHealth)
	if currentHealth <= 0:
		emit_signal("died")

func heal(amount: int) -> void:
	if isDead():
		return

	currentHealth = min(currentHealth + amount, maxHealth)
	emit_signal("healthChanged", currentHealth, maxHealth)

func isDead() -> bool:
	return currentHealth <= 0

#endregion Health Logic






#
