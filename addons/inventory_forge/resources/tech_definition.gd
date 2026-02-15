@tool
@icon("res://addons/inventory_forge/icons/inventory_forge_icon.svg")
class_name TechDefinition
extends Resource
## Definition of a single technique in the game.
## Contains all necessary data to describe the technique.
##
## Inventory Forge Plugin Extension by Whovencroft
## License: MIT

# === Segnali ===
signal changed_tech()


# === Base ===
@export_group("Base")
@export var id: int = -1:
	set(value):
		id = value
		emit_changed()
		changed_tech.emit()

@export var name_key: String = "":
	set(value):
		name_key = value
		emit_changed()
		changed_tech.emit()

@export var description_key: String = "":
	set(value):
		description_key = value
		emit_changed()
		changed_tech.emit()

@export var icon: Texture2D:
	set(value):
		icon = value
		emit_changed()
		changed_tech.emit()

@export var techniquekind: TechEnums.TechniqueKind = TechEnums.TechniqueKind.SPELL:
	set(value):
		techniquekind = value
		emit_changed()
		changed_tech.emit()

# === School or Style ===
@export_group("School")
@export var spellschool: TechEnums.SpellSchool = TechEnums.SpellSchool.NONE:
	set(value):
		spellschool = value
		emit_changed()
		changed_tech.emit()
		
# === Passives ===
@export_group("Passives")

## Passive effects on this item (only for equippable items)
@export var passives: Array[PassiveEntry] = []:
	set(value):
		passives = value
		emit_changed()
		changed_tech.emit()

# === Custom Fields ===
@export_group("Custom Fields")

## User-defined custom properties for game-specific data.
## Supports String, int, float, bool values.
## Example: {"damage_type": "fire", "cooldown": 2.5, "is_legendary": true}
## Why change what isn't broken?

@export var custom_fields: Dictionary = {}:
	set(value):
		custom_fields = value
		emit_changed()
		changed_tech.emit()

	

# === Metodi Helper ===

## Gets the translated name of the item
func get_translated_name() -> String:
	if name_key.is_empty():
		return "???"
	return tr(name_key)


## Gets the translated description of the item
func get_translated_description() -> String:
	if description_key.is_empty():
		return ""
	return tr(description_key)


## Gets the school color
func get_spell_school_color() -> Color:
	return TechEnums.get_spell_school_color(spellschool)


## Automatically generates translation keys from name
func generate_translation_keys(base_name: String) -> void:
	# Normalizza il nome: rimuovi spazi, converti in uppercase, sostituisci spazi con underscore
	var normalized := base_name.strip_edges().to_upper().replace(" ", "_")
	# Rimuovi caratteri speciali
	var clean_name := ""
	for c in normalized:
		if c.is_valid_identifier() or c == "_":
			clean_name += c
	
	if clean_name.is_empty():
		clean_name = "TECH_%d" % id
	
	name_key = "TECH_%s_NAME" % clean_name
	description_key = "TECH_%s_DESC" % clean_name


## Verifica se l'item è valido
func is_valid() -> bool:
	return id >= 0 and not name_key.is_empty()


## Gets a list of validation warnings
func get_validation_warnings() -> Array[String]:
	var warnings: Array[String] = []
	
	if id < 0:
		warnings.append("Invalid ID (must be >= 0)")
	
	if name_key.is_empty():
		warnings.append("Missing name key")
	
	if description_key.is_empty():
		warnings.append("Missing description key")
	
	if icon == null:
		warnings.append("Missing icon")
	
	
	return warnings


## Crea una copia profonda dell'item
func duplicate_tech() -> TechDefinition:
	var new_tech := TechDefinition.new()
	
	# Copia tutti i campi
	new_tech.id = -1  # Nuovo ID sarà assegnato dal database
	new_tech.name_key = name_key
	new_tech.description_key = description_key
	new_tech.icon = icon
	new_tech.techniquekind = techniquekind
	new_tech.spellschool = spellschool
	# Duplica passives
	new_tech.passives = []
	for p in passives:
		if p:
			new_tech.passives.append(p.duplicate_passive())
	new_tech.custom_fields = custom_fields.duplicate(true)

	return new_item


## Converte l'item in un Dictionary (per serializzazione/debug)
func to_dictionary() -> Dictionary:
	var passives_data = []
	for p in passives:
		if p:
			passives_data.append(p.to_dict())

	return {
		"id": id,
		"name_key": name_key,
		"description_key": description_key,
		"techniquekind": techniquekind,
		"spellschool": spellschool,
		"passives": passives_data,
		"custom_fields": custom_fields.duplicate(),
	}


# === Custom Fields Methods ===

## Gets a custom field value with optional default
func get_custom(key: String, default: Variant = null) -> Variant:
	return custom_fields.get(key, default)


## Sets a custom field value
func set_custom(key: String, value: Variant) -> void:
	custom_fields[key] = value
	emit_changed()
	changed_tech.emit()


## Checks if a custom field exists
func has_custom(key: String) -> bool:
	return custom_fields.has(key)


## Removes a custom field
func remove_custom(key: String) -> bool:
	if custom_fields.has(key):
		custom_fields.erase(key)
		emit_changed()
		changed_tech.emit()
		return true
	return false


## Gets all custom field keys
func get_custom_keys() -> Array:
	return custom_fields.keys()


## Gets a custom field as String (with type conversion)
func get_custom_string(key: String, default: String = "") -> String:
	var value = custom_fields.get(key)
	if value == null:
		return default
	return str(value)


## Gets a custom field as int (with type conversion)
func get_custom_int(key: String, default: int = 0) -> int:
	var value = custom_fields.get(key)
	if value == null:
		return default
	if value is int:
		return value
	if value is float:
		return int(value)
	if value is String and value.is_valid_int():
		return int(value)
	return default


## Gets a custom field as float (with type conversion)
func get_custom_float(key: String, default: float = 0.0) -> float:
	var value = custom_fields.get(key)
	if value == null:
		return default
	if value is float:
		return value
	if value is int:
		return float(value)
	if value is String and value.is_valid_float():
		return float(value)
	return default


## Gets a custom field as bool (with type conversion)
func get_custom_bool(key: String, default: bool = false) -> bool:
	var value = custom_fields.get(key)
	if value == null:
		return default
	if value is bool:
		return value
	if value is int:
		return value != 0
	if value is String:
		return value.to_lower() in ["true", "1", "yes", "on"]
	return default


## Clears all custom fields
func clear_custom_fields() -> void:
	custom_fields.clear()
	emit_changed()
	changed_tech.emit()


## Merges custom fields from another dictionary
func merge_custom_fields(fields: Dictionary, overwrite: bool = true) -> void:
	if overwrite:
		custom_fields.merge(fields, true)
	else:
		for key in fields:
			if not custom_fields.has(key):
				custom_fields[key] = fields[key]
	emit_changed()
	changed_tech.emit()
