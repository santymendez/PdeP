atiende(dodain, lunes, 9, 15).
atiende(dodain, miercoles, 9, 15).
atiende(dodain, viernes, 9, 15).
atiende(lucas, martes, 10, 20).
atiende(juanC, sabado, 18, 22).
atiende(juanC, domingo, 18, 22).
atiende(juanFdS, jueves, 10, 20).
atiende(leoC, lunes, 14, 18).
atiende(leoC, miercoles, 14, 18).
atiende(martu, miercoles, 23, 24).

% Punto 1

atiende(vale, Dia, HorarioInicio, HorarioFinal):-
    atiende(dodain, Dia, HorarioInicio, HorarioFinal).
atiende(vale, Dia, HorarioInicio, HorarioFinal):-
    atiende(juanC, Dia, HorarioInicio, HorarioFinal).

% Punto 2

quienAtiende(Persona, Dia, Horario):-
    atiende(Persona, Dia, HorarioInicio, HorarioFinal),
    between(HorarioInicio, HorarioFinal, Horario).
    

% Punto 3

atiendeSolo(Persona, Dia, Horario):-
    quienAtiende(Persona, Dia, Horario),
    not((quienAtiende(Otro, Dia, Horario), Otro \= Persona)).

% Punto 4

puedenAtenderJuntos(Personas, Dia):-
    findall(Persona, quienAtiende(Persona, Dia, _), ListaPersonas),
    list_to_set(ListaPersonas, PersonasPosibles),
    combinar(PersonasPosibles, Personas).

combinar([], []).
combinar([Persona|PersonasPosibles], [Persona|Personas]):-
    combinar(PersonasPosibles, Personas).
combinar([_|PersonasPosibles], Personas):-
    combinar(PersonasPosibles, Personas).

% Punto 5

venta(dodain, (lunes, 10, 8), golosinas(1200)).
venta(dodain, (lunes, 10, 8), cigarrillos([jockey])).
venta(dodain, (lunes, 10, 8), golosinas(50)).
venta(dodain, (miercoles, 12, 8), bebidas(8, 1)).
venta(dodain, (miercoles, 12, 8), golosinas(10)).
venta(martu, (miercoles, 12, 8), golosinas(1000)).
venta(martu, (miercoles, 12, 8), cigarrillos([chesterfield, colorado, parisiennes])).
venta(lucas, (martes, 11, 8), golosinas(600)).
venta(lucas, (martes, 18, 8), bebidas(0, 2)).
venta(lucas, (martes, 18, 8), cigarrillos([derby])).

esSuertuda(Persona):-
    venta(Persona, _, _),
    forall(venta(Persona, Dia, _), primeraVentaImportante(Persona, Dia)).

primeraVentaImportante(Persona, Dia):-
    findall(Venta, venta(Persona, Dia, Venta), Ventas),
    nth0(0, Ventas, PrimerVenta),
    esImportante(PrimerVenta).

esImportante(golosinas(Precio)):-
    Precio > 100.
esImportante(cigarrillos(Marcas)):-
    length(Marcas, Cant),
    Cant > 2.
esImportante(bebidas(_, 0)).
esImportante(bebidas(Alcoholicas, NoAlcoholicas)):-
    Total is Alcoholicas + NoAlcoholicas,
    Total > 5.