extends DirectionalLight3D

@export var duracion_dia: float = 60.0
@export var hora_inicial: float = 0.3
@export var brillo_luna: float = 0.4
@export var brillo_minimo_noche: float = 0.15

@export_group("Transicion sol y luna")
# Alturas: 1 = mediodía, 0 = horizonte, -1 = medianoche
@export var altura_sol_apagado: float = -0.1
@export var altura_sol_encendido: float = 0.15
@export var altura_luna_encendida: float = -0.2
@export var altura_luna_apagada: float = 0.05

@export_group("Color del sol")
@export var color_sol_mediodia: Color = Color(1.0, 0.96, 0.88)
@export var color_sol_horizonte: Color = Color(1.0, 0.54, 0.31)

@export_group("Colores del cielo")
@export var cielo_dia_arriba: Color = Color(0.385, 0.454, 0.55)
@export var cielo_dia_horizonte: Color = Color(0.662, 0.672, 0.687)
@export var cielo_atardecer_horizonte: Color = Color(0.95, 0.5, 0.35)
@export var cielo_noche_arriba: Color = Color(0.04, 0.06, 0.15)
@export var cielo_noche_horizonte: Color = Color(0.08, 0.1, 0.2)

@export_group("Estrellas")
@export var brillo_estrellas: float = 1.0

var tiempo: float
@onready var entorno: Environment = $"../WorldEnvironment".environment
@onready var cielo: ProceduralSkyMaterial = entorno.sky.sky_material
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

	# 1 cuando el sol está justo en el horizonte, 0 cuando está alto o muy por debajo
	var factor_horizonte = 1.0 - smoothstep(0.0, 0.35, abs(altura - 0.05))

	actualizar_luces(altura)
	actualizar_colores(luz_dia, factor_horizonte)

	entorno.background_energy_multiplier = lerp(brillo_minimo_noche, 1.0, luz_dia)
	entorno.ambient_light_energy = lerp(brillo_minimo_noche, 1.0, luz_dia)

	actualizar_estrellas(altura)


func actualizar_luces(altura: float) -> void:
	# Las dos curvas se cruzan: mientras el sol se apaga, la luna se enciende
	var factor_sol = smoothstep(altura_sol_apagado, altura_sol_encendido, altura)
	var factor_luna = 1.0 - smoothstep(altura_luna_encendida, altura_luna_apagada, altura)

	light_energy = factor_sol
	luna.light_energy = factor_luna * brillo_luna

	# Cada luz solo hace sombra fuerte cuando la otra está apagada.
	# En el cruce las dos sombras son suaves, en vez de dos sombras duras.
	shadow_opacity = factor_sol * (1.0 - factor_luna)
	luna.shadow_opacity = factor_luna * (1.0 - factor_sol)

	# Si una luz está apagada, no calculamos sus sombras (ahorra rendimiento)
	shadow_enabled = light_energy > 0.01
	luna.shadow_enabled = luna.light_energy > 0.01


func actualizar_colores(luz_dia: float, factor_horizonte: float) -> void:
	# Luz del sol: blanca cálida arriba, anaranjada cerca del horizonte
	light_color = color_sol_mediodia.lerp(color_sol_horizonte, factor_horizonte)

	# Cielo: primero mezclamos noche -> día, luego teñimos el horizonte de atardecer
	var arriba = cielo_noche_arriba.lerp(cielo_dia_arriba, luz_dia)
	var horizonte = cielo_noche_horizonte.lerp(cielo_dia_horizonte, luz_dia)
	horizonte = horizonte.lerp(cielo_atardecer_horizonte, factor_horizonte)

	cielo.sky_top_color = arriba
	cielo.sky_horizon_color = horizonte
	cielo.ground_horizon_color = horizonte


func actualizar_estrellas(altura: float) -> void:
	# Las estrellas solo aparecen cuando el sol ya está bajo el horizonte
	var factor_noche = 1.0 - smoothstep(-0.3, 0.0, altura)

	# El cielo entero se oscurece de noche (background_energy_multiplier),
	# así que compensamos para que las estrellas no se apaguen con él
	var compensacion = 1.0 / entorno.background_energy_multiplier
	var brillo = brillo_estrellas * compensacion
	cielo.sky_cover_modulate = Color(brillo, brillo, brillo, factor_noche)
