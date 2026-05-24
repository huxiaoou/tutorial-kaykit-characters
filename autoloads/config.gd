extends Node

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
