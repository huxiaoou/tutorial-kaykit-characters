extends Resource

class_name DataEquipment

enum EquipmentSlot {
    HANDSLOT_R,
    HANDSLOT_L,
}

@export var scene: PackedScene = preload("res://assets/weapons/axe_1handed.gltf")
@export var slot: EquipmentSlot = EquipmentSlot.HANDSLOT_R
@export var rotation_degrees: Vector3 = Vector3(0, 180, 0)

var slot_bone_name: String = "":
    get:
        return _get_equipment_slot_bone_name()


func _get_equipment_slot_bone_name() -> String:
    match slot:
        EquipmentSlot.HANDSLOT_R:
            return "handslot.r"
        EquipmentSlot.HANDSLOT_L:
            return "handslot.l"
    return ""


func get_equipment_instance() -> Node3D:
    var equipment: Node3D = scene.instantiate()
    equipment.rotation_degrees = rotation_degrees
    return equipment
