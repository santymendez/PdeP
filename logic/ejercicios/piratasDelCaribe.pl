%puerto(Puerto,Pais)
puerto(colon,panama).
puerto(georgetown,islasCaiman).
puerto(nicholls,bahamas).
puerto(habana,cuba).
puerto(cartagena,colombia).

%ruta(Puerto,OtroPuerto,Distancia)
ruta(colon,georgetown,70).
ruta(habana,colon,40).
ruta(nicholls,habana,30).
ruta(cartagena,nicholls,500).
ruta(cartagena,georgetown,200).

%viaje(Puerto,OtroPuerto,Botin,Embarcacion)
viaje(colon,nicholls,3000,galeon(4)).
viaje(colon,georgetown,5000,carabela(500,30)).
viaje(colon,georgetown,10000,galera(brasil)).
viaje(cartagena,georgetown,1000,galera(argentina)).
viaje(nicholls,cartagena,2000,galeon(6)).

%barcoPirata(CapitanPirata,NombreBarco,CantPiratas,Impetu)
barcoPirata(jackSparrow, perlaNegra,40,100).
barcoPirata(davyJones, holandesErrante,100,200).
barcoPirata(hectorBarbosa, venganzaDeLaReinaAna, 9, 0).
barcoPirata(willTurner, aladoCelestial, 130, 500).

% Punto 1

puedeAbordarEmbarcacion(Pirata, Embarcacion):-
    poderio(Pirata, Poderio),
    resistenciaEmbarcacion(Embarcacion, Resistencia),
    Poderio > Resistencia.

poderio(Pirata, Poderio):-
    barcoPirata(Pirata, _, CantPiratas, ImpetuCombativo),
    Poderio is (CantPiratas + 2) * ImpetuCombativo.

resistenciaEmbarcacion(Embarcacion, Resistencia):-
    viaje(Puerto, Destino, Mercancia, Embarcacion),
    ruta(Puerto, Destino, Distancia),
    resistencia(Embarcacion, Distancia, Mercancia, Resistencia).

resistencia(galeon(Caniones), Distancia, _, Resistencia):-
    Resistencia is Caniones * 100 / Distancia.

resistencia(carabela(_, Soldados), _, Mercancia, Resistencia):-
    Resistencia is Mercancia / 10 + Soldados.

resistencia(galera(espaniol), Distancia, _, Resistencia):-
    Resistencia is 100 / Distancia.

resistencia(galera(Nacionalidad), _, Mercancia, Resistencia):-
    Nacionalidad \= espaniol,
    Resistencia is Mercancia * 10.

% Punto 2

botinTotal(Capitan, Puerto, BotinTotal):-
    puerto(Puerto, _),
    barcoPirata(Capitan, _, _, _),
    findall(Botin, botinRobado(Capitan, Puerto, Botin), BotinRobado),
    sumlist(BotinRobado, BotinTotal).

botinRobado(Capitan, Puerto, Botin):-
    puedeAbordarEmbarcacion(Capitan, Embarcacion),
    saleOLlega(Embarcacion, Puerto, Botin).

saleOLlega(Embarcacion, Puerto, Botin):-
    viaje(Puerto, _, Botin, Embarcacion).
saleOLlega(Embarcacion, Puerto, Botin):-
    viaje(_, Puerto, Botin, Embarcacion).

% Punto 3

caracteristica(Capitan, decadente):-
    barcoPirata(Capitan, _, Tripulantes, _),
    Tripulantes < 10,
    not(puedeAbordarEmbarcacion(Capitan, _)).

caracteristica(Capitan, excentrico):-
    barcoPirata(Capitan, perlaNegra, _, _).

caracteristica(Capitan, terrorDelPuerto):-
    puedeAbordarATodosEn(Puerto, Capitan),
    not(hayOtroQuePuedeAbordarATodosEn(Puerto)).

hayOtroQuePuedeAbordarATodosEn(Puerto):-
    puedeAbordarATodosEn(Puerto, Capitan),
    puedeAbordarATodosEn(Puerto, Otro),
    Capitan \= Otro.

puedeAbordarATodosEn(Puerto, Capitan):-
    viaje(_, _, _, Embarcacion),
    forall(saleOLlega(Embarcacion, Puerto, _), puedeAbordarEmbarcacion(Capitan, Embarcacion)).

% Punto 4

puedeIr(Capitan, Puerto1, Puerto2):-
    puedeHacerRuta(Capitan, Puerto1, Puerto2).
puedeIr(Capitan, Puerto1, Puerto2):-
    puedeHacerRuta(Capitan, Puerto1, PuertoIntermedio),
    puedeIr(Capitan, PuertoIntermedio, Puerto2).

puedeHacerRuta(Capitan, Puerto1, Puerto2):-
    ruta(Puerto1, Puerto2, Distancia),
    poderio(Capitan, Poderio),
    Poderio > Distancia.