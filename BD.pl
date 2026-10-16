:- encoding(utf8).



profesion('Ingenieria en Computadores').
profesion('Psicologia').
profesion('Medicina').
profesion('Arquitectura').
profesion('Derecho').
profesion('Biologia').
profesion('Docencia').
profesion('Diseno Grafico').
profesion('Administracion de Empresas').
profesion('Periodismo').
profesion('Ingenieria Civil').
profesion('Agronomia').

afinidades('Ingenieria en Computadores', [matematicas, tecnologia, resolver_problemas]).
afinidades('Psicologia', [ayudar_personas, escuchar, ciencias]).
afinidades('Medicina', [ayudar_personas, ciencias, resolver_problemas]).
afinidades('Arquitectura', [arte, matematicas, trabajo_manual]).
afinidades('Derecho', [hablar, escribir, liderazgo]).
afinidades('Biologia', [ciencias, naturaleza, resolver_problemas]).
afinidades('Docencia', [ayudar_personas, hablar, liderazgo]).
afinidades('Diseno Grafico', [arte, tecnologia]).
afinidades('Administracion de Empresas', [liderazgo, matematicas, hablar]).
afinidades('Periodismo', [escribir, hablar, escuchar]).
afinidades('Ingenieria Civil', [matematicas, trabajo_manual, liderazgo]).
afinidades('Agronomia', [naturaleza, ciencias, trabajo_manual]).

incompatibles('Ingenieria en Computadores', [trabajo_manual, naturaleza]).
incompatibles('Psicologia', [tecnologia, trabajo_manual]).
incompatibles('Medicina', [arte]).
incompatibles('Arquitectura', [escribir]).
incompatibles('Derecho', [trabajo_manual, naturaleza]).
incompatibles('Biologia', [hablar]).
incompatibles('Docencia', [trabajo_manual]).
incompatibles('Diseno Grafico', [matematicas]).
incompatibles('Administracion de Empresas', [arte, naturaleza]).
incompatibles('Periodismo', [matematicas, trabajo_manual]).
incompatibles('Ingenieria Civil', [escribir]).
incompatibles('Agronomia', [tecnologia]).
% Banco de preguntas (Persona 3). Los atomos coinciden con BNF.pl.
pregunta(matematicas,        '¿Te gustan las matemáticas?').
pregunta(tecnologia,         '¿Te gusta la tecnología?').
pregunta(resolver_problemas, '¿Te gusta resolver problemas?').
pregunta(ayudar_personas,    '¿Te interesa ayudar a las personas?').
pregunta(escuchar,           '¿Prefieres escuchar a los demás?').
pregunta(hablar,             '¿Te gusta hablar en público?').
pregunta(ciencias,           '¿Te interesan las ciencias?').
pregunta(arte,               '¿Te gusta el arte?').
pregunta(naturaleza,         '¿Te gusta la naturaleza?').
pregunta(escribir,           '¿Te gusta escribir?').
pregunta(liderazgo,          '¿Te gusta liderar equipos?').
pregunta(trabajo_manual,     '¿Te gusta trabajar con las manos?').
