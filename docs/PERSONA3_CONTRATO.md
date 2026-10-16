# Contrato de la Persona 3: Interacción, integración y entrega

> Proyecto OrientadorCE (CE1106, II Semestre 2026). Este documento resume qué entrega la Persona 3, qué necesita de los demás y qué se debe llenar al final para la documentación (máx. 3 páginas).

---

## 1. Qué entrega la Persona 3

| Entregable | Archivo / lugar | Estado |
|---|---|---|
| Conversación con el usuario (saludo, preguntas, lectura de respuestas) | `conversacion.pl` (al final se pasa a `Logic.pl`) | Hecho (probado con stub) |
| Banco de preguntas `pregunta/2` | `conversacion.pl` (al final se pasa a `BD.pl`) | Hecho |
| Reformulación de frases no reconocidas | `conversacion.pl` | Hecho |
| Mensaje final (recomendación o "sin coincidencias") | `conversacion.pl` | Hecho |
| Repositorio con ramas y commits por integrante | GitHub | Por hacer |
| Integración de los 3 archivos (`BD.pl`, `BNF.pl`, `Logic.pl`) | Repositorio | Pendiente de P1 y P2 |
| Caso de prueba 4 y corrida final de los 5 casos | `docs/casos_prueba.md`, `tests/` | Por hacer |
| Documento final (máx. 3 páginas) | `docs/documentacion.md` | Por hacer |

---

## 2. Predicados que implementa

| Predicado | Qué hace |
|---|---|
| `iniciar/0` | Punto de entrada. Saluda, hace la pregunta abierta, recorre las preguntas, llama a `recomendar/2` y muestra el resultado. |
| `leer_pref(-Pref)` | Lee una línea de la consola y la interpreta con `interpretar/2`. Si no se reconoce, pide reformular y vuelve a leer **sin guardar nada**. |
| `preguntar_todas(+Intereses, +PrefsActuales, -PrefsFinales)` | Recorre la lista de intereses a preguntar. Salta los que el usuario ya mencionó. Acumula las preferencias. |
| `ya_registrado(+Interes, +Prefs)` | Verdadero si ya existe una preferencia sobre ese interés. |
| `pregunta(?Interes, ?Texto)` | Banco de preguntas: una por cada uno de los 12 intereses. |
| `intereses_a_preguntar(-Lista)` | Intereses por los que se pregunta, en orden: tecnología, matemáticas, resolver problemas, ayudar a las personas, escuchar y arte. |
| `mostrar_resultado(+Profesiones)` | Mensaje final: una recomendación, varias opciones o "sin coincidencias". |

---

## 3. Qué recibe y qué entrega (interfaces)

### Lo que necesita de los demás

| De quién | Predicado | Contrato |
|---|---|---|
| Persona 2 (`BNF.pl`) | `interpretar(+Texto, -Pref)` | `Texto` es un string. Devuelve `pref(Interes, afirmativa)` o `pref(Interes, negativa)`. **Debe fallar** si no reconoce la frase. |
| Persona 1 (reglas) | `recomendar(+ListaPrefs, -Profesiones)` | Devuelve la lista de profesiones recomendadas, o `[]` si no hay coincidencias. |
| Persona 1 (`BD.pl`) | `profesion/1`, `afinidades/2`, `incompatibles/2` | Se usan indirectamente a través de `recomendar/2`. |

### Lo que entrega

- `iniciar/0`: es la consulta que inicia el programa.
- `pregunta/2`: se agrega al final de `BD.pl` en la integración.

### Vocabulario compartido de intereses
`matematicas`, `tecnologia`, `resolver_problemas`, `ayudar_personas`, `escuchar`, `hablar`, `ciencias`, `arte`, `naturaleza`, `escribir`, `liderazgo`, `trabajo_manual`.
Los mismos átomos se usan en `BD.pl`, en la gramática y en las preguntas. Nadie los cambia sin avisar.

---

## 4. Comportamiento acordado de la conversación

1. El programa saluda y hace una pregunta abierta: "¿Qué te gusta?".
2. Lo que el usuario responde se interpreta y se guarda como preferencia, sin importar el tema (se guarda lo que devuelve `interpretar/2`, no el tema de la pregunta).
3. Luego pregunta por cada interés de `intereses_a_preguntar/1`, saltando los que el usuario ya mencionó.
4. Si una respuesta no se reconoce:
   - se muestra un mensaje pidiendo reformular, con un ejemplo;
   - **no se registra ninguna preferencia**;
   - se vuelve a leer la respuesta.
5. Al terminar las preguntas se llama a `recomendar/2` con las preferencias acumuladas.
6. Resultado:
   - lista vacía: "No cuento con una profesión compatible con tus preferencias.";
   - un elemento: "Según tus preferencias, te recomiendo X.";
   - varios: "Según tus preferencias, te recomiendo estas opciones: X, Y.".
7. No se acepta una interacción basada solo en "sí" o "no", porque `interpretar/2` solo reconoce frases completas.

---

## 5. Cómo ejecutar (para la documentación)

1. Tener instalado SWI-Prolog.
2. Abrir una terminal en la carpeta del proyecto.
3. Ejecutar `swipl Logic.pl` (archivo final).
4. En el prompt, escribir: `?- iniciar.`
5. Responder con frases como "Me gusta la tecnología" o "No me gusta el arte".

> Mientras no esté la integración: `swipl conversacion.pl`, que usa `stubs.pl` y `reglas_p1.pl`.

---

## 6. Plan de integración (tarea 3.6)

- [ ] `Logic.pl` contiene las reglas de P1 y la conversación de P3, con `:- consult('BD.pl').` y `:- consult('BNF.pl').` al inicio.
- [ ] `pregunta/2` movido al final de `BD.pl`.
- [ ] `stubs.pl` eliminado de la carga (no se entrega).
- [ ] `interpretar/2` de `BNF.pl` acepta strings y falla con frases no reconocidas.
- [ ] El archivo carga sin errores con `swipl Logic.pl`.
- [ ] Los 5 casos de prueba se ejecutan con el programa integrado.

---

## 7. Caso de prueba 4 (responsabilidad de P3)

**Situación:** ante una pregunta sobre intereses, el usuario ingresa una frase no reconocida y luego una válida.

| Campo | Contenido |
|---|---|
| Entradas | 1) `La ventana está abierta`  2) `Me gustan las matemáticas` y el resto de respuestas válidas de la conversación |
| Resultado esperado | Pide reformular la primera respuesta, no registra ninguna preferencia con ella y continúa al recibir la frase válida. |
| Resultado obtenido | *(completar con la ejecución real)* |
| ¿Pasó? | *(sí / no)* |

Guardar las entradas, una por línea, en `tests/caso4.txt`.

**Corrida final de los 5 casos:** P3 ejecuta los cinco casos con el programa integrado y confirma que se reproducen. Cada responsable registra su resultado:

| Caso | Responsable | Entradas guardadas en |
|---|---|---|
| 1. Perfil tecnológico | P2 | `tests/caso1.txt` |
| 2. Perfil social | P2 | `tests/caso2.txt` |
| 3. Negación de una afinidad | P1 | `tests/caso3a.txt`, `tests/caso3b.txt` |
| 4. Respuesta no reconocida | P3 | `tests/caso4.txt` |
| 5. Perfil sin coincidencias | P1 | `tests/caso5.txt` |

---

## 8. Limitaciones conocidas de la parte de P3

- Las preguntas son un número fijo (6) y siguen un orden fijo. No se adaptan a las respuestas.
- Si el usuario responde sobre un tema distinto al que se preguntó, se guarda lo que dijo, pero el tema preguntado se sigue considerando pendiente solo si no apareció antes.
- Si el usuario menciona el mismo interés dos veces con polaridades opuestas (por ejemplo, "me gusta" y luego "no me gusta" la tecnología), se registran ambas preferencias. No hay un paso de resolución del conflicto.
- Si la entrada se termina (fin de archivo), el programa cierra con un mensaje y no genera recomendación.
- Solo se entienden las frases que reconoce la gramática de `BNF.pl`; no se interpreta cualquier frase del español.
- No hay interfaz gráfica: todo es por texto en consola.
- Las asociaciones entre intereses y profesiones son simplificaciones educativas, no un diagnóstico vocacional.

---

## 9. Aportes de la Persona 3 (para la sección de aportes)

*(Completar con el nombre real y ajustar al final.)*

- Creación y organización del repositorio, ramas y reglas de commits.
- Banco de preguntas (`pregunta/2`).
- Bucle de conversación, acumulación de preferencias y reformulación de respuestas no reconocidas.
- Mensajes finales (recomendación única, varias opciones, sin coincidencias).
- Integración de `BD.pl`, `BNF.pl` y `Logic.pl` y depuración.
- Caso de prueba 4 y corrida final de los 5 casos.
- Ensamblado del documento final (instrucciones de ejecución, limitaciones y aportes de cada integrante).

---

## 10. Estructura del documento final (máx. 3 páginas)

| Sección | Responsable | Fuente |
|---|---|---|
| 1. Instrucciones de ejecución y uso | P3 | Secciones 5 y 4 de este contrato |
| 2. Hechos, reglas y listas | P1 | Documento de P1 |
| 3. Gramática BNF y ejemplos de frases | P2 | Documento de P2 |
| 4. Procedimiento de recomendación | P1 | Documento de P1 |
| 5. Cinco casos de prueba | P1, P2 y P3 | `docs/casos_prueba.md` |
| 6. Limitaciones y aportes | P3 recopila | Secciones 8 y 9 de este contrato, más las de P1 y P2 |
| 7. Fuentes consultadas | Todos | Si aplica |

---

## 11. Fechas clave para P3

| Fecha | Qué hacer |
|---|---|
| Lun 12 | Conversación funcionando con stubs. Repositorio creado y rama `p3-interaccion` subida. |
| Mar 13 | Pedir a P1 y P2 una primera versión que cargue sin errores. Caso 4 preparado. |
| Mié 14 | Integración (3.6), corrida de los 5 casos, ensamblado de la documentación. |
| Jue 15 | Revisión final, exportar el PDF y entregar el enlace en Tec Digital. |
