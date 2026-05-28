extends Resource

class_name DataEquipment

enum EquipmentSlot {
    HANDSLOT_R,
    HANDSLOT_L,
}

@export var equipment: Config.Equipment = Config.Equipment.AXE_1HANDED
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
    var equip: Node3D = Config.get_equipment_scene(equipment).instantiate()
    equip.rotation_degrees = rotation_degrees
    return equip
