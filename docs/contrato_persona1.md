# Contrato de la Persona 1: base de conocimientos y reglas

Parte del proyecto OrientadorCE (CE1106, II semestre 2026).

## 1. Qué entrego

| Archivo | Contenido |
|---|---|
| `BD.pl` | 12 profesiones con sus afinidades e incompatibilidades |
| `reglas_p1.pl` | reglas de recomendación (se pegan en `Logic.pl` al integrar) |

`reglas_p1.pl` carga `BD.pl` con `consult`. Al integrar, esa línea sale de aquí y queda en el `Logic.pl` final.

## 2. Predicados que ofrezco

| Predicado | Qué hace |
|---|---|
| `profesion(?Nombre)` | nombres de las profesiones |
| `afinidades(+Profesion, -Intereses)` | lista de intereses que le quedan bien a la profesión |
| `incompatibles(+Profesion, -Intereses)` | lista de intereses contrarios a la profesión |
| `recomendar(+Prefs, -Profesiones)` | devuelve la lista de profesiones recomendadas, o `[]` si no hay ninguna |

Los predicados auxiliares (`afirmativas/2`, `negativas/2`, `compatible/2`, `puntaje/3`) son internos. P2 y P3 no los necesitan.

## 3. Formato de los datos

`Prefs` es una lista de términos `pref(Interes, Polaridad)`:

```prolog
[pref(matematicas, afirmativa), pref(tecnologia, negativa)]
```

- `Polaridad` es `afirmativa` o `negativa`.
- `Interes` debe ser uno de estos átomos, los de la tabla del grupo: `matematicas`, `tecnologia`, `resolver_problemas`, `ayudar_personas`, `escuchar`, `hablar`, `ciencias`, `arte`, `naturaleza`, `escribir`, `liderazgo`, `trabajo_manual`.
- Un interés que no esté en esa lista no rompe nada, pero tampoco afecta la recomendación.
- Los nombres de profesión van sin tildes y entre comillas simples, por ejemplo `'Ingenieria en Computadores'`.

## 4. Lo que necesito de los demás

- **P2 (gramática):** que `interpretar/2` devuelva `pref(Interes, Polaridad)` con los átomos de la tabla de arriba, escritos igual.
- **P3 (conversación):** que me pase la lista completa de preferencias ya interpretadas. Las frases que no se reconocen no deben entrar en la lista.

## 5. Criterio de recomendación

1. Se descarta toda profesión que tenga entre sus incompatibles un interés con preferencia afirmativa.
2. Se descarta toda profesión que tenga entre sus afinidades un interés con preferencia negativa.
3. A las que quedan se les calcula el puntaje: cuántas de sus afinidades coinciden con intereses afirmativos.
4. Se recomiendan las de mayor puntaje, con mínimo 1. Si no queda ninguna, se devuelve `[]`.

Si hay empate en el puntaje máximo, se devuelven todas las empatadas.

---

## 6. Texto para la documentación (hechos, reglas y listas)

**Hechos y listas.** La base de conocimientos (`BD.pl`) tiene tres predicados. `profesion/1` declara las 12 profesiones. `afinidades/2` y `incompatibles/2` asocian a cada profesión una lista de intereses. Esas listas son átomos tomados de un vocabulario fijo de 12 intereses.

**Reglas.** `afirmativas/2` y `negativas/2` separan las preferencias del usuario según su polaridad. `compatible/2` decide si una profesión choca con alguna preferencia. `puntaje/3` cuenta las afinidades que coinciden con lo que le gusta al usuario. `recomendar/2` junta todo y devuelve las profesiones.

**Procedimiento de recomendación.** Es el criterio de la sección 5. Se usa `findall/3` para reunir las profesiones compatibles junto con su puntaje, y se queda con las del puntaje más alto. Se usa la negación como falla (`\+`) para descartar profesiones.

## 7. Casos de prueba que me tocan

Los resultados esperados salen de revisar la base de datos a mano. La columna "Obtenido" se llena al correrlos en la consola.

### Caso 3: negación de una afinidad (dos ejecuciones)

Entradas: matemáticas y resolver problemas afirmativos. Solo cambia la tecnología.

| Ejecución | Preferencias | Esperado | Obtenido | ¿Pasó? |
|---|---|---|---|---|
| A | matematicas+, tecnologia+, resolver_problemas+ | `['Ingenieria en Computadores']` | | |
| B | matematicas+, tecnologia-, resolver_problemas+ | `['Medicina','Arquitectura','Biologia','Administracion de Empresas','Ingenieria Civil']` | | |

```prolog
?- recomendar([pref(matematicas,afirmativa), pref(tecnologia,afirmativa), pref(resolver_problemas,afirmativa)], R).
?- recomendar([pref(matematicas,afirmativa), pref(tecnologia,negativa), pref(resolver_problemas,afirmativa)], R).
```

Justificación: la tecnología es determinante porque `tecnologia` está en las afinidades de Ingeniería en Computadores. En la ejecución B la preferencia negativa la descarta (regla 2), y la recomendación deja de ser esa profesión. La frase negativa no se cuenta como afinidad, por eso la preferencia no suma puntaje.

### Caso 5: perfil sin coincidencias

Entradas: trabajo manual, tecnología y escribir afirmativos; arte negativo.

```prolog
?- recomendar([pref(trabajo_manual,afirmativa), pref(tecnologia,afirmativa), pref(escribir,afirmativa), pref(arte,negativa)], R).
```

Esperado: `R = []`. Obtenido: (llenar). ¿Pasó?: (llenar).

Justificación: ninguna profesión sobrevive.

- **Descartadas por incompatibilidad con algo afirmado (regla 1):**
  - `trabajo_manual`: Ingeniería en Computadores, Derecho, Docencia y Periodismo.
  - `tecnologia`: Psicología y Agronomía.
  - `escribir`: Arquitectura e Ingeniería Civil.
- **Descartada por una afinidad negada (regla 2):** Diseño Gráfico, porque `arte` está en sus afinidades.
- **Quedan con puntaje 0 (regla 4):** Medicina, Biología y Administración, porque ninguna de sus afinidades coincide con lo afirmado.

## 8. Cómo probar

```
swipl reglas_p1.pl
?- recomendar([pref(tecnologia,afirmativa)], R).
```

Si se cambia un archivo, se guarda y se escribe `make.` en la consola para recargar.
