extends Node3D

class_name Unit2D

@onready var sprite_3d: Sprite3D = $Sprite3D

func _process(delta: float) -> void:
    sprite_3d.scale.y = 1 + 0.005 * sin(0.005 *Time.get_ticks_msec())
