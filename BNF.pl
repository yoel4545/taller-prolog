:- encoding(utf8).
:- use_module(library(apply), [maplist/3, exclude/3]).

% BNF.pl - Persona 2: interpretacion de preferencias mediante DCG.
% Interfaz publica:
% interpretar(+Texto, -Pref)
% Recibe un string, entrega pref(Interes, afirmativa/negativa),
% y falla cuando el texto no pertenece a la gramatica.

% 1. Punto de entrada: normalizar palabras y analizarlas con una DCG.
% phrase/2 exige consumir todos los tokens: no acepta frases parciales.
interpretar(Texto, Pref) :-
    normalizar(Texto, Palabras),
    phrase(frase(Pref), Palabras).

% 2. Normalizacion: minusculas, tildes, signos y tokenizacion.
% Las palabras finales son atomos (por ejemplo, [me,gusta,la,tecnologia]).
normalizar(Texto, Palabras) :-
    string(Texto),
    string_lower(Texto, Minusculas),
    string_chars(Minusculas, Caracteres),
    maplist(normalizar_caracter, Caracteres, SinAcentos),
    string_chars(TextoNormalizado, SinAcentos),
    split_string(TextoNormalizado,
                 " \t\n\r.,;:!?¡¿()[]\"'",
                 " \t\n\r.,;:!?¡¿()[]\"'",
                 Fragmentos),
    exclude(=(""), Fragmentos, NoVacios),
    maplist(atom_string, Palabras, NoVacios).

% Transformaciones de letras acentuadas. El resto se conserva.
normalizar_caracter(Origen, Destino) :-
    (   equivalencia(Origen, Destino)
    ->  true
    ;   Destino = Origen
    ).

equivalencia('á', 'a').
equivalencia('é', 'e').
equivalencia('í', 'i').
equivalencia('ó', 'o').
equivalencia('ú', 'u').
equivalencia('ü', 'u').

% 3. Gramatica de clausulas completas.
% El orden permite diferenciar afirmaciones y negaciones.
frase(pref(Interes, negativa)) -->
    [no], expresion_gusto, interes(Interes).
frase(pref(Interes, afirmativa)) -->
    expresion_gusto, interes(Interes).

% 4. Expresiones que indican gusto o interes.
expresion_gusto --> [me, gusta].
expresion_gusto --> [me, gustan].
expresion_gusto --> [me, encanta].
expresion_gusto --> [me, encantan].
expresion_gusto --> [me, interesa].
expresion_gusto --> [me, interesan].
expresion_gusto --> [disfruto].
expresion_gusto --> [prefiero].

% 5. Vocabulario de intereses: atomos acordados con P1 y P3.
% Cada sinonimo entrega el mismo atomo canonico que utiliza BD.pl.
interes(matematicas) --> [las, matematicas].
interes(matematicas) --> [los, numeros].

interes(tecnologia) --> [la, tecnologia].
interes(tecnologia) --> [las, computadoras].

interes(resolver_problemas) --> [resolver, problemas].

interes(ayudar_personas) --> [ayudar, a, las, personas].
interes(ayudar_personas) --> [ayudar, a, los, demas].

interes(escuchar) --> [escuchar, a, los, demas].

interes(hablar) --> [hablar, en, publico].
interes(hablar) --> [hablar, con, la, gente].

interes(ciencias) --> [las, ciencias].
interes(ciencias) --> [investigar].

interes(arte) --> [el, arte].
interes(arte) --> [dibujar].
interes(arte) --> [disenar].

interes(naturaleza) --> [la, naturaleza].
interes(naturaleza) --> [el, aire, libre].

interes(escribir) --> [escribir].
interes(escribir) --> [leer].

interes(liderazgo) --> [liderar, equipos].
interes(liderazgo) --> [organizar].

interes(trabajo_manual) --> [trabajar, con, las, manos].
interes(trabajo_manual) --> [construir].
