extends CharacterBody2D

class_name Personaje

"""Propiedades"""

@export_category("Fisicas") #Todas las propiedades relacionadas a las fisicas 
@export var velocidad : float = 200.0
@export var gravedad : float = 9.81
@export var multiplicador_de_velocidad : float = 1.0
@export var multiplicador_de_gravedad : float = 1.0
@export var fuerza_de_salto : float = 300.0
@export_enum("Abajo", "Arriba", "Izquierda", "Derecha") var Direccion_de_la_gravedad : int = 0
@export_range(0,1) var friccion : float = 1.0
@export_category("Control")
@export var saltos_maximos : int = 2
@export var tiempo_de_coyote : float = 0.15
@export var espera_para_morir : float = 1.0
@export var vida : float = 10.0:
	set(value):
		vida = value
		if vida <= 0:
			morir(espera_para_morir)
@export var daño : float = 2
@export_category("Dash")
@export var puede_dashear : bool = true       # Indica si se puede iniciar el dash
@export var dash : bool = false         # Estado actual del dash (en curso o no)
@export var fuerza_del_dash : float = 400.0  # Fuerza que se aplica al dash
@export var duracion_del_dash : float = 0.2 # Tiempo (en segundos) que dura el dash
@export var cooldown_del_dash : float = 1.0   # Cooldown del dash en segundos

var saltos_restantes : int = 1

"""Metodos"""

func cambiar_direccion_visual(direccion: int = 0) -> void:
	match direccion:
		0: rotation_degrees = 0    # Abajo
		1: rotation_degrees = 180  # Arriba
		2: rotation_degrees = 90   # Izquierda
		3: rotation_degrees = -90  # Derecha

func control_de_gravedad() -> void:
	match Direccion_de_la_gravedad:
		0: velocity.y += gravedad # Abajo
		1: velocity.y -= gravedad # Arriba
		2: velocity.x -= gravedad # Izquierda
		3: velocity.x += gravedad # Derecha

func si_esta_en_el_suelo() -> bool: #Obtener un suelo segun la direccion de la gravedad
	match Direccion_de_la_gravedad:
		0: return is_on_floor() # Abajo
		1: return is_on_ceiling() # Arriba
		2,3: return is_on_wall() # Izquierda y derecha
		_: return false

func si_esta_en_una_pared() -> bool: #Obtener una pared segun la direccion de la gravedad
	match Direccion_de_la_gravedad:
		0,1: return is_on_wall() # Vertical
		2,3: return is_on_ceiling() or is_on_floor() # Horizontal
		_: return false

func salto() -> void:
	match Direccion_de_la_gravedad:
		0: velocity.y = -fuerza_de_salto  # Saltar hacia arriba
		1: velocity.y = fuerza_de_salto   # Saltar hacia abajo
		2: velocity.x = fuerza_de_salto   # Saltar hacia la derecha
		3: velocity.x = -fuerza_de_salto  # Saltar hacia la izquierda
	saltos_restantes -= 1

func regular_salto() -> void:
	match Direccion_de_la_gravedad:
		0: if velocity.y < 0: velocity.y /= 2  # Cancelar salto hacia arriba
		1: if velocity.y > 0: velocity.y /= 2  # Cancelar salto hacia abajo
		2: if velocity.x > 0: velocity.x /= 2  # Cancelar salto hacia derecha
		3: if velocity.x < 0: velocity.x /= 2  # Cancelar salto hacia izquierda

func morir(tiempo_de_espera:float) -> void:
	var tiempo = get_tree().create_timer(tiempo_de_espera)
	await tiempo.timeout
	print(name, ": SE ELIMINO CON EXITO")
	queue_free()
