# Inventory Forge - Full Documentation

This document contains detailed documentation for Inventory Forge. For quick start, see [README.md](README.md).

---

## Table of Contents

- [File Structure](#file-structure)
- [Usage in Your Game](#usage-in-your-game)
- [Translation Setup](#translation-setup)
- [Item Properties Reference](#item-properties-reference)
- [Loot Tables](#loot-tables)
- [Import/Export](#importexport)
- [Troubleshooting](#troubleshooting)

---

## File Structure

```
addons/inventory_forge/
├── plugin.cfg                      # Plugin configuration
├── plugin.gd                       # Plugin entry point
├── inventory_forge_main.gd         # Main editor panel
├── inventory_forge_main.tscn       # Editor UI scene
├── inventory_forge_settings.gd     # Settings management
├── LICENSE                         # MIT License
├── resources/                      # Core classes (standalone!)
│   ├── item_enums.gd               # Enums (Category, Rarity, MaterialType, etc.)
│   ├── item_definition.gd          # Single item resource
│   ├── item_database.gd            # Items collection with import/export
│   ├── loot_entry.gd               # Single loot table entry
│   ├── loot_table.gd               # Loot table with roll() method
│   └── loot_table_database.gd      # Loot tables collection
├── ui/                             # UI components
│   └── icon_picker_dialog.gd       # Visual icon picker
├── tests/                          # Unit tests (GUT framework)
│   ├── test_item_definition.gd     # ItemDefinition tests
│   ├── test_item_database.gd       # ItemDatabase tests
│   └── test_loot_table.gd          # LootTable tests
├── demo/                           # Demo files
│   ├── README.md                   # Demo documentation
│   ├── demo_items.gd               # Example usage script
│   ├── demo_database.tres          # Example database with items
│   └── demo_translations.csv       # Example translations (EN/IT)
├── icons/
│   ├── inventory_forge_icon.svg    # Plugin icon
│   └── placeholder_item.svg        # Placeholder icon for items
└── screenshot/
    └── dashboard.png               # Plugin screenshot
```

---

## Usage in Your Game

### Loading the Database

```gdscript
# In your game code
const DATABASE_PATH := "res://data/items/item_database.tres"
var database: ItemDatabase

func _ready() -> void:
    database = load(DATABASE_PATH) as ItemDatabase
    print("Loaded %d items" % database.items.size())
```

### Getting an Item

```gdscript
# By ID
var potion = database.get_item_by_id(1)
print(potion.get_translated_name())  # "Health Potion" (translated)

# By category
var weapons = database.get_items_by_category(ItemEnums.Category.EQUIPMENT)

# By rarity
var rare_items = database.get_items_by_rarity(ItemEnums.Rarity.RARE)
```

### Using Item Data

```gdscript
var item = database.get_item_by_id(item_id)

# Get translated name and description
var name = item.get_translated_name()
var desc = item.get_translated_description()

# Check item properties
if item.consumable:
    match item.effect_type:
        ItemEnums.EffectType.HEAL_HP:
            player.heal(item.effect_value)
        ItemEnums.EffectType.BUFF_ATK:
            player.add_buff("atk", item.effect_value, item.effect_duration)

if item.equippable:
    player.equip(item)
    player.stats.atk += item.stat_atk
    player.stats.def += item.stat_def
```

### Searching Items

```gdscript
# Search by name
var results = database.search_items("sword")

# Filter by category and search
var filtered = database.filter_items(
    ItemEnums.Category.EQUIPMENT,  # Category filter (-1 for all)
    "iron"                          # Search query
)
```

---

## Translation Setup

Inventory Forge has **native multilingual support** through Godot's TranslationServer. Items store **translation keys** instead of hardcoded text, allowing automatic language switching at runtime.

### How Translation Works

Items store **keys** that reference translations:

```gdscript
# ItemDefinition properties
name_key: String = "ITEM_POTION_NAME"        # Not "Health Potion"
description_key: String = "ITEM_POTION_DESC"  # Not "Restores 50 HP"
```

At runtime, `tr()` looks up the translation:

```gdscript
tr("ITEM_POTION_NAME")  # -> "Health Potion" (if locale=en)
                         # -> "Pozione Vita" (if locale=it)
```

### Translation Functions

The addon provides helper functions:

```gdscript
var item: ItemDefinition = database.get_item_by_id(1)

# Get translated name in current language
var name = item.get_translated_name()  # -> "Health Potion" or "Pozione Vita"

# Get translated description
var desc = item.get_translated_description()

# Auto-generate translation keys from base name
item.generate_translation_keys("Magic Sword")
# Creates: ITEM_MAGIC_SWORD_NAME, ITEM_MAGIC_SWORD_DESC
```

### Step-by-Step Setup

#### 1. Create Translation CSV File

Create `translations/items.csv`:

```csv
keys,en,it,es
ITEM_POTION_NAME,Health Potion,Pozione Vita,Pocion de Vida
ITEM_POTION_DESC,Restores 50 HP,Ripristina 50 HP,Restaura 50 HP
ITEM_SWORD_NAME,Iron Sword,Spada di Ferro,Espada de Hierro
ITEM_SWORD_DESC,A basic sword +10 ATK,Una spada base +10 ATK,Una espada basica +10 ATK
```

**CSV Structure:**
- **First row:** `keys` + language codes (`en`, `it`, `es`)
- **Following rows:** Translation key + translations for each language

#### 2. Import Translations in Godot

Godot automatically imports CSV files and generates `.translation` files:

1. Save the CSV in your project's `translations/` folder
2. Godot creates `.csv.import` metadata
3. Godot generates `.translation` files (one per language):
   - `items.en.translation`
   - `items.it.translation`
   - `items.es.translation`

**Manual import (if needed):**
- Right-click CSV -> **Reimport**
- Or: **Project -> Project Settings -> Localization -> Translations -> Add**

#### 3. Register Translation Files

Add to `project.godot`:

```ini
[internationalization]
locale/translations=PackedStringArray(
    "res://translations/items.en.translation",
    "res://translations/items.it.translation"
)
locale/fallback="en"
```

Or use GUI: **Project -> Project Settings -> Localization -> Translations**

#### 4. Create Items with Translation Keys

In Inventory Forge:

1. Click **"+ Nuovo"** (New Item)
2. In **"Name Key"** field, enter base name: `"Magic Sword"`
3. Click **"Gen"** button next to the field
4. Addon auto-generates:
   - `name_key`: `ITEM_MAGIC_SWORD_NAME`
   - `description_key`: `ITEM_MAGIC_SWORD_DESC`

**Important:** The base name is only used to generate the key. You must add actual translations to the CSV manually.

### Runtime Language Switching

```gdscript
# Change language globally
TranslationServer.set_locale("it")

# All tr() calls now return Italian
print(tr("ITEM_POTION_NAME"))  # -> "Pozione Vita"

# Change back to English
TranslationServer.set_locale("en")
print(tr("ITEM_POTION_NAME"))  # -> "Health Potion"
```

### Editor vs Runtime Behavior

In the Godot Editor, you may see translation keys (`ITEM_POTION_NAME`) instead of translated names. This is normal - translations work correctly at runtime.

---

## Item Properties Reference

### Base

| Property | Type | Description |
|----------|------|-------------|
| `id` | int | Unique item identifier (auto-assigned) |
| `name_key` | String | Translation key for item name |
| `description_key` | String | Translation key for description |
| `icon` | Texture2D | Item icon (recommended: 64x64 or 32x32) |
| `category` | Category | Item type (see Categories) |

### Categories

| Value | Description |
|-------|-------------|
| `CONSUMABLE` | Potions, food, items that can be used |
| `EQUIPMENT` | Weapons, armor, accessories |
| `KEY_ITEM` | Quest items, keys, story items |
| `SCROLL_MAGIC` | Scrolls, spellbooks, magic items |
| `MISC` | Everything else, crafting materials |

> **Note:** Crafting materials use the `is_ingredient` flag and `material_type` property instead of a separate category.

### Stack

| Property | Type | Description |
|----------|------|-------------|
| `stack_capacity` | int | Max items per stack (default: 99) |
| `stack_count_limit` | int | Max stacks allowed (0 = unlimited) |

### Economy

| Property | Type | Description |
|----------|------|-------------|
| `buy_price` | int | Shop purchase price |
| `sell_price` | int | Shop sell price |
| `tradeable` | bool | Can be traded between players |

### Rarity

| Property | Type | Description |
|----------|------|-------------|
| `rarity` | Rarity | Item rarity (affects color) |
| `required_level` | int | Minimum level to use |

| Rarity | Color |
|--------|-------|
| `COMMON` | White |
| `UNCOMMON` | Green |
| `RARE` | Blue |
| `EPIC` | Purple |
| `LEGENDARY` | Orange |

### Equipment

| Property | Type | Description |
|----------|------|-------------|
| `equippable` | bool | Can be equipped |
| `equip_slot` | EquipSlot | Equipment slot (HEAD, BODY, WEAPON, etc.) |
| `stat_atk` | int | Attack bonus |
| `stat_def` | int | Defense bonus |
| `stat_hp` | int | HP bonus |
| `stat_mp` | int | MP bonus |
| `stat_spd` | int | Speed bonus |

### Consumable

| Property | Type | Description |
|----------|------|-------------|
| `consumable` | bool | Can be consumed |
| `effect_type` | EffectType | Effect when consumed |
| `effect_value` | int | Effect strength |
| `effect_duration` | float | Duration in seconds (0 = instant) |

| Effect Type | Description |
|-------------|-------------|
| `HEAL_HP` | Restore HP |
| `HEAL_MP` | Restore MP |
| `HEAL_BOTH` | Restore HP and MP |
| `BUFF_ATK` | Temporary ATK boost |
| `BUFF_DEF` | Temporary DEF boost |
| `BUFF_SPD` | Temporary SPD boost |
| `CURE_POISON` | Cure poison status |
| `CURE_ALL` | Cure all negative statuses |
| `DAMAGE` | Deal damage (bombs) |
| `TELEPORT` | Teleport effect |
| `REVIVE` | Revive fallen ally |

### Quest

| Property | Type | Description |
|----------|------|-------------|
| `quest_item` | bool | Required for a quest |
| `quest_id` | String | Associated quest ID |

### Crafting

| Property | Type | Description |
|----------|------|-------------|
| `is_ingredient` | bool | Can be used as crafting material |
| `material_type` | MaterialType | Type of material (ORE, HERB, WOOD, etc.) |
| `craftable` | bool | Can be crafted |
| `ingredients` | Array[Dictionary] | Required materials `[{"item_id": 1, "amount": 2}]` |

| Material Type | Description |
|---------------|-------------|
| `NONE` | Not a material |
| `ORE` | Metal ores and minerals |
| `HERB` | Plants and herbs |
| `WOOD` | Wood and timber |
| `LEATHER` | Animal hides |
| `CLOTH` | Fabric and textiles |
| `GEM` | Gems and crystals |
| `LIQUID` | Potions base, oils |
| `COMPONENT` | Mechanical parts |
| `FOOD` | Food ingredients |
| `MAGICAL` | Magical essences |
| `MISC` | Other materials |

### Custom Fields

| Property | Type | Description |
|----------|------|-------------|
| `custom_fields` | Dictionary | User-defined properties |

**Helper Methods:**

```gdscript
# Get/Set custom fields
item.set_custom("damage_type", "fire")
var dmg_type = item.get_custom("damage_type", "normal")

# Type-safe getters
var cooldown = item.get_custom_float("cooldown", 1.0)
var is_unique = item.get_custom_bool("is_unique", false)
var bonus = item.get_custom_int("bonus_damage", 0)

# Check and remove
if item.has_custom("special_effect"):
    item.remove_custom("special_effect")

# Merge multiple fields
item.merge_custom_fields({"key1": "val1", "key2": 42})
```

---

## Loot Tables

Inventory Forge includes a complete loot table system for random item drops. Perfect for chests, enemy loot, quest rewards, and more.

### Creating a Loot Table

1. Open the **"Loot Tables"** tab in Inventory Forge
2. Click **"+ New"** to create a new table
3. Set the table properties:
   - **ID**: Unique identifier (e.g., `chest_common`, `goblin_loot`)
   - **Name**: Display name for reference
   - **Description**: Notes about when this table is used

### Rarity Presets

Use **Rarity Presets** for quick configuration with balanced drop settings:

| Preset | Empty Chance | Drops | Best For |
|--------|--------------|-------|----------|
| **Custom** | Manual | Manual | Full control |
| **Common** | 0% | 1-2 | Regular enemies, basic chests |
| **Uncommon** | 20% | 1-2 | Elite enemies, hidden chests |
| **Rare** | 70% | 1 | Mini-bosses, rare containers |
| **Epic** | 90% | 1 | Bosses, special events |
| **Legendary** | 98% | 1 | World bosses, unique drops |

### Drop Settings

| Setting | Description |
|---------|-------------|
| **Drops (min-max)** | Number of items rolled per drop (1-10) |
| **Empty Chance** | Probability that nothing drops (0-100%) |
| **Allow Duplicates** | Same item can drop multiple times in one roll |

### Adding Entries

1. Click **"+ Add Entry"**
2. Select an item from the dropdown
3. Set the **weight** (relative probability)
4. Set **quantity range** (min-max per roll)

**Weight System:** Weights are relative, not percentages.

Example with 3 entries:
- Item A: weight 10 → 49.75%
- Item B: weight 10 → 49.75%
- Item C: weight 0.1 → 0.5%

### Sub-Tables (Modular Loot)

**Sub-Tables** allow you to compose complex loot by chaining multiple tables together.

Instead of one messy table, split into focused tables:

```
goblin_common (Rarity: Common)
├── Gold Coins
└── Health Potion

goblin_equipment (Rarity: Uncommon)
├── Iron Sword
└── Leather Armor

goblin_rare (Rarity: Epic)
├── Rare Gem
└── Legendary Ring

goblin_master (Sub-Tables only)
└── Sub-Tables: [goblin_common, goblin_equipment, goblin_rare]
```

When you call `roll_table_full()`, all sub-tables are rolled and results combined.

### Using Loot Tables in Code

```gdscript
# Load the loot table database
var loot_db: LootTableDatabase = load("res://data/loot_database.tres")

# Roll a single table (without sub-tables)
var result = loot_db.roll_table("chest_common")

# Roll table WITH all its sub-tables
var result = loot_db.roll_table_full("goblin_master")

# Process drops
if result.is_empty():
    print("Nothing dropped!")
else:
    for drop in result.items:
        var item: ItemDefinition = drop.item
        var quantity: int = drop.quantity
        print("Dropped: %s x%d" % [item.get_translated_name(), quantity])
```

### LootTable Properties Reference

| Property | Type | Description |
|----------|------|-------------|
| `id` | String | Unique table identifier |
| `name` | String | Display name |
| `description` | String | Usage description |
| `rarity_tier` | RarityTier | Preset configuration |
| `entries` | Array[LootEntry] | Drop entries |
| `min_drops` | int | Minimum items per roll (0-10) |
| `max_drops` | int | Maximum items per roll (0-10) |
| `empty_chance` | float | Chance of no drops (0.0-1.0) |
| `allow_duplicates` | bool | Same item can drop multiple times |
| `sub_table_ids` | Array[String] | IDs of tables to roll together |

### LootEntry Properties Reference

| Property | Type | Description |
|----------|------|-------------|
| `item` | ItemDefinition | The item that can drop |
| `weight` | float | Drop weight (higher = more likely) |
| `min_quantity` | int | Minimum drop quantity |
| `max_quantity` | int | Maximum drop quantity |
| `enabled` | bool | Entry is active |

### LootTableDatabase Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `get_table_by_id(id)` | LootTable | Get table by ID |
| `roll_table(id)` | LootResult | Roll table without sub-tables |
| `roll_table_full(id)` | LootResult | Roll table with all sub-tables |
| `roll_tables(ids)` | LootResult | Roll multiple tables |
| `roll_tables_full(ids)` | LootResult | Roll multiple tables with sub-tables |
| `create_new_table()` | LootTable | Create and add new table |
| `duplicate_table(table)` | LootTable | Duplicate existing table |
| `remove_table(table)` | bool | Remove table from database |

### Best Practices

1. **Use Rarity Presets** for consistent balancing
2. **Split complex loot into sub-tables** for easier maintenance
3. **Keep drops low (1-3)** for regular enemies
4. **Use sub-tables** to share common drops
5. **Test frequently** with the Roll button
6. **Name tables clearly** (e.g., `zone_forest_common`)

---

## Import/Export

Both Items and Loot Tables support import/export in JSON and CSV formats.

### Items - JSON Format

```json
{
  "version": "1.0",
  "items": [
    {
      "id": 1,
      "name_key": "ITEM_SWORD",
      "category": "EQUIPMENT",
      "rarity": "RARE",
      "equippable": true,
      "stat_atk": 10,
      "custom_fields": {"damage_type": "physical"}
    }
  ]
}
```

### Loot Tables - JSON Format

```json
{
  "version": "1.0",
  "loot_tables": [
    {
      "id": "chest_common",
      "name": "Common Chest",
      "rarity_tier": "COMMON",
      "min_drops": 1,
      "max_drops": 2,
      "empty_chance": 0.0,
      "allow_duplicates": true,
      "sub_table_ids": ["bonus_gold"],
      "entries": [
        {"item_id": 1, "weight": 10.0, "min_quantity": 1, "max_quantity": 2, "enabled": true}
      ]
    }
  ]
}
```

### Import Modes

- **Replace All**: Clear database and import
- **Skip Existing**: Keep existing, add new ones
- **Overwrite Existing**: Update existing, add new ones

### CSV Format

**Items CSV** - One item per row with all properties as columns.

**Loot Tables CSV** - Entries serialized as `item_id:weight:min_qty:max_qty:enabled` separated by semicolons.

**Note:** When importing loot tables, entries reference items by ID. Make sure the Item Database contains the referenced items first.

---

## Troubleshooting

### Items don't show in the editor
- Make sure the plugin is enabled in **Project Settings -> Plugins**
- Check the Output panel for errors
- Verify the database path in **Project Settings -> Inventory Forge -> Database -> Path**
- Restart Godot

### Translations don't work
- Verify the CSV file is added to **Project Settings -> Localization -> Translations**
- Check that translation keys in CSV match item name_key/description_key exactly
- Right-click CSV file -> **Reimport**
- Restart Godot after adding translations

### Database not saving
- Check file permissions for the database directory
- Verify the database path exists (check **Project Settings -> Inventory Forge**)
- Look for errors in the Output panel
- Try changing database path to a writable location

### Editor UI is broken or missing
- Disable and re-enable the plugin in **Project Settings -> Plugins**
- Delete `.godot/` folder and restart Godot (rebuilds cache)
- Check for script errors in Output panel

### "Cannot set object script" errors
- Old database file from previous version
- Update database file paths to use `res://addons/inventory_forge/`
- Or create a new database and migrate items manually
