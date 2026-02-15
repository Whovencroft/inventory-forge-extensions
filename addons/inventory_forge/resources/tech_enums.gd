@tool
class_name TechEnums
extends RefCounted
## Shared enums for the technique systems.
## Used by TechDefinition, TechDatabase, and the editor.
##
## Plugin extension by Whovencroft
## License: MIT


## Technique category
enum TechniqueKind { 
	SPELL,         ## Magical techniques 
	SKILL,         ## Skills
	ABILITY,       ## Abilities
	TECH,          ## and Techniques are catch-alls for various non-magical styles
}


## Spell 'schools'/'styles'
enum SpellSchool {
	NONE,
	ARCANE,       ## To facilitate D&D style spellschools
	DIVINE,
	NATURE,
	PSIONIC,
	TECH,         ## Technology based magic
	OTHER,        ## Entry field for extended options
}

## How is the technique used 
enum ActivationKind {
	ACTIVE,       ## Used as an action
	PASSIVE,      ## Always on
	TOGGLE,       ## Toggled on/off
	REACTION,     ## In response to an action
}

## Resource to be spent
enum ResourceType {
	NONE,
	MP,           ## Spends MP to be used
	HP,           ## Spends HP to be used
	SP,           ## Spends SP to be used
	AP,           ## Spends AP to be used
	TP,           ## Spends TP to be used
	OTHER,        ## Entry field for extended options
}

## Positive effect types (shamefully copied, but if it works it works)
enum PosEffectType {
	NONE,          ## No effect
	HEAL_HP,       ## Heal HP
	HEAL_MP,       ## Heal MP
	HEAL_BOTH,     ## Heal HP and MP
	BUFF_ATK,      ## Temporary attack buff
	BUFF_DEF,      ## Temporary defense buff
	BUFF_SPD,      ## Temporary speed buff
	CURE_POISON,   ## Cure poison
	CURE_ALL,      ## Cure all negative statuses
	TELEPORT,      ## Teleportation
	REVIVE,        ## Revive
}

enum NegEffectType {
	NONE,
	DAMAGE_HP,     ## Deal damage (bombs, etc.)
	DAMAGE_MP,     ## Siphon MP effects
	DAMAGE_HPMP,   ## Hit both
	DAMAGE_ALL,    ## Hit all resources, HP, MP, TP, SP, AP
	DEBUFF_ATK,    ## Temporary attack debuff
	DEBUFF_DEF,    ## Temporary defense debuff
	DEBUFF_SPD,    ## Temporary speed debuff
	CAUSE_DOT,     ## Any damage-over-time effect
	CAUSE_OTHER,   ## Non-specific harmful effects

}

## Passive effect type (I'll be back to change these)
enum PassiveType {
	NONE,              ## No passive effect
	LIFESTEAL,         ## Heal on hit (% of damage)
	FIRE_DAMAGE,       ## Bonus fire damage
	ICE_DAMAGE,        ## Bonus ice damage
	LIGHTNING_DAMAGE,  ## Bonus lightning damage
	POISON_DAMAGE,     ## Bonus poison damage
	CRITICAL_CHANCE,   ## Bonus critical hit chance
	CRITICAL_DAMAGE,   ## Bonus critical damage multiplier
	DODGE_CHANCE,      ## Chance to dodge attacks
	BLOCK_CHANCE,      ## Chance to block attacks
	HP_REGEN,          ## HP regeneration per turn
	MP_REGEN,          ## MP regeneration per turn
	FIRE_RESIST,       ## Fire damage resistance
	ICE_RESIST,        ## Ice damage resistance
	LIGHTNING_RESIST,  ## Lightning damage resistance
	POISON_RESIST,     ## Poison damage resistance
	STUN_RESIST,       ## Stun resistance
	THORNS,            ## Reflect damage to attacker
	OTHER,             ## Entry field for extended options
}

enum TargetType {
	SELF,            ## Target only the user
	ALLY,            ## Target an ally
	ENEMY,           ## Target an enemy
	AREA,            ## Target an area
	ALL_ALLIES,      ## Target all allies
	ALL_ENEMIES,     ## Target all enemies
	ANY,             ## Target an ally or enemy
	ALL,             ## Target all allies and enemies
	OTHER,           ## Target in some other combination (1 ally and 1 enemy, self and enemies, etc)
}

## Helper: Gets the translated type name
static func get_technique_type(techniquekind: TechniqueKind) -> String:
	match techniquekind:
		TechniqueKind.SPELL: return "TECHNIQUE_TYPE_SPELL"
		TechniqueKind.SKILL: return "TECHNIQUE_TYPE_SKILL"
		TechniqueKind.ABILITY: return "TECHNIQUE_TYPE_ABILITY"
		TechniqueKind.TECH: return "TECHNIQUE_TYPE_TECH"
		_: return "TECHNIQUE_TYPE_UNKNOWN"


## Helper: Gets the translated school name
static func get_spell_school(spellschool: SpellSchool) -> String:
	match spellschool:
		SpellSchool.NONE: return "SPELL_SCHOOL_NONE"
		SpellSchool.ARCANE: return "SPELL_SCHOOL_ARCANE"
		SpellSchool.DIVINE: return "SPELL_SCHOOL_DIVINE"
		SpellSchool.NATURE: return "SPELL_SCHOOL_NATURE"
		SpellSchool.PSIONIC: return "SPELL_SCHOOL_PSIONIC"
		SpellSchool.TECH: return "SPELL_SCHOOL_TECH"
		SpellSchool.OTHER: return "SPELL_SCHOOL_OTHER"
		_: return "SPELL_SCHOOL_UNKNOWN"


## Helper: Gets the color associated with the school
static func get_spell_school_color(spellschool: SpellSchool) -> Color:
	match spellschool:
		SpellSchool.NONE: return Color.WHITE
		SpellSchool.ARCANE: return Color.PURPLE
		SpellSchool.DIVINE: return Color.YELLOW
		SpellSchool.NATURE: return Color.WEB_GREEN
		SpellSchool.PSIONIC: return Color.PALE_TURQUOISE
		SpellSchool.TECH: return Color.SLATE_GRAY
		SpellSchool.OTHER: return Color.DARK_GRAY
		_: return Color.WHITE


## Helper : Gets the translated activation type
static func get_activation_type(activationkind: ActivationKind) -> String:
	match activationkind:
		ActivationKind.ACTIVE: return "ACTIVATION_KIND_ACTIVE"
		ActivationKind.PASSIVE: return "ACTIVATION_KIND_PASSIVE"
		ActivationKind.TOGGLE: return "ACTIVATION_KIND_TOGGLE"
		ActivationKind.REACTION: return "ACTIVATION_KIND_REACTION"
		_: return "ACTIVATION_KIND_UNKNOWN"
	
## Helper: Gets the translated resource name
static func get_resource_type(resourcetype: ResourceType) -> String:
	match resourcetype:
		ResourceType.NONE: return "RESOURCE_TYPE_NONE"
		ResourceType.MP: return "RESOURCE_TYPE_MP"
		ResourceType.HP: return "RESOURCE_TYPE_HP"
		ResourceType.SP: return "RESOURCE_TYPE_SP"
		ResourceType.AP: return "RESOURCE_TYPE_AP"
		ResourceType.TP: return "RESOURCE_TYPE_TP"
		ResourceType.OTHER: return "RESOURCE_TYPE_OTHER"
		_: return "RESOURCE_TYPE_UNKNOWN"


## Helper: Gets the translated positive effect type name
static func get_poseffect_type_name(poseffect: PosEffectType) -> String:
	match poseffect:
		PosEffectType.NONE: return "POSITIVE_EFFECT_NONE"
		PosEffectType.HEAL_HP: return "POSITIVE_EFFECT_HEAL_HP"
		PosEffectType.HEAL_MP: return "POSITIVE_EFFECT_HEAL_MP"
		PosEffectType.HEAL_BOTH: return "POSITIVE_EFFECT_HEAL_BOTH"
		PosEffectType.BUFF_ATK: return "POSITIVE_EFFECT_BUFF_ATK"
		PosEffectType.BUFF_DEF: return "POSITIVE_EFFECT_BUFF_DEF"
		PosEffectType.BUFF_SPD: return "POSITIVE_EFFECT_BUFF_SPD"
		PosEffectType.CURE_POISON: return "POSITIVE_EFFECT_CURE_POISON"
		PosEffectType.CURE_ALL: return "POSITIVE_EFFECT_CURE_ALL"
		PosEffectType.TELEPORT: return "POSITIVE_EFFECT_TELEPORT"
		PosEffectType.REVIVE: return "POSITIVE_EFFECT_REVIVE"
		_: return "POSITIVE_EFFECT_UNKNOWN"

## Helper: Gets the translated positive effect type name
static func get_negeffect_type_name(negeffect: NegEffectType) -> String:
	match negeffect:
		NegEffectType.NONE: return "NEGATIVE_EFFECT_NONE"
		NegEffectType.DAMAGE_HP: return "NEGATIVE_EFFECT_DAMAGE_HP"
		NegEffectType.DAMAGE_MP: return "NEGATIVE_EFFECT_DAMAGE_MP"
		NegEffectType.DAMAGE_HPMP: return "NEGATIVE_EFFECT_DAMAGE_HPMP"
		NegEffectType.DAMAGE_ALL: return "NEGATIVE_EFFECT_DAMAGE_ALL"
		NegEffectType.DEBUFF_ATK: return "NEGATIVE_EFFECT_DEBUFF_ATK"
		NegEffectType.DEBUFF_DEF: return "NEGATIVE_EFFECT_DEBUFF_DEF"
		NegEffectType.DEBUFF_SPD: return "NEGATIVE_EFFECT_DEBUFF_SPD"
		NegEffectType.CAUSE_DOT: return "NEGATIVE_EFFECT_CAUSE_DOT"
		NegEffectType.CAUSE_OTHER: return "NEGATIVE_EFFECT_CAUSE_OTHER"
		_: return "NEGATIVE_EFFECT_UNKNOWN"



## Helper: Gets the translated passive type name
static func get_passive_type_name(passive: PassiveType) -> String:
	match passive:
		PassiveType.NONE: return "PASSIVE_NONE"
		PassiveType.LIFESTEAL: return "PASSIVE_LIFESTEAL"
		PassiveType.FIRE_DAMAGE: return "PASSIVE_FIRE_DAMAGE"
		PassiveType.ICE_DAMAGE: return "PASSIVE_ICE_DAMAGE"
		PassiveType.LIGHTNING_DAMAGE: return "PASSIVE_LIGHTNING_DAMAGE"
		PassiveType.POISON_DAMAGE: return "PASSIVE_POISON_DAMAGE"
		PassiveType.CRITICAL_CHANCE: return "PASSIVE_CRITICAL_CHANCE"
		PassiveType.CRITICAL_DAMAGE: return "PASSIVE_CRITICAL_DAMAGE"
		PassiveType.DODGE_CHANCE: return "PASSIVE_DODGE_CHANCE"
		PassiveType.BLOCK_CHANCE: return "PASSIVE_BLOCK_CHANCE"
		PassiveType.HP_REGEN: return "PASSIVE_HP_REGEN"
		PassiveType.MP_REGEN: return "PASSIVE_MP_REGEN"
		PassiveType.FIRE_RESIST: return "PASSIVE_FIRE_RESIST"
		PassiveType.ICE_RESIST: return "PASSIVE_ICE_RESIST"
		PassiveType.LIGHTNING_RESIST: return "PASSIVE_LIGHTNING_RESIST"
		PassiveType.POISON_RESIST: return "PASSIVE_POISON_RESIST"
		PassiveType.STUN_RESIST: return "PASSIVE_STUN_RESIST"
		PassiveType.THORNS: return "PASSIVE_THORNS"
		_: return "PASSIVE_UNKNOWN"


## Helper: Gets display name for passive (non-translated, for editor)
static func get_passive_display_name(passive: PassiveType) -> String:
	match passive:
		PassiveType.NONE: return "None"
		PassiveType.LIFESTEAL: return "Lifesteal"
		PassiveType.FIRE_DAMAGE: return "Fire Damage"
		PassiveType.ICE_DAMAGE: return "Ice Damage"
		PassiveType.LIGHTNING_DAMAGE: return "Lightning Damage"
		PassiveType.POISON_DAMAGE: return "Poison Damage"
		PassiveType.CRITICAL_CHANCE: return "Critical Chance"
		PassiveType.CRITICAL_DAMAGE: return "Critical Damage"
		PassiveType.DODGE_CHANCE: return "Dodge Chance"
		PassiveType.BLOCK_CHANCE: return "Block Chance"
		PassiveType.HP_REGEN: return "HP Regen"
		PassiveType.MP_REGEN: return "MP Regen"
		PassiveType.FIRE_RESIST: return "Fire Resist"
		PassiveType.ICE_RESIST: return "Ice Resist"
		PassiveType.LIGHTNING_RESIST: return "Lightning Resist"
		PassiveType.POISON_RESIST: return "Poison Resist"
		PassiveType.STUN_RESIST: return "Stun Resist"
		PassiveType.THORNS: return "Thorns"
		_: return "Unknown"


## Helper: Gets translated target type
static func get_target_type(target: TargetType) -> String:
	match target:
		TargetType.SELF: return "TARGET_SELF"
		TargetType.ALLY: return "TARGET_ALLY"
		TargetType.ENEMY: return "TARGET_ENEMY"
		TargetType.AREA: return "TARGET_AREA"
		TargetType.ALL_ALLIES: return "TARGET_ALL_ALLIES"
		TargetType.ALL_ENEMIES: return "TARGET_ALL_ENEMIES"
		TargetType.ANY: return "TARGET_ANY"
		TargetType.ALL: return "TARGET_ALL"
		TargetType.OTHER: return "TARGET_OTHER"
		_: return "TARGET_UNKNOWN"
