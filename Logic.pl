:- encoding(utf8).

% ===============================================================
% OrientadorCE - Programa principal
% Integra la base de conocimientos (Persona 1), la gramática DCG
% (Persona 2) y el diálogo (Persona 3).
%
% Ejecutar desde esta carpeta:
%   swipl Logic.pl
%   ?- iniciar.
%
% BD.pl declara profesion/1, afinidades/2, incompatibles/2,
% y pregunta/2. BNF.pl declara interpretar/2.
% ===============================================================

:- consult('BD.pl').
:- consult('BNF.pl').
:- use_module(library(readutil), [read_line_to_string/2]).
:- use_module(library(lists), [member/2, max_list/2]).

% ---------------------------------------------------------------
% Reglas de recomendacion (Persona 1)
% ---------------------------------------------------------------

% Extrae los intereses afirmativos y elimina repetidos.
afirmativas(Prefs, Intereses) :-
    findall(I, member(pref(I, afirmativa), Prefs), Encontrados),
    sort(Encontrados, Intereses).

% Extrae los intereses negativos y elimina repetidos.
negativas(Prefs, Intereses) :-
    findall(I, member(pref(I, negativa), Prefs), Encontrados),
    sort(Encontrados, Intereses).

% Una profesion es compatible si no contradice lo que el usuario
% afirma y si no requiere una afinidad que el usuario rechaza.
compatible(Profesion, Prefs) :-
    profesion(Profesion),
    afirmativas(Prefs, Afirmativos),
    negativas(Prefs, Negativos),
    afinidades(Profesion, Afinidades),
    incompatibles(Profesion, Incompatibles),
    \+ (member(I, Afirmativos), member(I, Incompatibles)),
    \+ (member(I, Negativos), member(I, Afinidades)).

% El puntaje equivale al numero de afinidades afirmadas.
puntaje(Profesion, Prefs, Puntaje) :-
    afirmativas(Prefs, Afirmativos),
    afinidades(Profesion, Afinidades),
    findall(I, (member(I, Afirmativos), member(I, Afinidades)), Coincidencias),
    length(Coincidencias, Puntaje).

% recomendar(+Prefs, -Profesiones)
% Devuelve todas las profesiones compatibles con puntaje maximo
% (al menos 1). Si no hay candidatas devuelve la lista vacia.
recomendar(Prefs, Profesiones) :-
    findall(Puntaje-Profesion,
            (compatible(Profesion, Prefs),
             puntaje(Profesion, Prefs, Puntaje),
             Puntaje > 0),
            Candidatas),
    (   Candidatas == []
    ->  Profesiones = []
    ;   findall(P, member(P-_, Candidatas), Puntajes),
        max_list(Puntajes, Maximo),
        findall(Profesion, member(Maximo-Profesion, Candidatas), Profesiones)
    ).

% ---------------------------------------------------------------
% Conversacion (Persona 3)
% ---------------------------------------------------------------

% Se conserva el conjunto de 6 intereses previsto en el prototipo.
% Los 12 intereses siguen disponibles para el texto inicial y
% para cualquier respuesta valida reconocida por BNF.pl.
intereses_a_preguntar([
    tecnologia, matematicas, resolver_problemas,
    ayudar_personas, escuchar, arte
]).

% iniciar/0 es el punto de entrada. Si se acaba la entrada,
% termina sin calcular una recomendacion a partir de datos incompletos.
iniciar :-
    writeln('OrientadorCE: Hola. Estoy aquí para ayudarte a explorar opciones profesionales.'),
    writeln('OrientadorCE: ¿Qué te gusta? Responde con frases como "Me gusta la tecnología".'),
    (   leer_pref(PrimeraPref),
        intereses_a_preguntar(Intereses),
        preguntar_todas(Intereses, [PrimeraPref], Prefs),
        recomendar(Prefs, Resultado)
    ->  mostrar_resultado(Resultado)
    ;   writeln('OrientadorCE: Se terminó la entrada antes de completar el cuestionario.')
    ).

% leer_pref(-Pref): lee hasta recibir una frase reconocida.
% No agrega las respuestas invalidas al registro de preferencias.
% Falla ante EOF para que iniciar/0 finalice sin forzar halt/0.
leer_pref(Pref) :-
    write('Usuario: '),
    flush_output,
    read_line_to_string(user_input, Linea),
    (   Linea == end_of_file
    ->  fail
    ;   interpretar(Linea, Pref)
    ->  true
    ;   writeln('OrientadorCE: No entendí esa frase. Reformúlala, por ejemplo: "No me gusta el arte".'),
        leer_pref(Pref)
    ).

% preguntar_todas(+Intereses, +Acum, -Prefs)
% Pregunta solo por intereses aun no registrados.
% Cuando se responde por otro interes, tambien lo conserva,
% pero vuelve a solicitar la respuesta al interes preguntado.
preguntar_todas([], Prefs, Prefs).
preguntar_todas([Interes|Resto], Acum, Prefs) :-
    (   ya_registrado(Interes, Acum)
    ->  preguntar_todas(Resto, Acum, Prefs)
    ;   pregunta(Interes, Texto),
        format('OrientadorCE: ~w~n', [Texto]),
        leer_pref(Preferencia),
        actualizar_preferencia(Preferencia, Acum, NuevoAcum),
        (   Preferencia = pref(Interes, _)
        ->  preguntar_todas(Resto, NuevoAcum, Prefs)
        ;   writeln('OrientadorCE: También necesito tu respuesta a la pregunta anterior.'),
            preguntar_todas([Interes|Resto], NuevoAcum, Prefs)
        )
    ).

% Confirma que ya existe una preferencia sobre el interes.
ya_registrado(Interes, Prefs) :-
    member(pref(Interes, _), Prefs).

% Si alguien cambia de opinion sobre un interes, prevalece
% la preferencia mas reciente; se evitan contradicciones.
actualizar_preferencia(pref(Interes, Polaridad), Anteriores, Nuevas) :-
    quitar_interes(Interes, Anteriores, Filtradas),
    Nuevas = [pref(Interes, Polaridad)|Filtradas].

quitar_interes(_, [], []).
quitar_interes(Interes, [pref(Interes, _)|Resto], Filtradas) :-
    !,
    quitar_interes(Interes, Resto, Filtradas).
quitar_interes(Interes, [Otra|Resto], [Otra|Filtradas]) :-
    quitar_interes(Interes, Resto, Filtradas).

% Mensajes finales: ninguna, una o varias recomendaciones.
mostrar_resultado([]) :-
    !,
    writeln('OrientadorCE: No encontré profesiones compatibles con tus preferencias.').
mostrar_resultado([Profesion]) :-
    !,
    format('OrientadorCE: Según tus preferencias, te recomiendo ~w.~n', [Profesion]).
mostrar_resultado(Profesiones) :-
    atomic_list_concat(Profesiones, ', ', Texto),
    format('OrientadorCE: Según tus preferencias, te recomiendo estas opciones: ~w.~n', [Texto]).
