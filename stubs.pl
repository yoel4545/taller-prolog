
interpretar(Texto, pref(Interes, Polaridad)) :-
    limpiar(Texto, T),
    prefijo(Prefijo, Polaridad),
    string_concat(Prefijo, Resto, T),
    interes_texto(Resto, Interes),
    !.

% Inicio de la frase y si es afirmativa o negativa
prefijo("no me gusta ",   negativa).
prefijo("no me gustan ",  negativa).
prefijo("me gusta ",      afirmativa).
prefijo("me gustan ",     afirmativa).

% Texto que escribe el usuario y el interes al que corresponde
interes_texto("las matematicas",       matematicas).
interes_texto("la tecnologia",         tecnologia).
interes_texto("resolver problemas",    resolver_problemas).
interes_texto("ayudar a las personas", ayudar_personas).
interes_texto("escuchar a los demas",  escuchar).
interes_texto("hablar en publico",     hablar).
interes_texto("las ciencias",          ciencias).
interes_texto("el arte",               arte).
interes_texto("la naturaleza",         naturaleza).
interes_texto("escribir",              escribir).
interes_texto("liderar equipos",       liderazgo).
interes_texto("trabajar con las manos", trabajo_manual).

% limpiar(+Texto, -Limpio): minusculas, sin tildes y sin espacios ni puntos al final
limpiar(Texto, Limpio) :-
    string_lower(Texto, Min),
    quitar_tildes(Min, SinTilde),
    split_string(SinTilde, "", " .!?\t", [Limpio]).

quitar_tildes(S, R) :-
    string_codes(S, Cs),
    maplist(sin_tilde, Cs, Rs),
    string_codes(R, Rs).

sin_tilde(C, S) :-
    char_code(Ch, C),
    tilde(Ch, Sin),
    !,
    char_code(Sin, S).
sin_tilde(C, C).

tilde('á', a).
tilde('é', e).
tilde('í', i).
tilde('ó', o).
tilde('ú', u).
tilde('ü', u).
