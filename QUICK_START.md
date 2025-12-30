# Inventory Forge - Quick Start Guide

## 🎯 For AssetLib Users

### Download & Install
1. Download: `inventory_forge_v1.0.0_assetlib.zip`
2. Extract to your project: `your_project/addons/`
3. Result: `your_project/addons/inventory_forge/`
4. In Godot: **Project → Project Settings → Plugins → Enable "Inventory Forge"**

### First Steps
1. Click **"Inventory Forge"** tab (top bar, next to 2D/3D/Script)
2. You'll see 6 demo items pre-loaded
3. Click **"+ Nuovo"** to create your first item
4. Fill in details and save (auto-saves!)

---

## 🎯 For GitHub Users

### Download & Install
1. Download: `inventory_forge_v1.0.0_github.zip`
2. Extract the `addons` folder to your project root
3. In Godot: **Project → Project Settings → Plugins → Enable "Inventory Forge"**

### Verify Installation
```
your_project/
├── addons/
│   └── inventory_forge/
│       ├── plugin.cfg          ← Should exist
│       ├── README.md            ← Full documentation
│       └── demo/
│           └── demo_database.tres  ← 6 example items
```

---

## 📚 Quick Reference

### Create an Item
1. Click **"+ Nuovo"** (New)
2. Enter item name in **Name Key** field
3. Click **"Gen"** to auto-generate translation keys
4. Click **Icon button** to select image (or **X** to clear)
5. Set **Category** and other properties
6. Done! (Auto-saved)

### Use in Your Game
```gdscript
# Load database
var db: ItemDatabase = load("res://addons/inventory_forge/demo/demo_database.tres")

# Get item by ID
var item = db.get_item_by_id(1)

# Get translated name
print(item.get_translated_name())  # "Health Potion"
```

### Configure Database Path
1. **Project → Project Settings → Inventory Forge → Database → Path**
2. Default: `res://addons/inventory_forge/demo/demo_database.tres`
3. Change to your custom path (e.g., `res://data/items/my_items.tres`)

---

## 🌍 Translations Setup

### 1. Create CSV File
Create `translations/items.csv`:
```csv
keys,en,it
ITEM_POTION_NAME,Health Potion,Pozione Vita
ITEM_POTION_DESC,Restores 50 HP,Ripristina 50 HP
```

### 2. Register in Godot
**Project → Project Settings → Localization → Translations → Add:**
- `res://translations/items.en.translation`
- `res://translations/items.it.translation`

### 3. Use in Game
```gdscript
# Change language
TranslationServer.set_locale("it")

# Get translated text
var item = db.get_item_by_id(1)
print(item.get_translated_name())  # "Pozione Vita"
```

---

## 🎨 Demo Items Included

| ID | Name | Category | Features |
|----|------|----------|----------|
| 1 | Health Potion | Consumable | Heals 50 HP, stackable (99) |
| 2 | Iron Sword | Equipment | +10 ATK, weapon slot |
| 3 | Magic Scroll | Scroll/Magic | ATK buff (+20, 30s) |
| 4 | Ancient Key | Key Item | Quest item, non-tradeable |
| 5 | Leather Armor | Equipment | +15 DEF, requires Lv.5 |
| 6 | Rare Gem | Material | Craftable, legendary |

---

## ❓ Common Issues

### "Plugin doesn't appear in Plugins list"
- Make sure folder is `addons/inventory_forge/` (not `addons/addons/inventory_forge/`)
- Restart Godot Editor

### "Items list is empty"
- Check database path: **Project Settings → Inventory Forge → Database → Path**
- Default demo database: `res://addons/inventory_forge/demo/demo_database.tres`

### "Translations don't work"
- Verify CSV is imported (should create `.translation` files)
- Check keys match exactly in CSV and items
- Right-click CSV → **Reimport**

---

## 📖 Full Documentation

- **README.md** - Complete guide in `addons/inventory_forge/README.md`
- **Demo README** - Demo details in `addons/inventory_forge/demo/README.md`
- **Release Notes** - See `RELEASE_NOTES.md`

---

## 💡 Tips

✅ **Auto-save is ON by default** - Changes save automatically  
✅ **Use "Gen" button** - Auto-generates translation keys from names  
✅ **X button clears icons** - Quick way to remove item icons  
✅ **Search works** - Type in search box to filter items  
✅ **Warnings help** - Red warnings at bottom show validation issues  

---

## 🆘 Support

- **Bug Reports:** GitHub Issues
- **Questions:** Check README.md first
- **Feature Requests:** GitHub Issues with [Feature] tag

---

**Happy Item Creating! 🎮**

Made with ❤️ by Menkos
