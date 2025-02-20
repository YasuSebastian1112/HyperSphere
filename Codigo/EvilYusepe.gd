extends Enemigo_basico

class_name Evil_Yusepe_Simple

"""Propiedades"""

@onready var suelo : RayCast2D = $AnimatedSprite2D/Suelo
@onready var muro : RayCast2D = $AnimatedSprite2D/Muro
@onready var sprite_animado : AnimatedSprite2D = $AnimatedSprite2D
@onready var plataforma_cercana : RayCast2D = $AnimatedSprite2D/Plataforma_cercana

"""Metodos"""
func detectar_muros_y_suelo() -> void:
	if si_esta_en_una_pared():
		match muro.is_colliding():
			true: direccion *= -1
			false: salto()
	if not suelo.is_colliding() and si_esta_en_el_suelo():
		match plataforma_cercana.is_colliding():
			true: salto()
			false: direccion *= -1

func control_de_animaciones() -> void:
	if direccion != 0:
		sprite_animado.scale.x = direccion

func control_de_movimiento() -> void:
	match Direccion_de_la_gravedad:
		0:
			if direccion != 0:
				velocity.x = direccion * (velocidad)
		1:
			if direccion != 0:
				velocity.x = -direccion * (velocidad)
		2:
			if direccion != 0:
				velocity.y = direccion * (velocidad)
		3:
			if direccion != 0:
				velocity.y = -direccion * (velocidad)
	move_and_slide()

func _process(_delta):
	control_de_movimiento()
	detectar_muros_y_suelo()
	control_de_gravedad()
	control_de_animaciones()
