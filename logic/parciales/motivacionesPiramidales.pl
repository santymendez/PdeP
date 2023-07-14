% Punto 1

necesidad(respiracion, fisiologico).
necesidad(alimentacion, fisiologico).
necesidad(descanso, fisiologico).
necesidad(reproduccion, fisiologico).

necesidad(integridadFisica, seguridad).
necesidad(empleo, seguridad).
necesidad(salud, seguridad).

necesidad(amistad, social).
necesidad(afecto, social).
necesidad(intimidad, social).

necesidad(confianza, reconocimiento).
necesidad(respeto, reconocimiento).
necesidad(exito, reconocimiento).

necesidad(libertad, autorrealizacion).

nivelSuperior(autorrealizacion, reconocimiento).
nivelSuperior(reconocimiento, social).
nivelSuperior(social, seguridad).
nivelSuperior(seguridad, fisiologico).

% Punto 2

separacionNecesidades(Necesidad1, Necesidad2, Separacion):-
    necesidad(Necesidad1, NivelA),
    necesidad(Necesidad2, NivelB),
    separacionNiveles(NivelA, NivelB, Separacion).

separacionNiveles(Nivel, Nivel, 0).
separacionNiveles(NivelA, NivelB, Separacion):-
    nivelSuperior(NivelA, NivelIntermedio),
    separacionNiveles(NivelIntermedio, NivelB, SepIntermedia),
    Separacion is SepIntermedia + 1.

% Punto 3

necesita(carla, alimentacion).
necesita(carla, descanso).
necesita(carla, empleo).
necesita(juan, afecto).
necesita(juan, exito).
necesita(roberto, amistad).
necesita(manuel, libertad).
necesita(charly, afecto).

% Punto 4

necesidadMayorJerarquia(Persona, Necesidad):-
    necesita(Persona, Necesidad),
    forall(necesita(Persona, OtraNecesidad), not(mayorJerarquia(OtraNecesidad, Necesidad))).

mayorJerarquia(Necesidad, OtraNecesidad):-
    separacionNecesidades(Necesidad, OtraNecesidad, Separacion),
    Separacion > 0.

% Punto 5

satisfaceNivel(Persona, Nivel):-
    necesidad(_, Nivel),
    forall(necesidad(Necesidad, Nivel), not(necesita(Persona, Necesidad))).

% Punto 6a

satisfaceTeoria(Persona):-
    necesita(Persona, OtraNecesidad),
    forall(necesita(Persona, Necesidad), mismoNivel(Necesidad, OtraNecesidad)).

mismoNivel(Necesidad, OtraNecesidad):-
    separacionNecesidades(Necesidad, OtraNecesidad, 0).

% Punto 6b

todosCumplenTeoria:-
    forall(persona(Persona), satisfaceTeoria(Persona)).

persona(Persona):-
    necesita(Persona, _).

% Punto 6c

laMayoriaCumpleTeoria:-
    cumplenTeoria(CantCumplidora),
    noCumplenTeoria(CantIncumplidora),
    CantCumplidora > CantIncumplidora.

cumplenTeoria(Cant):-
    persona(Persona),
    findall(Persona, satisfaceTeoria(Persona), PersonasCumplidoras),
    length(PersonasCumplidoras, Cant).

noCumplenTeoria(Cant):-
    persona(Persona),
    findall(Persona, not(satisfaceTeoria(Persona)), PersonasIncumplidoras),
    length(PersonasIncumplidoras, Cant).