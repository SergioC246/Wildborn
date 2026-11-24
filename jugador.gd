extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const COSTE_HOGUERA_MADERA = 5
const COSTE_HOGUERA_PIEDRA = 3
const ESCENA_HOGUERA = preload("res://hoguera.tscn")

@export var vida_maxima: float = 100.0
@export var hambre_maxima: float = 100.0
@export var velocidad_hambre: float = 2.0
@export var dano_por_hambre: float = 5.0

var madera = 0
var piedra = 0
var vida: float
var hambre: float
var posicion_inicial: Vector3

@onready var contador_madera = $CanvasLayer/ContadorMadera
@onready var barra_vida = $CanvasLayer/BarraVida
@onready var barra_hambre = $CanvasLayer/BarraHambre


func _ready() -> void:
	posicion_inicial = global_position
	vida = vida_maxima
	hambre = hambre_maxima
	barra_vida.max_value = vida_maxima
	barra_hambre.max_value = hambre_maxima
	actualizar_contador()
	actualizar_barras()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("construir"):
		construir_hoguera()
	actualizar_supervivencia(delta)


func _physics_process(delta: float) -> void:
	# Gravedad
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Salto
	if Input.is_action_just_pressed("saltar") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Movimiento
	var input_dir := Input.get_vector("mover_izquierda", "mover_derecha", "mover_adelante", "mover_atras")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func actualizar_supervivencia(delta: float) -> void:
	hambre = max(hambre - velocidad_hambre * delta, 0.0)
	if hambre <= 0.0:
		vida = max(vida - dano_por_hambre * delta, 0.0)
	actualizar_barras()
	if vida <= 0.0:
		morir()


func morir() -> void:
	print("Has muerto. Pierdes todo lo que llevabas.")
	madera = 0
	piedra = 0
	vida = vida_maxima
	hambre = hambre_maxima
	global_position = posicion_inicial
	velocity = Vector3.ZERO
	actualizar_contador()
	actualizar_barras()


func actualizar_barras() -> void:
	barra_vida.value = vida
	barra_hambre.value = hambre


func agregar_recurso(tipo: String, cantidad: int) -> void:
	if tipo == "madera":
		madera += cantidad
	elif tipo == "piedra":
		piedra += cantidad
	elif tipo == "bayas":
		comer(cantidad)
	actualizar_contador()
	
func comer(cantidad: int) -> void:
	hambre = min(hambre + cantidad, hambre_maxima)
	actualizar_barras()
	print("¡Ñam! Hambre: ", hambre)	
	


func actualizar_contador() -> void:
	contador_madera.text = "Madera: " + str(madera) + "    Piedra: " + str(piedra)


func construir_hoguera() -> void:
	if madera < COSTE_HOGUERA_MADERA or piedra < COSTE_HOGUERA_PIEDRA:
		print("Necesitas ", COSTE_HOGUERA_MADERA, " de madera y ", COSTE_HOGUERA_PIEDRA, " de piedra")
		return

	madera -= COSTE_HOGUERA_MADERA
	piedra -= COSTE_HOGUERA_PIEDRA
	actualizar_contador()

	var hoguera = ESCENA_HOGUERA.instantiate()
	get_parent().add_child(hoguera)
	hoguera.global_position = global_position + Vector3(0, 0, -2)
	print("¡Hoguera construida!")
