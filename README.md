# OrientadorCE: proyecto integrado

Trabajo integrado de las tres personas según `PLAN_TALLER.md`.

## Archivos que necesita el programa

- `BD.pl`: 12 profesiones, afinidades, incompatibilidades y 12 preguntas.
- `BNF.pl`: normalización, DCG e interpretación de preferencias (`interpretar/2`).
- `Logic.pl`: reglas de recomendación, cálculo de puntajes, conversación y punto de entrada `iniciar/0`.

Los tres archivos deben estar juntos en la misma carpeta. Los archivos provisionales `conversacion.pl`, `Reglas_p1.pl` y `stubs.pl` **no** se usan para la ejecución final. No cargarlos a la vez que `Logic.pl` porque duplicarían predicados.

## Ejecución

Tener SWI-Prolog instalado y abrir una terminal dentro de la carpeta del proyecto:

```bash
swipl Logic.pl
```

Después, desde el intérprete:

```prolog
?- iniciar.
```

Ejemplos válidos: `Me gusta la tecnología`, `No me gustan las matemáticas`, `Me interesa ayudar a las personas`, `Disfruto dibujar`.

Las respuestas deben ser frases completas. Solo `sí` o `no` no bastan. Si el texto no se reconoce, el programa solicita reformulación; si la entrada se termina, no emite recomendación.

El sistema pide una preferencia inicial y después aborda hasta seis intereses de su cuestionario, omitiendo los ya respondidos. Dispone de 12 intereses en la gramática y 12 preguntas, pero el cuestionario fijo de P3 usa seis. Si se responde con un interés distinto al preguntado, guarda el interés expresado y vuelve a formular la pregunta pendiente. Si se revisa una preferencia, vale la respuesta más reciente.

## Pruebas

Pruebas automáticas, desde esta misma carpeta:

```bash
swipl -q -s tests/unitarias.pl -g run_tests -t halt
swipl -q -s tests/integracion.pl -g run_tests -t halt
```

Casos reproducibles de consola (puedes usar la salida redirigida para registrar resultados):

```bash
swipl -q -s Logic.pl -g iniciar -t halt < tests/caso1.txt
swipl -q -s Logic.pl -g iniciar -t halt < tests/caso2.txt
swipl -q -s Logic.pl -g iniciar -t halt < tests/caso3a.txt
swipl -q -s Logic.pl -g iniciar -t halt < tests/caso3b.txt
swipl -q -s Logic.pl -g iniciar -t halt < tests/caso4.txt
swipl -q -s Logic.pl -g iniciar -t halt < tests/caso5.txt
```

Los resultados esperados de los casos se resumen en `docs/casos_prueba.md`. Para registrar los *resultados obtenidos* es necesario ejecutar el programa realmente en SWI-Prolog.

## Limitaciones

- Solo interpreta oraciones en el vocabulario BNF explícito; no es un analizador general de español.
- Cada frase expresa exactamente un interés, con polaridad afirmativa o negativa.
- Utiliza las 12 profesiones y las reglas de afinidad/incompatibilidad fijadas por P1; no es una evaluación vocacional profesional.
- Las preguntas no se adaptan automáticamente a la carrera más probable.
