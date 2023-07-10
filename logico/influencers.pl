% Punto 1

tiene(ana, youtube, 3000000).
tiene(ana, instagram, 2700000).
tiene(ana, tiktok, 1000000).
tiene(ana, twitch, 2).
tiene(beto, twitch, 120000).
tiene(beto, youtube, 6000000).
tiene(beto, instagram, 1100000).
tiene(cami, tiktok, 2000).
tiene(dani, youtube, 1000000).
tiene(evelyn, instagram, 1).

% Punto 2a

influencer(Usuario):-
    tiene(Usuario, _, _),
    findall(Seguidores, tiene(Usuario, _, Seguidores), ListaSeguidores),
    sum_list(ListaSeguidores, SeguidoresTotales),
    SeguidoresTotales > 10000.

% Punto 2b

omnipresente(Usuario):-
    influencer(Usuario),
    forall(tiene(_, Red, _), tiene(Usuario, Red, _)).

% Punto 2c

exclusivo(Usuario):-
    influencer(Usuario),
    not(estaEnDosRedes(Usuario)).

estaEnDosRedes(Usuario):-
    tiene(Usuario, Red, _),
    tiene(Usuario, OtraRed, _),
    Red \= OtraRed.

% Punto 3a

publicacion(ana, tiktok, video([beto, evelyn], 1)).
publicacion(ana, tiktok, video([ana], 1)).
publicacion(ana, instagram, foto([ana])).
publicacion(beto, instagram, foto([])).
publicacion(cami, twitch, stream(leagueOfLegends)).
publicacion(cami, youtube, video([cami], 5)).
publicacion(evelyn, instagram, foto([evelyn, cami])).

% Punto 3b

tematicaJuego(leagueOfLegends).
tematicaJuego(minecraft).
tematicaJuego(aoe).

% Punto 4

adictiva(Red):-
    red(Red),
    forall(publicacion(_, Red, Contenido), contenidoAdictivo(Contenido)).

red(Red):-
    tiene(_, Red, _).

contenidoAdictivo(video(_, Min)):-
    Min < 3.

contenidoAdictivo(stream(Tematica)):-
    tematicaJuego(Tematica).

contenidoAdictivo(foto(Participantes)):-
    length(Participantes, CantParticipantes),
    CantParticipantes < 4.

% Punto 5

colaboran(Usuario1, Usuario2):-
    publicoContenidoCon(Usuario2, Usuario1).
colaboran(Usuario1, Usuario2):-
    publicoContenidoCon(Usuario1, Usuario2).

publicoContenidoCon(Participante, Usuario):-
    publicacion(Usuario, _, video(Participantes, _)),
    member(Participante, Participantes).

publicoContenidoCon(Participante, Usuario):-
    publicacion(Usuario, _, foto(Participantes)),
    member(Participante, Participantes).

publicoContenidoCon(Participante, Usuario):-
    publicacion(Usuario, _, stream(_)),
    Participante = Usuario.