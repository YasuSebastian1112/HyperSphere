extends CharacterBody2D

class_name Enemigo_basico

"""Propiedades"""

@export_category("Fisicas")
@export var velocidad : float = 200.0
@export var gravedad : float = 9.81
@export var fuerza_de_salto : float = 250.0
@export_enum("Abajo", "Arriba", "Izquierda", "Derecha") var direccion_de_la_gravedad : int = 0
@export_category("Control")
@export var espera_para_morir : float = 1.0
@export var vida : float = 5.0: #Verificar si la vida es 0 para llamar a la funcion morir()
	set(value):
		vida = value
		if vida <= 0:
			morir(espera_para_morir)
@export var daño : float = 2.0

"""Metodos"""

#Funciones relacionadas al movimiento y colision

func control_de_gravedad() -> void:
	match direccion_de_la_gravedad:
		0: velocity.y += gravedad # Abajo
		1: velocity.y -= gravedad # Arriba
		2: velocity.x -= gravedad # Izquierda
		3: velocity.x += gravedad # Derecha

func si_esta_en_el_suelo() -> bool: #Obtener un suelo segun la direccion de la gravedad
	match direccion_de_la_gravedad:
		0: return is_on_floor() # Abajo
		1: return is_on_ceiling() # Arriba
		2,3: return is_on_wall() # Izquierda y derecha
		_: return false

func si_esta_en_una_pared() -> bool: #Obtener una pared segun la direccion de la gravedad
	match direccion_de_la_gravedad:
		0,1: return is_on_wall() # Vertical
		2,3: return is_on_ceiling() or is_on_floor() # Horizontal
		_: return false

func salto() -> void:
	match direccion_de_la_gravedad:
		0: velocity.y = -fuerza_de_salto  # Saltar hacia arriba
		1: velocity.y = fuerza_de_salto   # Saltar hacia abajo
		2: velocity.x = fuerza_de_salto   # Saltar hacia la derecha
		3: velocity.x = -fuerza_de_salto  # Saltar hacia la izquierda

# Funciones referentas al daño y la vida

func dar_daño(objetivo : Yusepe) -> void:
	objetivo.vida -= daño

func recibir_daño(daño_recibido : float) -> void:
	vida -= daño_recibido

func morir(tiempo_de_espera:float) -> void:
	var tiempo = get_tree().create_timer(tiempo_de_espera)
	await tiempo.timeout
	print(name, " SE ELIMINO CON EXITO")
	queue_free()
