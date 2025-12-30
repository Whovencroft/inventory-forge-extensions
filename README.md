<p align="center">
  <img src="logo.png" alt="Inventory Forge Logo" width="600">
</p>

# Inventory Forge - Item Database Editor for Godot 4.x

**Visual item database editor with multilingual support for RPG and adventure games**

Created by **Menkos** | License: MIT | Version: 1.0.0

---

## Features

- 🎨 Visual item editor integrated into Godot Editor
- 🌍 Multilingual support with translation keys
- 📁 Category system (Equipment, Consumable, Material, Key Item, Scroll/Magic, Misc)
- ⭐ Rarity system with color coding (Common, Uncommon, Rare, Epic, Legendary)
- ⚔️ Equipment stats (ATK, DEF, HP, MP, SPD)
- 🧪 Consumable effects (Heal HP, Heal MP, Buffs, Cure status, etc.)
- 🗝️ Quest item support
- 🔨 Crafting ingredients (structure ready)
- 💾 Auto-save on edit
- 🔧 Configurable database path
- ⚠️ Validation warnings
- 🔍 Search and filter functionality
- 📦 **Completely standalone** - no external dependencies!

---

## Installation

### From Godot AssetLib

1. Open Godot Editor
2. Go to **AssetLib** tab
3. Search for "Inventory Forge"
4. Click **Download** and **Install**
5. Enable the plugin in **Project → Project Settings → Plugins**

### Manual Installation

1. Download the latest release from GitHub
2. Extract the ZIP file
3. Copy the `addons/inventory_forge` folder to your project's `addons/` directory
4. Enable the plugin in **Project → Project Settings → Plugins**

---

## Quick Start

### 1. Enable the Plugin

Go to **Project → Project Settings → Plugins** and enable **"Inventory Forge"**

### 2. Open the Editor

Click on the **"Inventory Forge"** tab in the top bar (next to 2D, 3D, Script, etc.)

### 3. Create Your First Item

1. Click **"+ Nuovo"** (New) button
2. Fill in the item details:
   - **Name Key**: Translation key for the item name (e.g., `ITEM_POTION_NAME`)
   - **Desc Key**: Translation key for description (e.g., `ITEM_POTION_DESC`)
   - **Icon**: Click to select an image, or click **X** to clear
   - **Category**: Choose the item type
3. Changes are saved automatically!

### 4. Configure Database Path (Optional)

Go to **Project → Project Settings → Inventory Forge** to configure:
- `database/path`: Where the item database is saved (default: `res://addons/inventory_forge/demo/demo_database.tres`)
- `editor/auto_save`: Enable/disable auto-save (default: enabled)
- `editor/show_warnings`: Show validation warnings (default: enabled)

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
├── README.md                       # This file
├── resources/                      # Core classes (standalone!)
│   ├── item_enums.gd               # Enums (Category, Rarity, etc.)
│   ├── item_definition.gd          # Single item resource
│   └── item_database.gd            # Items collection
├── demo/                           # Demo files
│   ├── README.md                   # Demo documentation
│   ├── demo_items.gd               # Example usage script
│   ├── demo_database.tres          # Example database with 6 items
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

#### Translation Keys (Not Text)

Items store **keys** that reference translations:

```gdscript
// ItemDefinition properties
name_key: String = "ITEM_POTION_NAME"        // Not "Health Potion"
description_key: String = "ITEM_POTION_DESC"  // Not "Restores 50 HP"
```

At runtime, `tr()` looks up the translation:

```gdscript
tr("ITEM_POTION_NAME")  // → "Health Potion" (if locale=en)
                         // → "Pozione Vita" (if locale=it)
```

#### Translation Functions

The addon provides helper functions:

```gdscript
var item: ItemDefinition = database.get_item_by_id(1)

// Get translated name in current language
var name = item.get_translated_name()  // → "Health Potion" or "Pozione Vita"

// Get translated description
var desc = item.get_translated_description()

// Auto-generate translation keys from base name
item.generate_translation_keys("Magic Sword")
// Creates: ITEM_MAGIC_SWORD_NAME, ITEM_MAGIC_SWORD_DESC
```

### Step-by-Step Setup

#### 1. Create Translation CSV File

Create `translations/items.csv`:

```csv
keys,en,it,es
ITEM_POTION_NAME,Health Potion,Pozione Vita,Poción de Vida
ITEM_POTION_DESC,Restores 50 HP,Ripristina 50 HP,Restaura 50 HP
ITEM_SWORD_NAME,Iron Sword,Spada di Ferro,Espada de Hierro
ITEM_SWORD_DESC,A basic sword +10 ATK,Una spada base +10 ATK,Una espada básica +10 ATK
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
- Right-click CSV → **Reimport**
- Or: **Project → Project Settings → Localization → Translations → Add**

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

Or use GUI: **Project → Project Settings → Localization → Translations**

#### 4. Create Items with Translation Keys

In Inventory Forge:

1. Click **"+ Nuovo"** (New Item)
2. In **"Name Key"** field, enter base name: `"Magic Sword"`
3. Click **"Gen"** button next to the field
4. Addon auto-generates:
   - `name_key`: `ITEM_MAGIC_SWORD_NAME`
   - `description_key`: `ITEM_MAGIC_SWORD_DESC`

**Important:** The base name is only used to generate the key. You must add actual translations to the CSV manually (see step 5).

#### 5. Add Translations to CSV

Open `translations/items.csv` and add the generated keys:

```csv
keys,en,it
ITEM_MAGIC_SWORD_NAME,Magic Sword,Spada Magica
ITEM_MAGIC_SWORD_DESC,A powerful enchanted blade,Una potente lama incantata
```

Save the file. Godot will automatically regenerate the `.translation` files.

### Using Translations in Your Game

#### Option 1: Using ItemDefinition Helper Functions (Recommended)

```gdscript
// Load the database
var database: ItemDatabase = load("res://data/items/item_database.tres")

// Get an item
var item: ItemDefinition = database.get_item_by_id(item_id)

// Use translation functions
var name = item.get_translated_name()
var desc = item.get_translated_description()

// Display in UI
item_label.text = name
description_label.text = desc
```

#### Option 2: Manual tr() Call

```gdscript
var item: ItemDefinition = database.get_item_by_id(item_id)

// Call tr() manually with the keys
var name = tr(item.name_key)        // tr("ITEM_POTION_NAME")
var desc = tr(item.description_key) // tr("ITEM_POTION_DESC")

item_label.text = name
```

### Editor Behavior vs Runtime

#### In Inventory Forge (Godot Editor)

You may see **translation keys** (`ITEM_POTION_NAME`) instead of translated names in the item list.

**Why?** The editor plugin runs in the editor environment where `TranslationServer` may not be fully initialized.

**Impact:** Visual only. Does not affect gameplay.

#### In the Game (Runtime)

✅ Translations work correctly  
✅ `get_translated_name()` returns translated text  
✅ Language changes update all items automatically  

**This is normal and expected behavior.**

### Runtime Language Switching

Change language at runtime:

```gdscript
// Change language globally
TranslationServer.set_locale("it")

// All tr() calls now return Italian
print(tr("ITEM_POTION_NAME"))  // → "Pozione Vita"

// Change back to English
TranslationServer.set_locale("en")
print(tr("ITEM_POTION_NAME"))  // → "Health Potion"
```

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
| `EQUIPMENT` | Weapons, armor, accessories |
| `CONSUMABLE` | Potions, food, items that can be used |
| `MATERIAL` | Crafting materials, resources |
| `KEY_ITEM` | Quest items, keys, story items |
| `SCROLL_MAGIC` | Scrolls, spellbooks, magic items |
| `MISC` | Everything else |

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
| `craftable` | bool | Can be crafted |
| `ingredients` | Array[Dictionary] | Required materials `[{"item_id": 1, "amount": 2}]` |

---

## Demo

The plugin includes a demo in `addons/inventory_forge/demo/`:

- **demo_database.tres**: Example database with 6 items (Health Potion, Iron Sword, Magic Scroll, Quest Key, Leather Armor, Rare Gem)
- **demo_translations.csv**: Example translations (English/Italian)
- **demo_items.gd**: Example script showing how to use the database in your game
- **README.md**: Detailed documentation about the demo items

### Demo Items Included

1. **Health Potion** - Consumable that heals 50 HP
2. **Iron Sword** - Equippable weapon with +10 ATK
3. **Magic Scroll** - Consumable with temporary ATK buff
4. **Ancient Key** - Quest item (non-tradeable)
5. **Leather Armor** - Equippable armor with +15 DEF
6. **Rare Gem** - Craftable material (Legendary rarity)

See `demo/README.md` for full details on each item.

---

## Troubleshooting

### Items don't show in the editor
- Make sure the plugin is enabled in **Project Settings → Plugins**
- Check the Output panel for errors
- Verify the database path in **Project Settings → Inventory Forge → Database → Path**
- Restart Godot

### Translations don't work
- Verify the CSV file is added to **Project Settings → Localization → Translations**
- Check that translation keys in CSV match item name_key/description_key exactly
- Right-click CSV file → **Reimport**
- Restart Godot after adding translations

### Database not saving
- Check file permissions for the database directory
- Verify the database path exists (check **Project Settings → Inventory Forge**)
- Look for errors in the Output panel
- Try changing database path to a writable location

### Editor UI is broken or missing
- Disable and re-enable the plugin in **Project Settings → Plugins**
- Delete `.godot/` folder and restart Godot (rebuilds cache)
- Check for script errors in Output panel
- Try a clean Godot installation

### "Cannot set object script" errors
- Old database file from previous version
- Update database file paths to use `res://addons/inventory_forge/`
- Or create a new database and migrate items manually

---

## Contributing

Contributions are welcome! If you'd like to improve Inventory Forge:

1. Fork the repository on GitHub
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Bug Reports

Found a bug? Please open an issue on GitHub with:
- Godot version
- Steps to reproduce
- Expected vs actual behavior
- Screenshots (if applicable)

---

## Roadmap

Future features being considered:

- [ ] Visual item icon editor/selector
- [ ] Bulk import/export (JSON/CSV)
- [ ] Item templates/presets
- [ ] Advanced crafting recipe editor
- [ ] Item set bonuses system
- [ ] Loot table generator
- [ ] Custom property fields (user-defined)

Suggestions welcome! Open an issue to discuss.

---

## Changelog

### 1.0.0 (2024-12-30)
- ✨ Initial release
- 🎨 Visual item editor integrated in Godot
- 🌍 Multilingual support with translation keys
- 📦 Support for all item properties (Base, Stack, Economy, Rarity, Equipment, Consumable, Quest, Crafting)
- ⚙️ Configurable database path via Project Settings
- 📚 Demo included with 6 example items
- 🔧 Auto-save functionality
- ⚠️ Validation warnings for missing/invalid data
- 🔍 Search and category filter
- ❌ Clear icon button
- 📖 Comprehensive documentation
- 🚀 Completely standalone - no external dependencies

---

## License

MIT License - See [LICENSE](LICENSE) file

Copyright (c) 2024 Menkos

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

---

## Credits

**Created by Menkos**

If you find this plugin useful, please consider:
- ⭐ Starring the repository on GitHub
- 🐛 Reporting issues and bugs
- 💡 Contributing improvements
- 📢 Sharing with other Godot developers
- 🎮 Crediting "Inventory Forge by Menkos" in your game (optional but appreciated!)

---

**Made with ❤️ for the Godot community**
