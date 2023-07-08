% Parte 1

casa(gryffindor).
casa(slytherin).
casa(ravenclaw).
casa(hufflepuff).

mago(harry).
mago(draco).
mago(hermione).


sangre(harry, mestiza).
sangre(draco, pura).
sangre(hermione, impura).

odiariaIr(slytherin, harry).
odiariaIr(hufflepuff, draco).

corajude(harry).

amistose(harry).

orgullose(harry).
orgullose(draco).
orgullose(hermione).

inteligente(harry).
inteligente(draco).
inteligente(hermione).

responsable(hermione).

condicionCasa(gryffindor, Mago):-
    corajude(Mago).

condicionCasa(slytherin, Mago):-
    orgullose(Mago),
    inteligente(Mago).

condicionCasa(ravenclaw, Mago):-
    inteligente(Mago),
    responsable(Mago).

condicionCasa(hufflepuff, Mago):-
    amistose(Mago).

% Punto 1

permiteEntrar(gryffindor, mago(_)).
permiteEntrar(ravenclaw, mago(_)).
permiteEntrar(hufflepuff, mago(_)).
permiteEntrar(slytherin, Mago):-
    sangre(Mago, Sangre),
    Sangre \= impura.

% Punto 2

tieneCaracterApropiado(Mago, Casa):-
    condicionCasa(Casa, Mago).

% Punto 3

puedeQuedar(gryffindor, hermione).
puedeQuedar(Casa, Mago):-
    tieneCaracterApropiado(Mago, Casa),
    permiteEntrar(Casa, Mago),
    not(odiariaIr(Casa, Mago)).

% Punto 4

cadenaDeAmistades(Magos):-
    todosAmistosos(Magos),
    puedenQuedarTodos(Magos).

todosAmistosos(Magos):-
    forall(member(Mago, Magos), amistose(Mago)).

puedenQuedarTodos([_]).
puedenQuedarTodos([Mago1, Mago2 | Magos]):-
    puedeQuedar(Casa, Mago1),
    puedeQuedar(Casa, Mago2),
    puedenQuedarTodos([Mago2 | Magos]).

% Parte 2

realizoAccion(harry, andarFueraDeCama).
realizoAccion(hermione, irAlTercerPiso).
realizoAccion(hermione, irASeccionRestringidaBiblioteca).
realizoAccion(draco, irAMazmorras).
realizoAccion(ron, ganarAjedrez).
realizoAccion(hermione, salvarAmigos).
realizoAccion(harry, ganarAVoldemort).
realizoAccion(hermione, responder(dondeEstaBezoar, 20, snape)).
realizoAccion(hermione, responder(comoHacerLevitarPluma, 25, flitwick)).

puntosObtenidos(andarFueraDeCama, -50).
puntosObtenidos(irAlTercerPiso, -75).
puntosObtenidos(irASeccionRestringidaBiblioteca, -10).
puntosObtenidos(irAMazmorras, 0).
puntosObtenidos(ganarAjedrez, 50).
puntosObtenidos(salvarAmigos, 50).
puntosObtenidos(ganarAVoldemort, 60).
puntosObtenidos(responder(_, Dificultad, snape), Dificultad/2).
puntosObtenidos(responder(_, Dificultad, _), Dificultad).

esDe(hermione, gryffindor).
esDe(ron, gryffindor).
esDe(harry, gryffindor).
esDe(draco, slytherin).
esDe(luna, ravenclaw).

% Punto 1

esBuenAlumno(Mago):-
    realizoAccion(Mago, Accion),
    puntosObtenidos(Accion, Puntos),
    Puntos >= 0.

accionRecurrente(Accion):-
    realizoAccion(Mago1, Accion),
    realizoAccion(Mago2, Accion),
    Mago1 \= Mago2.

% Punto 2

puntajeTotal(Casa, Puntaje):-
    esDe(_, Casa),
    findall(Puntos, (esDe(Mago, Casa), puntosMago(Mago, Puntos)), ListaPuntos),
    sumlist(ListaPuntos, Puntaje).

puntosMago(Mago, Puntos):-
    realizoAccion(Mago, _),
    findall(Puntos, puntosPorRealizarAccion(Mago, Puntos), ListaPuntos),
    sumlist(ListaPuntos, Puntos).

puntosPorRealizarAccion(Mago, Puntos):-
    realizoAccion(Mago, Accion),
    puntosObtenidos(Accion, Puntos).

% Punto 3

ganadora(Casa):-
    findall(Puntaje, puntajeTotal(_, Puntaje), ListaPuntos),
    max_member(MaxPuntos, ListaPuntos),
    puntajeTotal(Casa, MaxPuntos).