% Punto 1

herramienta(ana, circulo(50,3)).
herramienta(ana, cuchara(40)).
herramienta(beto, circulo(20,1)).
herramienta(beto, libro(inerte)).
herramienta(cata, libro(vida)).
herramienta(cata, circulo(100,5)).

tiene(ana, agua).
tiene(ana, vapor).
tiene(ana, tierra).
tiene(ana, hierro).

tiene(beto, Elemento):-
    tiene(ana, Elemento).

tiene(cata, fuego).
tiene(cata, tierra).
tiene(cata, agua).
tiene(cata, aire).

% Se dice que cata no tiene vapor, pero por el principio de universo cerrado, solo nos interesa lo que tiene,
% lo que no tiene es desconocido.

paraHacer(pasto, [agua, tierra]).
paraHacer(hierro, [fuego, agua, tierra]).
paraHacer(huesos, [pasto, agua]).
paraHacer(presion, [hierro, vapor]).
paraHacer(vapor, [agua, fuego]).
paraHacer(playStation, [silicio, hierro, plastico]).
paraHacer(silicio, [tierra]).
paraHacer(plastico, [huesos, presion]).

% Punto 2

tieneIngredientesPara(Elemento, Jugador):-
    tiene(Jugador, _),
    paraHacer(Elemento, _),
    forall(necesita(Elemento, Ingrediente), tiene(Jugador, Ingrediente)).

necesita(Elemento, Ingrediente):-
    paraHacer(Elemento, Ingredientes),
    member(Ingrediente, Ingredientes).

% Punto 3

estaVivo(agua).
estaVivo(fuego).

estaVivo(Elemento):-
    necesita(Elemento, agua).
estaVivo(Elemento):-
    algoEstaVivo(Elemento).

estaVivo(Elemento):-
    necesita(Elemento, fuego).
estaVivo(Elemento):-
    algoEstaVivo(Elemento).

algoEstaVivo(Elemento):-
    necesita(Elemento, Algo),
    estaVivo(Algo).

% Punto 4

puedeConstruir(Elemento, Jugador):-
    tieneIngredientesPara(Elemento, Jugador),
    tieneHerramientaPara(Elemento, Jugador).

tieneHerramientaPara(Elemento, Jugador):-
    herramienta(Jugador, libro(vida)),
    estaVivo(Elemento).

tieneHerramientaPara(Elemento, Jugador):-
    herramienta(Jugador, libro(inerte)),
    not(estaVivo(Elemento)).

tieneHerramientaPara(Elemento, Jugador):-
    herramienta(Jugador, Herramienta),
    cantidadQueSoporta(Herramienta, Soporte),
    cantidadQueNecesita(Elemento, Necesario),
    Soporte >= Necesario.

cantidadQueSoporta(cuchara(CM), Soporte):-
    Soporte is CM/10.
cantidadQueSoporta(circulo(Diametro, Niveles), Soporte):-
    Soporte is Diametro/100 * Niveles.

cantidadQueNecesita(Elemento, Necesario):-
    paraHacer(Elemento, Ingredientes),
    length(Ingredientes, Necesario).

% Punto 5

esTodopoderoso(Jugador):-
    tiene(Jugador, _),
    forall(tiene(Jugador, Elemento), primitivo(Elemento)),
    forall(elementoQueNoTiene(Jugador, Elemento), tieneHerramientaPara(Elemento, Jugador)).

primitivo(Elemento):-
    not(paraHacer(Elemento, _)).

elementoQueNoTiene(Jugador, Elemento):-
    tiene(_, Elemento),
    not(tiene(Jugador, Elemento)).

% Punto 6

quienGana(Jugador):-
    cantQuePuedeConstruir(Jugador, CantMaxima),
    forall(cantQuePuedeConstruir(_, Cantidad), CantMaxima >= Cantidad).

cantQuePuedeConstruir(Jugador, Cantidad):-
    puedeConstruir(_, Jugador),
    findall(Elemento, puedeConstruir(Elemento, Jugador), Elementos),
    length(Elementos, Cantidad).