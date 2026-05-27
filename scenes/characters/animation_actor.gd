extends Node3D

class_name AnimationActor

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var rig_medium: Node3D = $Rig_Medium
@onready var skeleton_3d: Skeleton3D = $Rig_Medium/Skeleton3D

const TRANSITION_TIME: float = 0.3


func _ready() -> void:
    rig_medium.rotate(Vector3.UP, PI / 2)
    print("AnimationActor ready")
    return


func equip_weapon(equipment_data: DataEquipment) -> void:
    var bone_attachment: BoneAttachment3D = BoneAttachment3D.new()
    bone_attachment.bone_name = equipment_data.slot_bone_name
    skeleton_3d.add_child(bone_attachment)

    var weapon_instance: Node3D = equipment_data.get_equipment_instance()
    bone_attachment.add_child(weapon_instance)
    return


func play_idle_a() -> void:
    animation_player.play("Player/Idle_A", TRANSITION_TIME)


func play_idle_b() -> void:
    animation_player.play("Player/Idle_B", TRANSITION_TIME)


func play_walking_a() -> void:
    animation_player.play("Player/Walking_A", TRANSITION_TIME)


func play_walking_b() -> void:
    animation_player.play("Player/Walking_B", TRANSITION_TIME)


func play_walking_c() -> void:
    animation_player.play("Player/Walking_C", TRANSITION_TIME)


func play_running_a() -> void:
    animation_player.play("Player/Running_A", TRANSITION_TIME)


func play_running_b() -> void:
    animation_player.play("Player/Running_B", TRANSITION_TIME)


func play_attack() -> void:
    animation_player.play("Player/Throw", TRANSITION_TIME)


func play_jump_full_short() -> void:
    animation_player.play("Player/Jump_Full_Short", TRANSITION_TIME)
