:- encoding(utf8).



% Carga las reglas de recomendacion de la Persona 1 (ellas cargan BD.pl)
:- consult('reglas_p1.pl').
% Version falsa de interpretar/2 (se quita cuando llegue BNF.pl)
:- consult('stubs.pl').


% ---------------------------------------------------------------
pregunta(matematicas,       '¿Te gustan las matemáticas?').
pregunta(tecnologia,        '¿Te gusta la tecnología?').
pregunta(resolver_problemas,'¿Te gusta resolver problemas?').
pregunta(ayudar_personas,   '¿Te interesa ayudar a las personas?').
pregunta(escuchar,          '¿Prefieres escuchar a los demás?').
pregunta(hablar,            '¿Te gusta hablar en público?').
pregunta(ciencias,          '¿Te interesan las ciencias?').
pregunta(arte,              '¿Te gusta el arte?').
pregunta(naturaleza,        '¿Te gusta la naturaleza?').
pregunta(escribir,          '¿Te gusta escribir?').
pregunta(liderazgo,         '¿Te gusta liderar equipos?').
pregunta(trabajo_manual,    '¿Te gusta trabajar con las manos?').

% Intereses sobre los que se va a preguntar, en orden.
intereses_a_preguntar([tecnologia, matematicas, resolver_problemas,
                       ayudar_personas, escuchar, arte]).

% ---------------------------------------------------------------
% iniciar: punto de entrada del programa
% ---------------------------------------------------------------
iniciar :-
    writeln('OrientadorCE: Hola. Estoy aquí para ayudarte a explorar opciones profesionales. ¿Qué te gusta?'),
    leer_pref(PrimeraPref),
    intereses_a_preguntar(Lista),
    preguntar_todas(Lista, [PrimeraPref], Prefs),
    recomendar(Prefs, Resultado),
    mostrar_resultado(Resultado).

% ---------------------------------------------------------------
% leer_pref(-Pref): lee una frase y la interpreta.
% Si no la reconoce, pide reformular y NO guarda nada.
% ---------------------------------------------------------------
leer_pref(Pref) :-
    write('Usuario: '),
    read_line_to_string(user_input, Linea),
    (   Linea == end_of_file
    ->  writeln('OrientadorCE: No recibí más respuestas. ¡Hasta pronto!'),
        halt
    ;   interpretar(Linea, Pref)
    ->  true
    ;   writeln('OrientadorCE: No logré entender tu respuesta. ¿Puedes reformularla? Por ejemplo: "Me gusta la tecnología".'),
        leer_pref(Pref)
    ).

% ---------------------------------------------------------------
% preguntar_todas(+Intereses, +PrefsActuales, -PrefsFinales)
% Recorre la lista de intereses. Si el usuario ya habló de uno, lo salta.
% ---------------------------------------------------------------
preguntar_todas([], Prefs, Prefs).
preguntar_todas([Interes|Resto], Acum, Prefs) :-
    (   ya_registrado(Interes, Acum)
    ->  preguntar_todas(Resto, Acum, Prefs)
    ;   pregunta(Interes, Texto),
        format('OrientadorCE: ~w~n', [Texto]),
        leer_pref(Pref),
        preguntar_todas(Resto, [Pref|Acum], Prefs)
    ).

% ya_registrado(+Interes, +Prefs): ya hay una preferencia sobre ese interes
ya_registrado(Interes, Prefs) :-
    member(pref(Interes, _), Prefs).

% ---------------------------------------------------------------
% mostrar_resultado(+Profesiones): mensaje final
% ---------------------------------------------------------------
mostrar_resultado([]) :-
    !,
    writeln('OrientadorCE: No cuento con una profesión compatible con tus preferencias.').
mostrar_resultado([Profesion]) :-
    !,
    format('OrientadorCE: Según tus preferencias, te recomiendo ~w.~n', [Profesion]).
mostrar_resultado(Profesiones) :-
    atomic_list_concat(Profesiones, ', ', Texto),
    format('OrientadorCE: Según tus preferencias, te recomiendo estas opciones: ~w.~n', [Texto]).
