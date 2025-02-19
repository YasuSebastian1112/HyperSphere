extends Sprite2D

class_name Sprite_Animado_fijo


"""Propiedades"""

@export_category("Sprite_Animado_Fijo")
@export_group("Configuraciones")
@export var escala_minima : float = 1.0
@export var escala_maxima : float = 2.0
@export_group("Por Sonido")
@export var activar_sonido : bool = false :
	set(value):
		activar_sonido = value
		actualizar_proceso()
@export_enum("PistaDeBase1","PistaDeBase2","PistaDeBase3","PistaDeExtra") var bus_de_audio : int = 0
@export var frecuencia_minima : float = 20.0
@export var frecuencia_maxima : float = 200.0
@export_group("Por proximidad")
@export var activar_proximidad : bool = false:
	set(value):
		activar_proximidad = value
		actualizar_proceso()
@export var activar_escala : bool = false
@export var activar_rotacion : bool = false
@export var nodo_objetivo : NodePath
@export var distancia_de_tolerancia : Vector2 = Vector2(100, 100)
@export var velocidad_escala : float = 5.0  # Velocidad de transición de la escala
@export var velocidad_de_rotacion : float = 5.0  # Velocidad de transición de la escala


@onready var spectrum_analyzer := AudioServer.get_bus_effect_instance(obtener_bus_de_audio(), 0) as AudioEffectSpectrumAnalyzerInstance
@onready var objetivo: Node2D = get_node_or_null(nodo_objetivo)
var proceso_actual: Callable = func(_delta): pass  # Función vacía por defecto


"""Metodos"""

func obtener_bus_de_audio() -> int:
	match bus_de_audio:
		0: return AudioServer.get_bus_index("PistaDeBase1")
		1: return AudioServer.get_bus_index("PistaDeBase2")
		2: return AudioServer.get_bus_index("PistaDeBase3")
		3: return AudioServer.get_bus_index("PistaDeExtra")
		_:
			print("Bus de audio desconocido")
			return -1

func actualizar_proceso():
	if activar_sonido:
		proceso_actual = mover_por_sonido
	elif activar_proximidad:
		proceso_actual = mover_por_proximidad
	else:
		proceso_actual = func(_delta): pass  # No hace nada

func mover_por_sonido(_delta):
	if not spectrum_analyzer:
		activar_sonido = false
		return
	# Obtén la amplitud promedio en el rango de frecuencias especificado
	var amplitud= spectrum_analyzer.get_magnitude_for_frequency_range(frecuencia_minima, frecuencia_maxima)[0]
	# Calcula la nueva escala en función de la amplitud
	var escala = escala_minima + (amplitud * escala_maxima)
	scale = Vector2(escala, escala)

func mover_por_proximidad(delta):
	if not objetivo:
		return  # No hacer nada si el objetivo no existe
	
	# Calcular la dirección y distancia al objetivo
	var direccion = (objetivo.global_position - global_position)
	var distancia = direccion.length()
	var tolerancia_maxima = distancia_de_tolerancia.length()
	
	# Factor de interpolación basado en la proximidad
	var factor = clamp(1.0 - (distancia / tolerancia_maxima), 0.0, 1.0)

	# Aplicar escalado si está activado
	if activar_escala:
		var nueva_escala = lerp(scale.x, lerp(escala_minima, escala_maxima, factor), delta * velocidad_escala)
		scale = Vector2(nueva_escala, nueva_escala)

	# Aplicar rotación si está activado
	if activar_rotacion:
		if distancia <= tolerancia_maxima:
			# Si el objetivo está dentro de la tolerancia, rotar hacia él
			var angulo_objetivo = atan2(direccion.y, direccion.x)
			rotation = lerp_angle(rotation, angulo_objetivo, delta * velocidad_de_rotacion)
		else:
			# Si el objetivo está fuera, volver lentamente a la rotación normal (0 grados)
			rotation = lerp_angle(rotation, 0.0, delta * velocidad_de_rotacion)

func _ready():
	obtener_bus_de_audio()

func _process(delta):
	proceso_actual.call(delta)  # Llama solo a la función activa

