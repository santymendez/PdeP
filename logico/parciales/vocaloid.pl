canta(megurineLuka, cancion(nightFever, 4)).
canta(megurineLuka, cancion(foreverYoung, 5)).
canta(hatsuneMiku, cancion(tellYourWorld, 4)).
canta(gumi, cancion(foreverYoung, 4)).
canta(gumi, cancion(tellYourWorld, 5)).
canta(seeU, cancion(novemberRain, 6)).
canta(seeU, cancion(nightFever, 5)).

% Punto 1

esNovedoso(Cantante):-
    sabeAlMenosDos(Cantante),
    duracionTotalCanciones(Cantante, Duracion),
    Duracion < 15.

sabeAlMenosDos(Cantante):-
    canta(Cantante, Cancion1),
    canta(Cantante, Cancion2),
    Cancion1 \= Cancion2.

duracionTotalCanciones(Cantante, Tiempo):-
    canta(Cantante, _),
    findall(Tiempo, duracionCancion(Cantante, Tiempo), ListaTiempos),
    sumlist(ListaTiempos, Tiempo).

duracionCancion(Cantante, Duracion):-
    canta(Cantante, cancion(_, Duracion)).

% Punto 2

esAcelerado(Cantante):-
    canta(Cantante, _),
    not((duracionCancion(Cantante, Duracion), Duracion > 4)).

% Parte 2

% Punto 1

concierto(mikuExpo, estadosUnidos, 2000, gigante(2, 6)).
concierto(magicalMirai, japon, 3000, gigante(3, 10)).
concierto(vocaltekVisions, estadosUnidos, 1000, mediano(9)).
concierto(mikuFest, argentina, 100, pequenio(4)).

% Punto 2

puedeParticipar(Concierto, hatsuneMiku):-
    concierto(Concierto, _, _, _).

puedeParticipar(Concierto, Cantante):-
    canta(Cantante, _),
    Cantante \= hatsuneMiku,
    concierto(Concierto, _, _, Condiciones),
    cumpleCondiciones(Cantante, Condiciones).

cumpleCondiciones(Cantante, gigante(CantCanciones, DuracionMinima)):-
    cantidadCanciones(Cantante, Cantidad),
    Cantidad >= CantCanciones,
    duracionTotalCanciones(Cantante, Duracion),
    Duracion > DuracionMinima.

cumpleCondiciones(Cantante, mediano(DuracionMaxima)):-
    duracionTotalCanciones(Cantante, Duracion),
    Duracion < DuracionMaxima.

cumpleCondiciones(Cantante, pequenio(DuracionMinima)):-
    duracionCancion(Cantante, Duracion),
    Duracion > DuracionMinima.

cantidadCanciones(Cantante, Cantidad):-
    canta(Cantante, _),
    findall(Cancion, canta(Cantante, Cancion), Canciones),
    length(Canciones, Cantidad).

% Punto 3

elMasFamoso(Cantante):-
    famaTotal(Cantante, Fama),
    forall(famaTotal(_, OtraFama), Fama >= OtraFama).

famaTotal(Cantante, Fama):-
    canta(Cantante, _),
    findall(Fama, famaConcierto(Cantante, Fama), CantFama),
    sumlist(CantFama, FamaTotal),
    cantidadCanciones(Cantante, Cantidad),
    Fama is FamaTotal * Cantidad.

famaConcierto(Cantante, Fama):-
    puedeParticipar(Concierto, Cantante),
    fama(Concierto, Fama).

fama(Concierto, Fama):-
    concierto(Concierto, _, Fama, _).

% Punto 4

conoce(megurineLuka, hatsuneMiku).
conoce(megurineLuka, gumi).
conoce(gumi, seeU).
conoce(seeU, kaito).

unicoParticipante(Cantante):-
    canta(Cantante, _),
    forall(conocido(Cantante, Conocido), (puedeParticipar(Concierto, Cantante), not(puedeParticipar(Concierto, Conocido)))).

conocido(Cantante, Conocido):-
    conoce(Cantante, Conocido).
conocido(Cantante, Conocido):-
    conoce(Cantante, Intermedio),
    conocido(Intermedio, Conocido).