extends Node

const XZ_PLANE: Vector3 = Vector3(1, 0, 1)

enum ActorScene {
    BARBARIAN,
    KNIGHT,
    MAGE,
    RANGER,
    ROGUE,
    ROGUE_HOODED,
}

const ACTOR_SCENE_PATHS = {
    ActorScene.BARBARIAN: "res://scenes/characters/Barbarian.tscn",
    ActorScene.KNIGHT: "res://scenes/characters/Knight.tscn",
    ActorScene.MAGE: "res://scenes/characters/Mage.tscn",
    ActorScene.RANGER: "res://scenes/characters/Ranger.tscn",
    ActorScene.ROGUE: "res://scenes/characters/Rogue.tscn",
    ActorScene.ROGUE_HOODED: "res://scenes/characters/Rogue_Hooded.tscn",
}


func get_actor_scene(actor_scene: ActorScene) -> PackedScene:
    return load(ACTOR_SCENE_PATHS.get(actor_scene, ""))


enum Equipment {
    AXE_1HANDED,
    AXE_2HANDED,
    BOW_WITHSTRING,
    CROSSBOW_1HANDED,
    CROSSBOW_2HANDED,
    DAGGER,
    SHIELD_BADGE,
    SHIELD_ROUND,
    SHIELD_ROUND_BARBARIAN,
    SHIELD_SPIKES,
    SPELLBOOK_CLOSED,
    SPELLBOOK_OPEN,
    STAFF,
    SWORD_1HANDED,
    SWORD_2HANDED,
}

const EQUIPMENT_SCENE_PATHS: Dictionary[Equipment, String] = {
    Equipment.AXE_1HANDED: "res://assets/weapons/axe_1handed.gltf",
    Equipment.AXE_2HANDED: "res://assets/weapons/axe_2handed.gltf",
    Equipment.BOW_WITHSTRING: "res://assets/weapons/bow_withString.gltf",
    Equipment.CROSSBOW_1HANDED: "res://assets/weapons/crossbow_1handed.gltf",
    Equipment.CROSSBOW_2HANDED: "res://assets/weapons/crossbow_2handed.gltf",
    Equipment.DAGGER: "res://assets/weapons/dagger.gltf",
    Equipment.SHIELD_BADGE: "res://assets/weapons/shield_badge.gltf",
    Equipment.SHIELD_ROUND: "res://assets/weapons/shield_round.gltf",
    Equipment.SHIELD_ROUND_BARBARIAN: "res://assets/weapons/shield_round_barbarian.gltf",
    Equipment.SHIELD_SPIKES: "res://assets/weapons/shield_spikes.gltf",
    Equipment.SPELLBOOK_CLOSED: "res://assets/weapons/spellbook_closed.gltf",
    Equipment.SPELLBOOK_OPEN: "res://assets/weapons/spellbook_open.gltf",
    Equipment.STAFF: "res://assets/weapons/staff.gltf",
    Equipment.SWORD_1HANDED: "res://assets/weapons/sword_1handed.gltf",
    Equipment.SWORD_2HANDED: "res://assets/weapons/sword_2handed.gltf",
}


func get_equipment_scene(equipment: Equipment) -> PackedScene:
    return load(EQUIPMENT_SCENE_PATHS.get(equipment, ""))


const EQUIPMENT_RES = {
    Equipment.AXE_1HANDED: "res://resources/equipment/axe_1handed.tres",
    Equipment.AXE_2HANDED: "res://resources/equipment/axe_2handed.tres",
    Equipment.BOW_WITHSTRING: "res://resources/equipment/bow_withString.tres",
    Equipment.CROSSBOW_1HANDED: "res://resources/equipment/crossbow_1handed.tres",
    Equipment.CROSSBOW_2HANDED: "res://resources/equipment/crossbow_2handed.tres",
    Equipment.DAGGER: "res://resources/equipment/dagger.tres",
    Equipment.SHIELD_BADGE: "res://resources/equipment/shield_badge.tres",
    Equipment.SHIELD_ROUND: "res://resources/equipment/shield_round.tres",
    Equipment.SHIELD_ROUND_BARBARIAN: "res://resources/equipment/shield_round_barbarian.tres",
    Equipment.SHIELD_SPIKES: "res://resources/equipment/shield_spikes.tres",
    Equipment.SPELLBOOK_CLOSED: "res://resources/equipment/spellbook_closed.tres",
    Equipment.SPELLBOOK_OPEN: "res://resources/equipment/spellbook_open.tres",
    Equipment.STAFF: "res://resources/equipment/staff.tres",
    Equipment.SWORD_1HANDED: "res://resources/equipment/sword_1handed.tres",
    Equipment.SWORD_2HANDED: "res://resources/equipment/sword_2handed.tres",
}


func get_equipment_res(equipment: Equipment) -> DataEquipment:
    return load(EQUIPMENT_RES.get(equipment, "")) as DataEquipment
