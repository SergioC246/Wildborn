# Wildborn: Dawn of Dominion — Documento de diseño

> Documento de diseño completo del juego. Recoge todas las decisiones tomadas por Sergio entre el 20 y el 24 de noviembre de 2026, la hoja de ruta por fases y las ideas pendientes.
> Las decisiones marcadas como **(decidido)** ya están cerradas; cambiarlas requiere hablarlo con Sergio.
> Actualízalo cuando se complete una tarea de la hoja de ruta o se tome una decisión nueva.

---

## 1. Visión general

**Wildborn: Dawn of Dominion** es un juego de supervivencia de mundo abierto: empiezas solo y sin nada en una tierra salvaje y acabas liderando una civilización.

**Pitch:** sobrevive, domestica, cultiva y construye. Avanza de era en era, de los arcos a los rifles, y convierte tu choza en una ciudad viva con familia, aldeanos, animales de trabajo y ejército.

**Nombre (decidido):** *Wildborn* es la marca; *Dawn of Dominion* es el subtítulo de esta primera entrega. Futuras expansiones o secuelas pueden cambiar el subtítulo y mantener la marca.

### Pilares del juego

1. **Supervivencia real:** recolectar, comer, cocinar y gestionar la vida desde el primer minuto.
2. **Crecer desde abajo:** de superviviente a señor de una ciudad. Cada mejora se nota en el mundo.
3. **Animales con propósito:** peligrosos en estado salvaje y útiles cuando se domestican (granja, transporte, trabajo, combate).
4. **Progresión por eras:** la tecnología, las armas y la construcción avanzan juntas, sin llegar a la ciencia ficción.
5. **Libertad con historia:** hay una línea principal que guía, pero el jugador puede ignorarla y crear su propio camino.
6. **Peligro constante:** las batallas son parte central del juego. Tu asentamiento puede ser atacado y siempre hay algo que defender. No debe convertirse en un juego de solo cosechar y crecer.

---

## 2. Ficha técnica (decidido)

| Aspecto | Decisión | Motivo |
|---|---|---|
| Modo de juego | Un jugador. Online o cooperativo en el futuro | Empezar pequeño y crecer, como hizo GTA V |
| Perspectiva | 3D desde arriba e inclinada, con zoom | Cerca: controlas al personaje. Lejos (futuro): gestionas la ciudad como en Age of Empires |
| Estilo visual | 3D low-poly | Asumible para una persona; muchos recursos gratuitos (Kenney, Quaternius) |
| Motor | Godot 4.7.2, GDScript | Gratis, ligero, lenguaje parecido a Python |
| Plataforma | PC (Windows) | La más sencilla para probar y publicar |
| Control de versiones | Git + GitHub (`SergioC246/Wildborn`) | Portfolio y copia de seguridad |

**Nota técnica:** separar los datos del juego de lo que se ve en pantalla, para que el multijugador sea posible más adelante sin rehacerlo todo.

---

## 3. Inspiraciones

| Juego | Qué tomamos |
|---|---|
| GTA V | Mapa inmenso, aventuras, misiones, NPCs y negocios (adaptados a una época antigua) |
| Red Dead Redemption | Caza, caballos, fauna variada, recolección |
| ARK: Survival | Domesticar o matar animales, fabricar con materiales, base móvil en barco, casa de madera que pasa a metal, animales trabajando (p. ej. en un molino) |
| DayZ | Recoger semillas y cultivar un huerto |
| Medieval Dynasty | Formar una familia y crecer en linaje |
| Mount & Blade II: Bannerlord | Recorrer el mapa reclutando gente para el ejército y enfrentarse a otras culturas |
| Age of Empires | Avanzar por eras, aldeanos con oficios, ciudad que crece de aldea a imperio |
| Juegos que Sergio juega | Conan Exiles, Kingdom Come: Deliverance 2, Wartales, For Honor |

---

## 4. Supervivencia

- **Necesidades:** vida y hambre (implementadas); sed y energía (pendientes). Con el hambre a 0 se pierde vida.
- **Recolección:** madera, piedra, fibra, bayas, carne, pieles y minerales. Las herramientas mejoran la velocidad y desbloquean materiales nuevos.
- **Cocina:** la comida cruda alimenta poco o sienta mal; cocinada en hoguera, horno o cocina da más energía y beneficios.
- **Día y noche:** de noche hay más depredadores y menos visibilidad. La hoguera es la zona segura.

### Clima (decidido)
- **Frío** (invierno y montañas): ropa de abrigo, fuego y refugio, o se pierde vida.
- **Calor** (desierto y sabana): se necesita más agua.
- **Lluvia y tormentas:** riegan los cultivos, apagan hogueras y reducen la visibilidad.

### Enfermedades (decidido)
- Leves y con causa clara: carne cruda o podrida, agua sucia, frío o heridas sin curar.
- Se curan con lo que se fabrica: hierbas, vendas y, más adelante, un curandero.
- Epidemias solo en dificultad Superviviente y Salvaje, si la ciudad no tiene higiene (pozo, letrinas, curandero).

Clima y enfermedades llegan en fases avanzadas.

---

## 5. Construcción y asentamiento

1. **Madera:** choza, hoguera, almacén y cerca.
2. **Piedra:** casa sólida, muralla, horno y taller.
3. **Metal:** fortaleza, forja y edificios industriales.

- **Edificios de trabajo:** molino, aserradero o pozo, movidos por animales domesticados.
- **Base móvil:** un barco sobre el que se puede construir y vivir.
- **Mejoras:** cada edificio puede subir de material y nivel sin derribarlo.
- **Costes:** se expresan como diccionarios (`{"madera": 5, "piedra": 3}`) para que añadir recetas sea fácil.

---

## 6. Eras y progresión de armas

| Era | Armas | Construcción | Hito de la ciudad |
|---|---|---|---|
| 1. Primitiva | Lanza, garrote, arco simple | Madera | Campamento |
| 2. Medieval | Espada, hacha, ballesta, arco largo | Piedra | Aldea con aldeanos |
| 3. Pólvora | Mosquete, pistola de chispa, cañón | Piedra reforzada | Pueblo con comercio y ejército |
| 4. Industrial | Rifle, revólver, ametralladora temprana | Metal | Ciudad con fábricas |

### Cómo se pasa de era (decidido)
Hacen falta dos cosas:
1. **Una base mínima en la ciudad** (p. ej. 10 aldeanos y una forja para la era medieval).
2. **Un descubrimiento**, por cualquiera de estos caminos: completar el capítulo de la historia, comprarlo o robarlo a otra cultura, o investigarlo uno mismo (más lento).

Dentro de cada era el progreso es **gradual**: un árbol de mejoras que se desbloquean poco a poco.

---

## 7. Fauna y domesticación

### Animales por zona (decidido)

| Zona | Peligrosos | Domesticables | Solo caza |
|---|---|---|---|
| Valle central, Ashvale (inicio) | Lobo, jabalí | Cabra, gallina, perro salvaje | Ciervo, conejo |
| Norte (Clanes del Norte) | Oso, lobo, alce macho | Reno, perro de trineo | Zorro, liebre ártica |
| Llanuras (Reino de las Llanuras) | Toro salvaje | Caballo, vaca, oveja, cerdo | Faisán, ciervo |
| Sabana (Reinos de la Sabana) | León, hiena, cocodrilo (ríos) | Burro, búfalo | Cebra, antílope |
| Desierto (Imperio del Desierto) | Serpiente, escorpión | Camello, halcón | Gacela |

- **León y oso:** domarlos es muy difícil: capturar una cría, criarla y tener un edificio especial.
- **El valle central es seguro al principio:** solo lobos y jabalíes.
- **Los animales más útiles están lejos:** obligan a explorar, comerciar o conquistar.
- **Halcón:** explora desde el aire y avisa de ataques.
- **Perro:** el primer compañero. Caza contigo y avisa de peligros.
- **Domesticar:** capturar o ganar su confianza con comida, y luego cuidarlo (alimento, refugio).
- **Trabajo animal:** asignarlos a edificios (molino, carros, arado) para hacer crecer la ciudad.

---

## 8. Granja y agricultura

- **Semillas:** de plantas silvestres o compradas a comerciantes.
- **Huerto:** preparar la tierra, plantar, regar y cosechar.
- **Ganado:** animales en corrales que producen (leche, huevos, lana).
- **Automatización:** más adelante, aldeanos y animales se encargan del campo.

### Estaciones (decidido)

| Estación | Efecto |
|---|---|
| Primavera | Se siembra. Nacen crías en la granja |
| Verano | Los cultivos crecen rápido. Buena época para explorar y hacer campañas militares |
| Otoño | Cosecha. Hay que almacenar comida y leña |
| Invierno | Casi no crece nada, hace frío y los depredadores atacan más |

---

## 9. Ciudad, aldeanos, familia y negocios

- **Aldeanos:** se reclutan o llegan atraídos por la ciudad. Oficios: leñador, granjero, herrero, cazador, cocinero.
- **Familia y linaje:** el personaje puede casarse y tener hijos, que crecen y heredan el legado.
- **Negocios:** tiendas, posadas, comercio con otras ciudades y rutas de caravanas (esquema de negocios de GTA V, adaptado a la época).
- **Vista de gestión:** al alejar la cámara se asignan trabajos, se colocan edificios y se ven los recursos.

### Muerte y herederos (decidido)

| Nivel | Al morir |
|---|---|
| Colono | Reapareces en tu base y pierdes lo que llevabas encima |
| Superviviente | Continúas con un heredero adulto. Sin heredero, reapareces con penalización |
| Salvaje | Continúas con un heredero adulto. Sin heredero, fin de la partida |

- El heredero recibe la ciudad, los animales y parte de las habilidades.
- Los hijos crecen con el tiempo de juego y no heredan hasta ser adultos.
- El juego cuenta la historia de un linaje, no de una sola persona.

**Implementado de momento:** versión básica (reaparecer en la posición inicial perdiendo el inventario).

---

## 10. Ejército y culturas

- **Reclutamiento** en aldeas, campamentos y ciudades mientras se recorre el mapa.
- **Tropas** que mejoran con la experiencia y con las armas de cada era.
- **Animales en combate:** caballería y animales de guerra domados.

### Culturas rivales (decidido)

Cuatro culturas inventadas, inspiradas en culturas reales:

| Cultura | Inspiración | Territorio | Animal | Cómo combate | Qué ofrece |
|---|---|---|---|---|---|
| Clanes del Norte | Nórdica y eslava | Bosques y montañas nevadas | Lobo y oso | Infantería con hachas y escudos, asaltos en barco | Madera, pieles, guerreros de élite |
| Reino de las Llanuras | Europa medieval | Llanuras fértiles y ríos | Caballo | Caballería pesada y castillos | Grano, caballos de raza, fortificaciones |
| Reinos de la Sabana | Grandes reinos africanos históricos (Mali, Gran Zimbabue) | Sabana y ríos | León | Tropas rápidas, lanzas, arcos y fieras domadas | Oro, comercio, domesticar animales grandes |
| Imperio del Desierto | Persa y otomana | Desierto y oasis | Camello | Arqueros a caballo y pólvora temprana | Tecnología avanzada y descubrimientos de era |

- **Papeles:** los Clanes del Norte son la amenaza temprana; el Imperio del Desierto va por delante en tecnología; el Reino de las Llanuras es el vecino equilibrado.
- **Cultura propia:** el jugador empieza sin cultura y adopta rasgos de las culturas con las que se alía, a las que conquista o de las que recluta.
- **Futuro:** quinta cultura de gente del mar o piratas.
- **Primeras versiones:** solo bandidos y una cultura.

---

## 11. Amenazas y batallas

| Amenaza | Qué hace | Cuándo aparece |
|---|---|---|
| Depredadores | Manadas de lobos u osos atacan al ganado y a los aldeanos | Desde el principio, sobre todo de noche |
| Bandidos | Asaltan para robar comida, recursos y animales | A medida que acumulas riqueza |
| Culturas rivales | Envían ejércitos a asediar tu ciudad | Cuando hay tensión o guerra |

- **Avisos previos:** rastros, exploradores enemigos o humo en el horizonte. Generan tensión.
- **Defensa:** murallas, torres, trampas, aldeanos de guardia y animales de guardia.
- **Consecuencias reales:** perder una defensa cuesta recursos, edificios, animales o aldeanos.
- **Escala con el progreso:** cuanto más rica la ciudad, más fuertes los ataques.
- **También atacas tú:** campamentos de bandidos, aldeas y ciudades rivales.

### Frecuencia de los ataques (decidido)
Un **nivel de amenaza oculto** sube con el tiempo, la riqueza, el tamaño de la ciudad y las acciones del jugador. Al llegar a cierto punto se desencadena un ataque o evento. Los ataques siempre acaban llegando, pero las decisiones influyen en cuándo y quién viene (estilo RimWorld).

### Niveles de dificultad (decidido)

| Nivel | Ataques | Pérdidas al perder una defensa |
|---|---|---|
| Colono | Menos frecuentes y más débiles | Recursos |
| Superviviente (normal) | Equilibrados | Recursos, animales y edificios |
| Salvaje | Frecuentes y duros | Todo, incluidos aldeanos y familia |

No hay modo totalmente pacífico.

---

## 12. Mundo, historia y misiones

- **Estructura:** línea principal por capítulos (estilo Red Dead o Skyrim), opcional. Cada gran capítulo coincide con un salto de era.
- **Misiones secundarias:** encargos de NPCs, cacerías, rescates, comercio y conflictos entre culturas.
- **Mapa:** grande y variado (bosques, llanuras, montañas, costa y ríos), con zonas de distinto peligro.
- **Idea futura:** NPCs con diálogo generado por IA (encaja con el objetivo de Sergio de ser AI Engineer).

### Nombres del mundo (decidido)
- **Wildmarch** ("la marca salvaje"): el continente, la frontera salvaje del mundo.
- **Ashvale** ("valle de ceniza"): el valle central donde empiezas, con restos de un asentamiento quemado.

### Protagonista (decidido)
El jugador elige aspecto y nombre; el pasado es fijo. Eras miembro de una familia noble de una tierra lejana. Te traicionaron, acusaron a tu familia de un crimen que no cometió y te desterraron al otro lado del mar. Llegas a la costa de Ashvale con lo puesto.
- Motivo: sobrevivir y descubrir quién te traicionó.
- Si mueres, tus hijos heredan la misión de limpiar el nombre de la familia.

### El gran giro (decidido)
El asentamiento quemado de Ashvale lo levantaron otros exiliados, desterrados por el mismo traidor, que ahora gobierna tu tierra natal. En la era industrial, el traidor invade Wildmarch por mar. Es el clímax del juego y llega aunque se ignore la historia.

### Finales (decidido)

| | Venganza | Perdón |
|---|---|---|
| Por la fuerza | **Imperio de Hierro:** aplastas la invasión, ejecutas al traidor y gobiernas con mano dura | **El Conquistador Justo:** vences y dejas vivir al traidor |
| Con alianzas | **La Coalición Vengadora:** las culturas unidas cruzan el mar y toman tu antigua tierra | **El Nuevo Amanecer:** paz entre continentes; tu linaje recupera su honor |

Tras el final, el juego sigue en modo libre. El final puede vivirlo un hijo o un nieto del protagonista original.

---

## 13. Hoja de ruta

Estado a 24 de noviembre de 2026: fases 0 y 1 completas, fase 2 en torno al 75 %. La primera **demo jugable** para enseñar (itch.io, CV) llega al terminar la fase 5.

| Fase | Objetivo | Estado |
|---|---|---|
| 0. Diseño | Documento de diseño completo | Completada |
| 1. Base jugable | Mundo, jugador y primer recurso | Completada |
| 2. Núcleo de supervivencia | Recursos, construir, día y noche, hambre, vida, cocinar | En curso |
| 3. Mundo y aspecto | Terreno real, modelos, animaciones | Pendiente |
| 4. Animales | Caza, depredadores y primera domesticación | Pendiente |
| 5. Granja y huerto | Cultivos, estaciones y ganado. **Hito: demo jugable** | Pendiente |
| 6. Construcción avanzada | Casas modulares de madera y piedra | Pendiente |
| 7. Aldeanos y ciudad | NPCs con oficios y vista de gestión | Pendiente |
| 8. Eras y armas | Árbol tecnológico, era medieval y combate | Pendiente |
| 9. Amenazas | Nivel de amenaza, bandidos y defensas | Pendiente |
| 10. Familia y linaje | Matrimonio, hijos y herederos | Pendiente |
| 11. Culturas y ejército | Diplomacia, comercio y batallas | Pendiente |
| 12. Historia y misiones | Capítulos, misiones y finales | Pendiente |
| 13. Eras avanzadas | Pólvora, era industrial e invasión final | Pendiente |
| 14. Pulido y lanzamiento | Menús, sonido, optimización y publicación | Pendiente |
| Futuro | Multijugador online o cooperativo | Pendiente |

### Fase 0: Diseño
- [x] Documento de diseño con todas las decisiones principales

### Fase 1: Base jugable
- [x] Instalar Godot y crear el proyecto en GitHub
- [x] Mundo con suelo, sol, cielo y colisiones
- [x] Jugador que anda y salta con W, A, S, D y Espacio
- [x] Cámara desde arriba que sigue al jugador
- [x] Árboles sólidos que se talan con E
- [x] Contador de madera en pantalla

### Fase 2: Núcleo de supervivencia
- [x] Script genérico de recursos (árboles, rocas, arbustos y conejos)
- [x] Rocas y piedra
- [x] Hoguera construible con B (5 madera + 3 piedra) que ilumina
- [x] Ciclo de día y noche con luna
- [x] Barras de vida y hambre
- [x] Comer: arbustos de bayas
- [x] Muerte y reaparición (se pierde lo que llevas)
- [x] Cocinar carne en la hoguera (E) y comerla (F); la carne cruda quita vida
- [x] Inventario con interfaz (TAB) basado en un diccionario genérico
- [x] Atardecer con luz cálida, transición suave sol/luna y estrellas (primera tarea hecha con Claude Code)
- [ ] Sed y fuentes de agua
- [ ] Menú de construcción
- [ ] Herramientas básicas: hacha y pico de piedra
- [ ] Guardar y cargar partida

### Fase 3: Mundo y aspecto
- [ ] Terreno con colinas, ríos y agua (puede generarse por código)
- [ ] Modelos low-poly para jugador, árboles y rocas
- [ ] Animaciones del personaje: andar, talar y saltar
- [ ] Zoom de cámara (y decidir si se inclina más para ver el cielo)
- [ ] Árboles y rocas de distintos tamaños y cantidades (grandes dan más recursos, pequeños menos)
- [ ] El valle de Ashvale con las ruinas quemadas

### Fase 4: Animales
- [ ] Inteligencia básica: deambular, huir y atacar
- [ ] Conejo y ciervo que huyen del jugador
- [ ] Lobo depredador, más activo de noche
- [ ] Combate cuerpo a cuerpo básico
- [ ] Carne y pieles
- [ ] Cabra domesticable

### Fase 5: Granja y huerto (demo jugable)
- [ ] Semillas, plantar, regar y cosechar
- [ ] Cuatro estaciones
- [ ] Corrales y animales que producen
- [ ] Demo jugable publicada en itch.io

### Fase 6: Construcción avanzada
- [ ] Construcción modular: suelos, paredes, puertas y techos
- [ ] Materiales que mejoran de madera a piedra
- [ ] Almacén, cama y refugio
- [ ] Edificios de trabajo: molino y aserradero

### Fase 7: Aldeanos y ciudad
- [ ] Reclutar aldeanos
- [ ] Oficios: leñador, granjero, cazador y herrero
- [ ] Vista de gestión al alejar la cámara
- [ ] Animales trabajando en edificios

### Fase 8: Eras y armas
- [ ] Árbol tecnológico gradual
- [ ] Era medieval
- [ ] Arco, ballesta y espada
- [ ] Descubrimientos por historia, comercio o investigación

### Fase 9: Amenazas
- [ ] Nivel de amenaza oculto
- [ ] Bandidos y asaltos con avisos previos
- [ ] Murallas, torres y trampas
- [ ] Tres niveles de dificultad

### Fase 10: Familia y linaje
- [ ] Matrimonio
- [ ] Hijos que crecen con el tiempo
- [ ] Herederos al morir, según la dificultad

### Fase 11: Culturas y ejército
- [ ] Primera cultura: Clanes del Norte
- [ ] Diplomacia y comercio
- [ ] Reclutar y dirigir un ejército
- [ ] Batallas
- [ ] Reino de las Llanuras, Reinos de la Sabana e Imperio del Desierto

### Fase 12: Historia y misiones
- [ ] Capítulos de la historia principal
- [ ] Misiones secundarias
- [ ] NPCs con diálogo, con posible uso de IA
- [ ] El gran giro y los cuatro finales

### Fase 13: Eras avanzadas
- [ ] Era de la pólvora
- [ ] Era industrial y armas de fuego
- [ ] Invasión final del traidor

### Fase 14: Pulido y lanzamiento
- [ ] Menús y tutorial
- [ ] Sonido y música
- [ ] Optimización y equilibrio (p. ej. hambre mucho más lenta que en las pruebas)
- [ ] Publicación

---

## 14. Ideas y notas sueltas

- **Coste real de la hoguera:** ya usa madera + piedra, como quería Sergio.
- **Valores de prueba:** el hambre baja rápido (se vacía en 50 s) para probar; hay que ajustarlo antes de la demo.
- **Devlog:** grabar vídeos cortos del progreso desde ya (p. ej. "De cero a talar árboles y cocinar en Godot en 2 días") para TikTok/Instagram/YouTube.
- **Marketing futuro:** demo gratis, Discord, contacto con YouTubers y wishlists en Steam antes del lanzamiento.
- **Prototipos rápidos:** se puede usar Claude para generar bocetos visuales rápidos (p. ej. un HTML con Three.js) antes de construir algo en Godot.
- **Portfolio:** el proyecto forma parte del CV de Sergio; el código debe estar limpio y explicado.

---

## 15. Cómo trabajamos

- Sergio construyó las fases 0, 1 y casi toda la 2 a mano, paso a paso, para aprender Godot.
- Desde el 24 de noviembre de 2026 trabaja principalmente con **Claude Code** en VS Code.
- Flujo por tarea: commit de seguridad → chat nuevo → Plan mode → revisar el plan → aplicar con aprobación manual → revisar cada diff → probar en Godot → commit → proponer actualizar `CLAUDE.md` y este documento.
- Las decisiones de diseño grandes se siguen hablando con Sergio antes de implementarlas.
