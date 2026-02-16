@tool
@icon("res://addons/inventory_forge/icons/inventory_forge_icon.svg")
class_name TechDatabase
extends Resource
## Database containing all game techniques.
## Manages the TechDefinition collection and provides search methods.
##
## Inventory Forge Plugin Extension by Whovencroft
## License: MIT

# === Segnali ===
signal tech_added(tech: TechDefinition)
signal tech_removed(tech: TechDefinition)
signal tech_modified(tech: TechDefinition)
signal database_changed()


# === Dati ===
@export var techs: Array[TechDefinition] = []:
	set(value):
		techs = value
		emit_changed()
		database_changed.emit()

## Migration flag - do not modify manually
@export var _migration_v2_materials_done: bool = false


# === Search Methods ===

## Gets an tech by ID
func get_tech_by_id(id: int) -> TechDefinition:
	for tech in techs:
		if tech and tech.id == id:
			return tech
	return null


## Gets the index of an tech by ID
func get_tech_index_by_id(id: int) -> int:
	for i in range(techs.size()):
		if techs[i] and techs[i].id == id:
			return i
	return -1


## Checks if an tech with the specified ID exists
func has_tech(id: int) -> bool:
	return get_tech_by_id(id) != null


## Gets all techs of a type
func get_techs_by_category(techniquekind: TechEnums.TechniqueKind) -> Array[TechDefinition]:
	var result: Array[TechDefinition] = []
	for tech in techs:
		if tech and tech.techniquekind == techniquekind:
			result.append(tech)
	return result


## Gets all techs of a school
func get_techs_by_school(spellschool: TechEnums.SpellSchool) -> Array[TechDefinition]:
	var result: Array[TechDefinition] = []
	for tech in techs:
		if tech and tech.spellschool == spellschool:
			result.append(tech)
	return result


## Search techs by name (translation key)
func search_techs(query: String) -> Array[TechDefinition]:
	if query.is_empty():
		return techs.duplicate()
	
	var result: Array[TechDefinition] = []
	var query_lower := query.to_lower()
	
	for tech in techs:
		if tech == null:
			continue
		
		# Search in name key
		if tech.name_key.to_lower().contains(query_lower):
			result.append(tech)
			continue
		
		# Search in translated name
		var translated_name := tech.get_translated_name().to_lower()
		if translated_name.contains(query_lower):
			result.append(tech)
			continue
		
		# Search in ID
		if str(tech.id).contains(query):
			result.append(tech)
	
	return result


## Filters techs by category and search query
func filter_techs(tech_filter: int = -1, search_query: String = "") -> Array[TechDefinition]:
	var result: Array[TechDefinition] = []
	
	for tech in techs:
		if tech == null:
			continue
		
		# Tech filter (-1 = all)
		if tech_filter >= 0 and tech.techniquekind != tech_filter:
			continue
		
		# Search filter
		if not search_query.is_empty():
			var query_lower := search_query.to_lower()
			var name_matches := tech.name_key.to_lower().contains(query_lower)
			var translated_matches := tech.get_translated_name().to_lower().contains(query_lower)
			var id_matches := str(tech.id).contains(search_query)
			
			if not (name_matches or translated_matches or id_matches):
				continue
		
		result.append(tech)
	
	return result



# === Metodi di Gestione ===

## Gets the next available ID
func get_next_available_id() -> int:
	var max_id := -1
	for tech in techs:
		if tech and tech.id > max_id:
			max_id = tech.id
	return max_id + 1


## Checks if there is a duplicate ID
func has_duplicate_id(id: int, exclude_tech: TechDefinition = null) -> bool:
	var count := 0
	for tech in techs:
		if tech and tech.id == id and tech != exclude_tech:
			count += 1
	return count > 0


## Aggiunge un nuovo tech al database
func add_tech(tech: TechDefinition) -> void:
	if tech == null:
		return
	
	# Assegna ID se non valido
	if tech.id < 0:
		tech.id = get_next_available_id()
	
	techs.append(tech)
	emit_changed()
	tech_added.emit(tech)
	database_changed.emit()


## Rimuove un tech dal database
func remove_tech(tech: TechDefinition) -> bool:
	var index := techs.find(tech)
	if index >= 0:
		techs.remove_at(index)
		emit_changed()
		tech_removed.emit(tech)
		database_changed.emit()
		return true
	return false


## Rimuove un tech per ID
func remove_tech_by_id(id: int) -> bool:
	var tech := get_tech_by_id(id)
	if tech:
		return remove_tech(tech)
	return false


## Duplicates an existing tech
func duplicate_tech(tech: TechDefinition) -> TechDefinition:
	if tech == null:
		return null
	
	var new_tech := tech.duplicate_tech()
	new_tech.id = get_next_available_id()
	
	# Modifica le chiavi per indicare che è una copia
	if not new_tech.name_key.is_empty():
		new_tech.name_key = new_tech.name_key + "_COPY"
	if not new_tech.description_key.is_empty():
		new_tech.description_key = new_tech.description_key + "_COPY"
	
	add_tech(new_tech)
	return new_tech


## Crea un nuovo tech vuoto
func create_new_tech() -> TechDefinition:
	var new_tech := TechDefinition.new()
	new_tech.id = get_next_available_id()
	add_tech(new_tech)
	return new_tech


## Ordina gli techs per ID
func sort_by_id() -> void:
	techs.sort_custom(func(a, b): return a.id < b.id)
	emit_changed()
	database_changed.emit()


## Ordina gli techs per nome
func sort_by_name() -> void:
	techs.sort_custom(func(a, b): return a.name_key < b.name_key)
	emit_changed()
	database_changed.emit()


## Ordina gli techs per categoria
func sort_by_category() -> void:
	techs.sort_custom(func(a, b): return a.category < b.category)
	emit_changed()
	database_changed.emit()


# === Validazione ===

## Gets all techs with warnings
func get_techs_with_warnings() -> Array[TechDefinition]:
	var result: Array[TechDefinition] = []
	for tech in techs:
		if tech and not tech.get_validation_warnings().is_empty():
			result.append(tech)
	return result


## Gets all duplicate IDs
func get_duplicate_ids() -> Array[int]:
	var id_count := {}
	var duplicates: Array[int] = []
	
	for tech in techs:
		if tech == null:
			continue
		if id_count.has(tech.id):
			id_count[tech.id] += 1
			if not duplicates.has(tech.id):
				duplicates.append(tech.id)
		else:
			id_count[tech.id] = 1
	
	return duplicates


## Valida tutto il database
func validate() -> Array[String]:
	var errors: Array[String] = []
	
	# Check for duplicate IDs
	var duplicate_ids := get_duplicate_ids()
	for dup_id in duplicate_ids:
		errors.append("Duplicate ID: %d" % dup_id)
	
	# Check for invalid techs
	for tech in techs:
		if tech == null:
			errors.append("Tech null trovato nel database")
			continue
		
		var warnings := tech.get_validation_warnings()
		for warning in warnings:
			errors.append("Tech %d: %s" % [tech.id, warning])
	
	return errors


# === Import/Export ===

## Esporta le chiavi di traduzione per tutti gli techs
func export_translation_keys() -> Dictionary:
	var keys := {}
	
	for tech in techs:
		if tech == null:
			continue
		
		if not tech.name_key.is_empty():
			keys[tech.name_key] = tech.get_translated_name()
		
		if not tech.description_key.is_empty():
			keys[tech.description_key] = tech.get_translated_description()
	
	return keys


## Gets the tech count per kind/type
func get_tech_counts() -> Dictionary:
	var counts := {}
	for tech in TechEnums.TechniqueKind.values():
		counts[tech] = 0
	
	for tech in techs:
		if tech:
			counts[tech.techniquekind] = counts.get(tech.techniquekind, 0) + 1
	
	return counts


## Gets the tech count per school
func get_school_counts() -> Dictionary:
	var counts := {}
	for schools in TechEnums.SpellSchool.values():
		counts[schools] = 0
	
	for tech in techs:
		if tech:
			counts[tech.spellschool] = counts.get(tech.spellschool, 0) + 1
	
	return counts
	
	
## Gets the tech count per activation kind
func get_activation_counts() -> Dictionary:
	var counts := {}
	for activationkind in TechEnums.ActivationKind.values():
		counts[activationkind] = 0
	
	for tech in techs:
		if tech:
			counts[tech.activationkind] = counts.get(tech.activationkind, 0) + 1
	
	return counts



## Gets database statistics
func get_stats() -> Dictionary:
	return {
		"total_techs": techs.size(),
		"techs_with_warnings": get_techs_with_warnings().size(),
		"duplicate_ids": get_duplicate_ids().size(),
		"tech_counts": get_tech_counts(),
		"school_counts": get_school_counts(),
		"activation_kind": get_activation_counts()
	}


# === Export Methods ===

## Exports the database to JSON format
func export_to_json() -> String:
	var data := {
		"version": "1.0",
		"export_date": Time.get_datetime_string_from_system(),
		"techs": []
	}
	
	for tech in techs:
		if tech == null:
			continue
		data.techs.append(_tech_to_dict(tech))
	
	return JSON.stringify(data, "\t")


## Exports the database to a JSON file
func export_to_json_file(path: String) -> Error:
	var json_string := export_to_json()
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		push_error("[InventoryForge] Failed to open file for writing: %s" % path)
		return FileAccess.get_open_error()
	
	file.store_string(json_string)
	file.close()
	return OK


## Exports the database to CSV format
func export_to_csv() -> String:
	var lines: Array[String] = []
	
	# Header
	var headers := [
		"id", "name_key", "description_key", "icon_path",
		"techniquekind", "spellschool", "activationkind", "resourcetype",
		"poseffect", "negeffect", "tradeable", "passive"
	]
	lines.append(",".join(headers))
	
	# Data rows
	for tech in techs:
		if tech == null:
			continue
		
		var icon_path := ""
		if tech.icon:
			icon_path = tech.icon.resource_path
		
		# Serialize ingredients as semicolon-separated id:amount pairs
		var ingredients_str := ""
		if tech.craftable and tech.ingredients.size() > 0:
			var ing_parts: Array[String] = []
			for ing in tech.ingredients:
				if ing and ing.has("tech_id") and ing.has("amount"):
					ing_parts.append("%d:%d" % [ing.get("tech_id"), ing.get("amount")])
			ingredients_str = ";".join(ing_parts)
		
		var row := [
			str(tech.id),
			_escape_csv(tech.name_key),
			_escape_csv(tech.description_key),
			_escape_csv(icon_path),
			TechEnums.TechniqueKind.keys()[tech.techniquekind],
			TechEnums.SpellSchool.keys()[tech.spellschool],
			TechEnums.ActivationKind.keys()[tech.activationkind],
			TechEnums.ResourceType.keys()[tech.resourcetype],
			TechEnums.PosEffectType.keys()[tech.poseffect],
			TechEnums.NegEffectType.keys()[tech.negeffect],
			TechEnums.PassiveType.keys()[tech.passives],
		]
		lines.append(",".join(row))
	
	return "\n".join(lines)


## Exports the database to a CSV file
func export_to_csv_file(path: String) -> Error:
	var csv_string := export_to_csv()
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		push_error("[InventoryForge] Failed to open file for writing: %s" % path)
		return FileAccess.get_open_error()
	
	file.store_string(csv_string)
	file.close()
	return OK


## Helper: Convert tech to dictionary for JSON export
func _tech_to_dict(tech: TechDefinition) -> Dictionary:
	var icon_path := ""
	if tech.icon:
		icon_path = tech.icon.resource_path
	
	var ingredients_data: Array[Dictionary] = []
	if tech.craftable:
		for ing in tech.ingredients:
			if ing and ing.has("tech_id") and ing.has("amount"):
				ingredients_data.append({
					"tech_id": ing.get("tech_id"),
					"amount": ing.get("amount")
				})
	
	return {
		"id": tech.id,
		"name_key": tech.name_key,
		"description_key": tech.description_key,
		"icon_path": icon_path,
		"techniquekind": TechEnums.TechniqueKind.keys()[tech.techniquekind],
		"spellschool": TechEnums.SpellSchool.keys()[tech.spellschool],
		"activationkind": TechEnums.ActivationKind.keys()[tech.activationkind],
		"resourcetype": TechEnums.ResourceType.keys()[tech.resourcetype],
		"poseffect": TechEnums.PosEffectType.keys()[tech.poseffect],
		"negeffect": TechEnums.NegEffectType.keys()[tech.negeffect],
		"passives": TechEnums.PassiveType.keys()[tech.passives],
		"custom_fields": tech.custom_fields.duplicate(),
	}


## Helper: Escape CSV field
func _escape_csv(value: String) -> String:
	if value.contains(",") or value.contains("\"") or value.contains("\n"):
		return "\"%s\"" % value.replace("\"", "\"\"")
	return value


# === Import Methods ===

## Import mode for merging data
enum ImportMode {
	REPLACE_ALL,      # Clear database and import
	MERGE_SKIP,       # Skip techs with existing IDs
	MERGE_OVERWRITE,  # Overwrite techs with existing IDs
}


## Imports techs from JSON string
func import_from_json(json_string: String, mode: ImportMode = ImportMode.MERGE_SKIP) -> Dictionary:
	var result := {"success": false, "imported": 0, "skipped": 0, "errors": []}
	
	var json := JSON.new()
	var parse_result := json.parse(json_string)
	
	if parse_result != OK:
		result.errors.append("Failed to parse JSON: %s at line %d" % [json.get_error_message(), json.get_error_line()])
		return result
	
	var data: Dictionary = json.data
	if not data.has("techs") or not data.techs is Array:
		result.errors.append("Invalid JSON structure: missing 'techs' array")
		return result
	
	if mode == ImportMode.REPLACE_ALL:
		techs.clear()
	
	for tech_data in data.techs:
		var import_result := _import_tech_from_dict(tech_data, mode)
		if import_result.success:
			result.imported += 1
		elif import_result.skipped:
			result.skipped += 1
		else:
			result.errors.append(import_result.error)
	
	if result.imported > 0:
		emit_changed()
		database_changed.emit()
	
	result.success = result.errors.is_empty()
	return result


## Imports techs from a JSON file
func import_from_json_file(path: String, mode: ImportMode = ImportMode.MERGE_SKIP) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {"success": false, "imported": 0, "skipped": 0, "errors": ["Failed to open file: %s" % path]}
	
	var json_string := file.get_as_text()
	file.close()
	
	return import_from_json(json_string, mode)


## Imports techs from CSV string
func import_from_csv(csv_string: String, mode: ImportMode = ImportMode.MERGE_SKIP) -> Dictionary:
	var result := {"success": false, "imported": 0, "skipped": 0, "errors": []}
	
	var lines := csv_string.split("\n")
	if lines.size() < 2:
		result.errors.append("CSV file is empty or has no data rows")
		return result
	
	# Parse header
	var headers := _parse_csv_line(lines[0])
	
	if mode == ImportMode.REPLACE_ALL:
		techs.clear()
	
	# Parse data rows
	for i in range(1, lines.size()):
		var line := lines[i].strip_edges()
		if line.is_empty():
			continue
		
		var values := _parse_csv_line(line)
		if values.size() != headers.size():
			result.errors.append("Line %d: column count mismatch (expected %d, got %d)" % [i + 1, headers.size(), values.size()])
			continue
		
		var tech_data := {}
		for j in range(headers.size()):
			tech_data[headers[j]] = values[j]
		
		var import_result := _import_tech_from_csv_row(tech_data, mode)
		if import_result.success:
			result.imported += 1
		elif import_result.skipped:
			result.skipped += 1
		else:
			result.errors.append("Line %d: %s" % [i + 1, import_result.error])
	
	if result.imported > 0:
		emit_changed()
		database_changed.emit()
	
	result.success = result.errors.is_empty()
	return result


## Imports techs from a CSV file
func import_from_csv_file(path: String, mode: ImportMode = ImportMode.MERGE_SKIP) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {"success": false, "imported": 0, "skipped": 0, "errors": ["Failed to open file: %s" % path]}
	
	var csv_string := file.get_as_text()
	file.close()
	
	return import_from_csv(csv_string, mode)


## Helper: Import single tech from dictionary (JSON)
func _import_tech_from_dict(data: Dictionary, mode: ImportMode) -> Dictionary:
	var result := {"success": false, "skipped": false, "error": ""}
	
	if not data.has("id"):
		result.error = "Missing 'id' field"
		return result
	
	var id: int = int(data.get("id", -1))
	var existing := get_tech_by_id(id)
	
	if existing and mode == ImportMode.MERGE_SKIP:
		result.skipped = true
		return result
	
	var tech: TechDefinition
	if existing and mode == ImportMode.MERGE_OVERWRITE:
		tech = existing
	else:
		tech = TechDefinition.new()
		tech.id = id
	
	# Set basic properties
	tech.name_key = str(data.get("name_key", ""))
	tech.description_key = str(data.get("description_key", ""))
	
	# Load icon if path provided
	var icon_path: String = str(data.get("icon_path", ""))
	if not icon_path.is_empty() and ResourceLoader.exists(icon_path):
		tech.icon = load(icon_path)
	
	# Enums
	tech.techniquekind = _parse_enum(data.get("techniquekind", "CONSUMABLE"), TechEnums.TechniqueKind)
	tech.spellschool = _parse_enum(data.get("spellschool", "COMMON"), TechEnums.SpellSchool)
	tech.activationkind = _parse_enum(data.get("activationkind", "NONE"), TechEnums.ActivationKind)
	tech.resourcetype = _parse_enum(data.get("resourcetype", "NONE"), TechEnums.ResourceType)
	tech.material_type = _parse_enum(data.get("poseffect", "NONE"), TechEnums.PosEffectType)
	
		
		
	# Custom fields
	var custom_fields_data = data.get("custom_fields", {})
	if custom_fields_data is Dictionary:
		tech.custom_fields = custom_fields_data.duplicate()
	
	if not existing:
		techs.append(tech)
	
	result.success = true
	return result


## Helper: Import single tech from CSV row
func _import_tech_from_csv_row(data: Dictionary, mode: ImportMode) -> Dictionary:
	# Convert CSV row to same format as JSON dict
	var converted := {}
	
	for key in data.keys():
		var value: String = data[key]
		
		# Convert boolean strings
		if value == "true":
			converted[key] = true
		elif value == "false":
			converted[key] = false
		# Keep as string for enum parsing
		else:
			converted[key] = value
	
	return _import_tech_from_dict(converted, mode)


## Helper: Parse CSV line respecting quoted fields
func _parse_csv_line(line: String) -> Array[String]:
	var result: Array[String] = []
	var current := ""
	var in_quotes := false
	var i := 0
	
	while i < line.length():
		var c := line[i]
		
		if c == "\"":
			if in_quotes and i + 1 < line.length() and line[i + 1] == "\"":
				# Escaped quote
				current += "\""
				i += 1
			else:
				in_quotes = not in_quotes
		elif c == "," and not in_quotes:
			result.append(current)
			current = ""
		else:
			current += c
		
		i += 1
	
	result.append(current)
	return result


## Helper: Parse enum from string name
func _parse_enum(value, enum_type) -> int:
	var value_str := str(value).to_upper()
	var keys: Array = enum_type.keys()
	var index := keys.find(value_str)
	if index >= 0:
		return index
	return 0


## Helper: Parse boolean from various formats
func _parse_bool(value) -> bool:
	if value is bool:
		return value
	var str_value := str(value).to_lower()
	return str_value == "true" or str_value == "1" or str_value == "yes"
