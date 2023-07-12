ganador(1997,peterhansel,moto(1995, 1)).
ganador(1998,peterhansel,moto(1998, 1)).
ganador(2010,sainz,auto(touareg)).
ganador(2010,depress,moto(2009, 2)).
ganador(2010,karibov,camion([vodka, mate])).
ganador(2010,patronelli,cuatri(yamaha)).
ganador(2011,principeCatar,auto(touareg)).
ganador(2011,coma,moto(2011, 2)).
ganador(2011,chagin,camion([repuestos, mate])).
ganador(2011,patronelli,cuatri(yamaha)).
ganador(2012,peterhansel,auto(countryman)).
ganador(2012,depress,moto(2011, 2)).
ganador(2012,deRooy,camion([vodka, bebidas])).
ganador(2012,patronelli,cuatri(yamaha)).
ganador(2013,peterhansel,auto(countryman)).
ganador(2013,depress,moto(2011, 2)).
ganador(2013,nikolaev,camion([vodka, bebidas])).
ganador(2013,patronelli,cuatri(yamaha)).
ganador(2014,coma,auto(countryman)).
ganador(2014,coma,moto(2013, 3)).
ganador(2014,karibov,camion([tanqueExtra])).
ganador(2014,casale,cuatri(yamaha)).
ganador(2015,principeCatar,auto(countryman)).
ganador(2015,coma,moto(2013, 2)).
ganador(2015,mardeev,camion([])).
ganador(2015,sonic,cuatri(yamaha)).
ganador(2016,peterhansel,auto(2008)).
ganador(2016,prince,moto(2016, 2)).
ganador(2016,deRooy,camion([vodka, mascota])).
ganador(2016,patronelli,cuatri(yamaha)).
ganador(2017,peterhansel,auto(3008)).
ganador(2017,sunderland,moto(2016, 4)).
ganador(2017,nikolaev,camion([ruedaExtra])).
ganador(2017,karyakin,cuatri(yamaha)).
ganador(2018,sainz,auto(3008)).
ganador(2018,walkner,moto(2018, 3)).
ganador(2018,nicolaev,camion([vodka, cama])).
ganador(2018,casale,cuatri(yamaha)).
ganador(2019,principeCatar,auto(hilux)).
ganador(2019,prince,moto(2018, 2)).
ganador(2019,nikolaev,camion([cama, mascota])).
ganador(2019,cavigliasso,cuatri(yamaha)).

pais(peterhansel,francia).
pais(sainz,espania).
pais(depress,francia).
pais(karibov,rusia).
pais(patronelli,argentina).
pais(principeCatar,catar).
pais(coma,espania).
pais(chagin,rusia).
pais(deRooy,holanda).
pais(nikolaev,rusia).
pais(casale,chile).
pais(mardeev,rusia).
pais(sonic,polonia).
pais(prince,australia).
pais(sunderland,reinoUnido).
pais(karyakin,rusia).
pais(walkner,austria).
pais(cavigliasso,argentina).

% Punto 1

marca(auto(2008), peugeot).
marca(auto(3008), peugeot).
marca(auto(countryman), mini).
marca(auto(touareg), volkswagen).
marca(auto(hilux), toyota).

marca(moto(Anio, _), ktm):-
    esMotoActual(moto(Anio, _)).

marca(moto(Anio, _), yamaha):-
    not(esMotoActual(moto(Anio, _))).

marca(camion(Items), kamaz):-
    tiene(vodka, camion(Items)).

marca(camion(Items), iveco):-
    not(tiene(vodka, camion(Items))).

marca(cuatri(Marca), Marca).

tiene(Item, camion(Items)):-
    member(Item, Items).

esMotoActual(moto(AnioDeFabricacion, _)):-
    AnioDeFabricacion >= 2000.

% Punto 2

ganadorReincidente(Conductor):-
    ganoEn(Anio1, Conductor),
    ganoEn(Anio2, Conductor),
    Anio1 \= Anio2.

ganoEn(Anio, Conductor):-
    ganador(Anio, Conductor, _).

% Punto 3

inspiraA(Conductor, Ganador):-
    ganador(_, Ganador, _),
    not(ganador(_, Conductor, _)),
    sonDelMismoPais(Conductor, Ganador).

inspiraA(Conductor, Ganador):-
    ganoEn(Anio1, Conductor),
    ganoEn(Anio2, Conductor),
    Anio2 < Anio1,
    sonDelMismoPais(Conductor, Ganador).

sonDelMismoPais(Conductor, OtroConductor):-
    pais(Conductor, Pais),
    pais(OtroConductor, Pais).

% Punto 4

marcaDeLaFortuna(Conductor, Marca):-
    ganoEn(_, Conductor),
    usoMarca(Conductor, Marca),
    forall(ganador(_, Conductor, Vehiculo), marca(Vehiculo, Marca)).

usoMarca(Conductor, Marca):-
    ganador(_, Conductor, Vehiculo),
    marca(Vehiculo, Marca).

% Punto 5

heroePopular(Conductor):-
    inspiraA(_, Conductor),
    unicoSinVehiculoCaro(Conductor).

unicoSinVehiculoCaro(Conductor):-
    ganador(Anio, Conductor, _),
    not(usoVehiculoCaro(Conductor, Anio)),
    forall(ganadorDiferente(Anio, Conductor, OtroConductor), usoVehiculoCaro(OtroConductor, Anio)).

ganadorDiferente(Anio, Conductor, OtroConductor):-
    ganoEn(Anio, Conductor),
    ganoEn(Anio, OtroConductor),
    OtroConductor \= Conductor.

usoVehiculoCaro(Conductor, Anio):-
    ganador(Anio, Conductor, Vehiculo),
    esCaro(Vehiculo).

esCaro(Vehiculo):-
    marca(Vehiculo, Marca),
    esMarcaCara(Marca).

esCaro(Vehiculo):-
    suspensionesExtra(Vehiculo, Susp),
    Susp >= 3.

esMarcaCara(mini).
esMarcaCara(toyota).
esMarcaCara(iveco).

suspensionesExtra(moto(_, Susp), Susp).
suspensionesExtra(cuatri(_), 4).

% Punto 6

etapa(marDelPlata,santaRosa,60).
etapa(santaRosa,sanRafael,290).
etapa(sanRafael,sanJuan,208).
etapa(sanJuan,chilecito,326).
etapa(chilecito,fiambala,177).
etapa(fiambala,copiapo,274).
etapa(copiapo,antofagasta,477).
etapa(antofagasta,iquique,557).
etapa(iquique,arica,377).
etapa(arica,arequipa,478).
etapa(arequipa,nazca,246).
etapa(nazca,pisco,276).
etapa(pisco,lima,29).

% a

distancia(Locacion1, Locacion2, Dist):-
    etapa(Locacion1, Locacion2, Dist).

distancia(Locacion1, Locacion2, Dist):-
    etapa(Locacion1, LocacionIntermedia, DistIntermedia),
    distancia(LocacionIntermedia, Locacion2, DistFinal),
    Dist is DistFinal + DistIntermedia.

% b

puedeRecorrerSinParar(Distancia, Vehiculo):-
    limiteDistancia(Limite, Vehiculo),
    Distancia =< Limite.

limiteDistancia(2000, Vehiculo):-
    esCaro(Vehiculo).

limiteDistancia(1800, Vehiculo):-
    esVehiculo(Vehiculo),
    not(esCaro(Vehiculo)).

limiteDistancia(Limite, camion(Items)):-
    length(Items, Cant),
    Limite is Cant * 1000.

esVehiculo(Vehiculo):-
    marca(Vehiculo, _).

% c

destinoMasLejano(Origen, Vehiculo, Destino):-
    puedeLlegarSinParar(Origen, Destino, Vehiculo),
    forall(destinoPosible(Vehiculo, Origen, Destino, AlgunDestino), estaMasCerca(AlgunDestino, Destino, Origen)).

puedeLlegarSinParar(Origen, Destino, Vehiculo):-
    distancia(Origen, Destino, Distancia),
    puedeRecorrerSinParar(Distancia, Vehiculo).

destinoPosible(Vehiculo, Origen, Destino, AlgunDestino):-
    distancia(Origen, AlgunDestino, Distancia),
    puedeRecorrerSinParar(Distancia, Vehiculo),
    AlgunDestino \= Destino.

estaMasCerca(DestinoCercano, Destino, Origen):-
    distancia(Origen, Destino, Distancia1),
    distancia(DestinoCercano, Destino, Distancia2),
    Distancia2 =< Distancia1.