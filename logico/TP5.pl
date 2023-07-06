% Primera parte

elecciones(2019).
elecciones(2021).

% Un anio mas de elecciones

elecciones(2023).

estudiantes(sistemas, 2021, juli).
estudiantes(mecanica, 2021, agus).
estudiantes(sistemas, 2021, dani).
estudiantes(mecanica, 2019, agus).
estudiantes(sistemas, 2019, dani).
estudiantes(mecanica, 2021, tati).

% Mas estudiantes

estudiantes(sistemas, 2023, santi).
estudiantes(sistemas, 2023, vazko).
estudiantes(sistemas, 2023, jastre).
estudiantes(sistemas, 2023, marcos).
estudiantes(sistemas, 2023, manu).
estudiantes(sistemas, 2023, colo).
estudiantes(sistemas, 2023, dante).
estudiantes(sistemas, 2023, pepi).
estudiantes(mecanica, 2023, david).

votos(franjaNaranja, 50, sistemas, 2019).
votos(franjaNaranja, 20, mecanica, 2019).
votos(franjaNaranja, 100, sistemas, 2021).
votos(agosto29, 70, sistemas, 2021).

% Otra Agrupacion

votos(partidoInnovador, 3, sistemas, 2023).
votos(partidoInnovador, 1, mecanica, 2023).

% Punto 1

ganador(Anio, Partido):-
    elecciones(Anio),
    findall(Votos, votos(_, Votos, _, Anio), ListaVotos),
    max_member(MaxVotos, ListaVotos),
    votos(Partido, MaxVotos, _, Anio).

% Punto 2

siempreGanaElMismo(Partido):-
    ganador(_, Partido),
    forall(elecciones(Anio), ganador(Anio, Partido)).

% Punto 3  

cantEstudiantes(Anio, CantEstudiantes, Carrera):-
    elecciones(Anio),
    findall(Estudiante, estudiantes(Carrera, Anio, Estudiante), ListaEstudiantes),
    length(ListaEstudiantes, CantEstudiantes).

votosAnio(Anio, VotosTotales, Carrera):-
    elecciones(Anio),
    findall(Votos, votos(_, Votos, Carrera, Anio), ListaVotos),
    sumlist(ListaVotos, VotosTotales).  

huboFraude(Anio):-
    elecciones(Anio),
    cantEstudiantes(Anio, Estudiantes, Carrera),
    votosAnio(Anio, Votos, Carrera),
    forall(votos(_, _, Carrera, Anio), Estudiantes < Votos).

% Punto 4  

/* 
Basta con hacer:  
?- huboFraude(Anio).
Anio = 2017 ; 
Anio = 2019.
*/

% Punto 5

ganoPorAfano(Anio, Ganador, Carrera):-
    ganador(Anio, Ganador),
    segundo(Anio, Segundo),
    votos(Ganador, VotosGanador, Carrera, Anio),
    votos(Segundo, VotosSegundo, Carrera, Anio),
    VotosGanador - VotosSegundo >= 30.

segundo(Anio, Partido):-
    elecciones(Anio),
    findall(Votos, menosVotosQueElPrimero(_, Votos, Anio, Carrera), ListaVotos),
    max_member(MaxVotos, ListaVotos),
    votos(Partido, MaxVotos, Carrera, Anio).

menosVotosQueElPrimero(Partido, Votos, Anio, Carrera):-
    ganador(Anio, Ganador),
    votos(Ganador, VotosGanador, Carrera, Anio),
    votos(Partido, Votos, Carrera, Anio),
    Votos < VotosGanador.

% Segunda parte

realizoAccion(franjaNaranja, lucha(salarioDocente)).
realizoAccion(franjaNaranja, gestionIndividual("Excepcion de correlativas", tati, 2021)).
realizoAccion(franjaNaranja, obra(2021)).
realizoAccion(agosto29, lucha(salarioDocente)).
realizoAccion(agosto29, lucha(boletoEstudiantil)).
realizoAccion(partidoInnovador, actualizaBiblioteca(150)). % 150 es la cantidad de libros

% Punto 1

caracteristica(Partido, demagogica):-
    realizoAccion(Partido, _),
    forall(realizoAccion(Partido, Accion), esGestionIndividual(Accion)).

% Punto 2

caracteristica(Partido, burocrata):-
    realizoAccion(Partido, _),
    forall(realizoAccion(Partido, Accion), not(participoEnLucha(Accion))).

% Punto 3

caracteristica(Partido, transparente):-
    realizoAccion(Partido, _),
    forall(realizoAccion(Partido, Accion), esGenuina(Accion)).

esGenuina(obra(Anio)):-
    not(elecciones(Anio)).

esGenuina(gestionIndividual(_,Estudiante,Anio)):-
    estudiantes(_, Anio, Estudiante).

esGenuina(lucha(_)).

esGenuina(actualizaBiblioteca(Cant)):-
    Cant > 100.

esGestionIndividual(gestionIndividual(_, _, _)).

participoEnLucha(lucha(_)).

% Punto 4

cumpleMasDeUnaCaracteristica(Partido):-
    caracteristica(Partido, _),
    findall(Caracteristica, caracteristica(Partido, Caracteristica), ListaCar),
    list_to_set(ListaCar, Caracteristicas),
    length(Caracteristicas, CantCaracteristicas),
    CantCaracteristicas > 1.

% Tercera Parte

% Consultas que reflejan las variantes

/*
?- huboFraude(2023).
false.

?- caracteristica(partidoInnovador, transparente).
true.

?- cumpleMasDeUnaCaracteristica(partidoInnovador).
true ;
true.

*/

% Inversibilidad

/*
Un ejemplo de un predicado inversible seria el de esTransparente.

esTransparente(Partido):-
    realizoAccion(Partido, _),
    forall(realizoAccion(Partido, Accion), esGenuina(Accion)).

Nos importa que un predicado sea inversible, ya que eso nos permite realizar consultas tanto individuales como existenciales. 
Si tuvieramos un predicado no inversible, nos seria imposible realizar consultas del tipo existencial.

Ejemplos de consultas con predicado inversible (con el codigo del Tp):

?- esTransparente(agosto29).
true ;
true.

?- esTransparente(Partido).
Partido = agosto29 ;
Partido = agosto29.

En cambio, con una version no inversible del mismo predicado:

esTransparenteNoInversible(Partido):-
    forall(realizoAccion(Partido, Accion), esGenuina(Accion)).

?- esTransparenteNoInversible(agosto29).
true.

?- esTransparenteNoInversible(Partido). 
false.

Con estos ejemplos se puede observar la diferencia a la hora de realizar consultas existenciales.
*/


