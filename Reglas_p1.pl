% reglas_p1.pl - reglas de recomendacion (despues se pasan a Logic.pl)
% Prefs es una lista de pref(Interes, afirmativa) o pref(Interes, negativa)

:- consult('BD.pl').

% intereses que el usuario dijo que si le gustan (sin repetidos)
afirmativas(Prefs, Ints) :-
    findall(I, member(pref(I, afirmativa), Prefs), L),
    sort(L, Ints).

% intereses que el usuario dijo que no le gustan (sin repetidos)
negativas(Prefs, Ints) :-
    findall(I, member(pref(I, negativa), Prefs), L),
    sort(L, Ints).

% una profesion es compatible si:
% - nada de lo que le gusta al usuario esta en sus incompatibles
% - nada de lo que no le gusta esta en sus afinidades
compatible(P, Prefs) :-
    profesion(P),
    afirmativas(Prefs, As),
    negativas(Prefs, Ns),
    afinidades(P, Af),
    incompatibles(P, Inc),
    \+ ( member(I, As), member(I, Inc) ),
    \+ ( member(I, Ns), member(I, Af) ).

% puntaje = cuantas afinidades de la profesion coinciden con lo que le gusta
puntaje(P, Prefs, N) :-
    afirmativas(Prefs, As),
    afinidades(P, Af),
    findall(I, (member(I, As), member(I, Af)), Coinc),
    length(Coinc, N).

% recomendar(+Prefs, -Profesiones)
% devuelve las compatibles con mayor puntaje (minimo 1), o [] si no hay
recomendar(Prefs, Profesiones) :-
    findall(N-P, ( compatible(P, Prefs), puntaje(P, Prefs, N), N > 0 ), Pares),
    (   Pares == []
    ->  Profesiones = []
    ;   max_member(Max-_, Pares),
        findall(P, member(Max-P, Pares), Profesiones)
    ).