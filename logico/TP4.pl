% Punto 1

habitante(tiaAgatha).
habitante(mayordomo).
habitante(charles).

odia(tiaAgatha, Persona):-
    habitante(Persona),
    Persona \= mayordomo.

odia(mayordomo, Persona):-
    habitante(Persona),
    Persona \= mayordomo.

odia(charles, Persona):-
    habitante(Persona),
    not(odia(tiaAgatha, Persona)).

esMasRicoQue(tiaAgatha, Persona):-
    habitante(Persona),
    not(odia(mayordomo, Persona)).

asesinoAgatha(Asesino):-
    habitante(Asesino),
    odia(Asesino, tiaAgatha),
    not(esMasRicoQue(tiaAgatha, Asesino)).

/*  asesinoAgatha(Asesino).
    Asesino = tiaAgatha ;
    false. 
*/

% Punto 2

/*  odia(Persona, milhouse).
    false. 

    odia(charles, Persona).
    Persona = mayordomo ;
    false.

    odia(Persona, tiaAgatha).
    Persona = tiaAgatha ;
    Persona = mayordomo ;
    false.

    odia(Odiador, Odiado).
    Odiador = Odiado, Odiado = tiaAgatha ; (tiaAgatha se odia a si misma)
    Odiador = tiaAgatha,
    Odiado = charles ;
    Odiador = mayordomo,
    Odiado = tiaAgatha ;
    Odiador = mayordomo,
    Odiado = charles ;
    Odiador = charles,
    Odiado = mayordomo ;
    false.

    odia(mayordomo, Alguien).
    Alguien = tiaAgatha ;
    Alguien = charles.
*/