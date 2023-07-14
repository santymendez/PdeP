%% quedaEn(lugar, lugar)
quedaEn(venezuela, america).
quedaEn(argentina, america).
quedaEn(patagonia, argentina).
quedaEn(aula522, utn). % Sí, un aula es un lugar!
quedaEn(utn, buenosAires).
quedaEn(buenosAires, argentina).

nacio(dani, buenosAires).
nacio(alf, buenosAires).
nacio(nico, buenosAires).

tarea(dani, tomarExamen(paradigmaLogico, aula522), fecha(10, 8, 2017)).
tarea(dani, meterGol(primeraDivision), fecha(10, 8, 2017)).
tarea(alf, discurso(utn, 0), fecha(11, 8, 2017)).

% DULCE HOGAR

nuncaSalioDeCasa(Trabajador):-
    nacio(Trabajador, Lugar),
    forall(tarea(Trabajador, Tarea, _), lugar(Tarea, Lugar)).

lugar(tomarExamen(_, Lugar), Lugar).
lugar(discurso(Lugar, _), Lugar).
lugar(meterGol(Torneo), Lugar):-
    seJuegaEn(Torneo, Lugar).

seJuegaEn(primeraDivision, argentina).

% ESTRES NACIONAL

esEstresante(Tarea):-
    lugar(Tarea, Lugar),
    estaEnArgentina(Lugar),
    tareaEstresante(Tarea).

estaEnArgentina(Lugar):-
    quedaEn(Lugar, argentina).
estaEnArgentina(Lugar):-
    quedaEn(Lugar, LugarIntermedio),
    estaEnArgentina(LugarIntermedio).

tareaEstresante(discurso(_, CantPersonas)):-
    CantPersonas > 30000.
tareaEstresante(tomarExamen(Tema, _)):-
    temaComplejo(Tema).
tareaEstresante(meterGol(Torneo)):-
    seJuegaEn(Torneo, argentina).

temaComplejo(paradigmaLogico).
temaComplejo(integralesCompuestas).

% TRABAJADORES ALTERADOS

caracteristica(Trabajador, zen):-
    not(hizoTareaEstresante(Trabajador, _)).

caracteristica(Trabajador, loco):-
    tarea(Trabajador, _, _),
    forall(tarea(Trabajador, Tarea, fecha(_, _, 2017)), hizoTareaEstresante(Trabajador, Tarea)).

caracteristica(Trabajador, sabios):-
    hizoTareaEstresante(Trabajador, Tarea),
    not((hizoTareaEstresante(Trabajador, Tarea2), Tarea2 \= Tarea)).

hizoTareaEstresante(Trabajador, Tarea):-
    tarea(Trabajador, Tarea, _),
    esEstresante(Tarea).

% EL MAS CHAPITA

masChapita(Trabajador):-
    cantidadTareasEstresantes(Trabajador, CantMaxima),
    forall(cantidadTareasEstresantes(_, Cant), CantMaxima >= Cant).

cantidadTareasEstresantes(Trabajador, Cantidad):-
    tarea(Trabajador, _, _),
    findall(Tarea, hizoTareaEstresante(Trabajador, Tarea), Tareas),
    length(Tareas, Cantidad).