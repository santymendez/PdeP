% disco(artista, nombreDelDisco, cantidad, año).
disco(floydRosa, elLadoBrillanteDeLaLuna, 1000000, 1973).
disco(tablasDeCanada, autopistaTransargentina, 500, 2006).
disco(rodrigoMalo, elCaballo, 5000000, 1999).
disco(rodrigoMalo, loPeorDelAmor, 50000000, 1996).
disco(rodrigoMalo, loMejorDe, 50000000, 2018).
disco(losOportunistasDelConurbano, ginobili, 5, 2018).
disco(losOportunistasDelConurbano, messiMessiMessi, 5, 2018).
disco(losOportunistasDelConurbano, marthaArgerich, 15, 2019).

%manager(artista, manager).
manager(floydRosa, normal(15)).
manager(tablasDeCanada, buenaOnda(cachito, canada)).
manager(rodrigoMalo, estafador).

% normal(porcentajeComision) 
% buenaOnda(nombre, lugar)
% estafador

% Punto 1

clasico(Artista):-
    disco(Artista, loMejorDe, _, _).
clasico(Artista):-
    disco(Artista, _, CopiasVendidas, _),
    CopiasVendidas > 1000000.

% Punto 2

totalVentas(Artista, TotalVentas):-
    disco(Artista, _, _, _),
    findall(Cantidad, disco(Artista, _, Cantidad, _), Ventas),
    sumlist(Ventas, TotalVentas).

% Punto 3

gananciaArtista(Artista, Ganancia):-
    disco(Artista, _, _, _),
    not(manager(Artista, _)),
    gananciaBruta(Artista, Ganancia).

gananciaArtista(Artista, Ganancia):-
    gananciaBruta(Artista, GananciaBruta),
    manager(Artista, Manager),
    comisionManager(Manager, Comision),
    descuento(GananciaBruta, Comision, Ganancia).

gananciaBruta(Artista, Ganancia):-
    totalVentas(Artista, Ventas),
    Ganancia is Ventas / 10.

comisionManager(normal(Comision), Comision).
comisionManager(buenaOnda(_, canada), 5).
comisionManager(buenaOnda(_, mexico), 15).
comisionManager(estafador, 100).

descuento(Bruto, Comision, Neto):-
    Neto is Bruto * (100 - Comision).

% Punto 4

namberUan(Artista, Anio):-
    autogestionado(Artista),
    disco(_, _, _, Anio),
    findall(Ventas, disco(_, _, Ventas, Anio), ListaVentas),
    max_member(MayorVenta, ListaVentas),
    disco(Artista, _, MayorVenta, Anio).

autogestionado(Artista):-
    disco(Artista, _, _, _),
    not(manager(Artista, _)).