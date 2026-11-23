extends DirectionalLight3D

@export var duracion_dia: float = 60.0
@export var hora_inicial: float = 0.3
@export var brillo_luna: float = 0.4
@export var brillo_minimo_noche: float = 0.15

var tiempo: float
@onready var entorno: Environment = $"../WorldEnvironment".environment
@onready var luna: DirectionalLight3D = $"../Luna"


func _ready() -> void:
	tiempo = hora_inicial


func _process(delta: float) -> void:
	tiempo = fmod(tiempo + delta / duracion_dia, 1.0)
	rotation_degrees.x = 90.0 - tiempo * 360.0

	# La luna siempre está en el lado opuesto del cielo
	luna.rotation_degrees.x = rotation_degrees.x + 180.0
	luna.rotation_degrees.y = rotation_degrees.y

	var altura = -sin(deg_to_rad(rotation_degrees.x))
	var luz_dia = smoothstep(-0.2, 0.3, altura)
	var luz_noche = 1.0 - smoothstep(-0.3, 0.2, altura)

	light_energy = luz_dia
	luna.light_energy = luz_noche * brillo_luna

	entorno.background_energy_multiplier = lerp(brillo_minimo_noche, 1.0, luz_dia)
	entorno.ambient_light_energy = lerp(brillo_minimo_noche, 1.0, luz_dia)
