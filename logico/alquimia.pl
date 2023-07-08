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

paraHacer(pasto, [agua, tierra]).
paraHacer(hierro, [fuego, agua, tierra]).
paraHacer(huesos, [pasto, agua]).
paraHacer(presion, [hierro, vapor]).
paraHacer(vapor, [agua, fuego]).
paraHacer(playStation, [silicio, hierro, plastico]).
paraHacer(silicio, [tierra]).
paraHacer(plastico, [huesos, presion]).

tieneIngredientesPara(Jugador, Elemento):-
    tiene(Jugador, _),
    paraHacer(Elemento, _),
    forall(necesita(Elemento, Ingrediente), tiene(Jugador, Ingrediente)).

necesita(Elemento, Ingrediente):-
    paraHacer(Elemento, Ingredientes),
    member(Ingrediente, Ingredientes).

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