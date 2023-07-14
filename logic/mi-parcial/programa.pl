% Cancion, Compositores,  Reproducciones
cancion(bailanSinCesar, [pabloIlabaca, rodrigoSalinas], 10600177).
cancion(yoOpino, [alvaroDiaz, carlosEspinoza, rodrigoSalinas], 5209110).
cancion(equilibrioEspiritual, [danielCastro, alvaroDiaz, pabloIlabaca, pedroPeirano, rodrigoSalinas], 12052254).
cancion(tangananicaTanganana, [danielCastro, pabloIlabaca, pedroPeirano], 5516191).
cancion(dienteBlanco, [danielCastro, pabloIlabaca, pedroPeirano], 5872927).
cancion(meCortaronMalElPelo, [danielCastro, alvaroDiaz, pabloIlabaca, rodrigoSalinas], 3428854).

% Mes, Puesto, Cancion
rankingTop3(febrero, 1, lala).
rankingTop3(febrero, 2, tangananicaTanganana).
rankingTop3(febrero, 3, meCortaronMalElPelo).
rankingTop3(marzo, 1, meCortaronMalElPelo).
rankingTop3(marzo, 2, tangananicaTanganana).
rankingTop3(marzo, 3, lala).
rankingTop3(abril, 1, tangananicaTanganana).
rankingTop3(abril, 2, dienteBlanco).
rankingTop3(abril, 3, equilibrioEspiritual).
rankingTop3(mayo, 1, meCortaronMalElPelo).
rankingTop3(mayo, 2, dienteBlanco).
rankingTop3(mayo, 3, equilibrioEspiritual).
rankingTop3(mayo, 2, tangananicaTanganana). %Agregue este para verificar que esHit funcione bien.
rankingTop3(junio, 1, dienteBlanco).
rankingTop3(junio, 2, tangananicaTanganana).
rankingTop3(junio, 3, lala).

%%%%%%% INSERTE SOLUCIÓN AQUI %%%%%%%

% ¡Éxitos! :)

% Punto 1

esHit(Cancion):-
    rankingTop3(_, _, Cancion),
    forall(mesRanking(Mes), apareceEnRanking(Cancion, Mes)).

mesRanking(Mes):-
    rankingTop3(Mes, _, _).

% Punto 2

noEsReconocidaPorCriticos(Cancion):-
    tieneMuchasReproducciones(Cancion),
    not(apareceEnRanking(Cancion, _)).

tieneMuchasReproducciones(Cancion):-
    cancion(Cancion, _, Reproducciones),
    Reproducciones > 7000000.

apareceEnRanking(Cancion, Mes):-
    rankingTop3(Mes, _, Cancion).

% Punto 3

colaboradores(Compositor1, Compositor2):-
    cancion(_, Compositores, _),
    member(Compositor1, Compositores),
    member(Compositor2, Compositores),
    Compositor1 \= Compositor2.

% TRABAJOS

% Punto 4

%trabajo(nombre, conductor(aniosExperiencia))
%trabajo(nombre, periodista(aniosExperiencia, titulo))
%trabajo(nombre, reportero(aniosExperiencia, notasRealizadas))

trabajo(tulio, conductor(5)).
trabajo(bodoque, periodista(2, licenciatura)).
trabajo(bodoque, reportero(5, 300)).
trabajo(marioHugo, periodista(10, posgrado)).
trabajo(juanin, conductor(0)).
trabajo(santi, ingeniero(3, 6)). % trabajo del punto 6, ingeniero(aniosExperiencia, aniosCarrera), donde aniosCarrera es 
                                 % la cantidad de anios que le llevo terminarla.

% Punto 5

sueldoTotal(Persona, SueldoTotal):-
    trabajo(Persona, _),
    findall(Sueldo, sueldo(Persona, Sueldo), Sueldos),
    sumlist(Sueldos, SueldoTotal).

sueldo(Persona, Sueldo):-
    trabajo(Persona, Trabajo),
    sueldoTrabajo(Trabajo, Sueldo).

sueldoTrabajo(conductor(AniosExperiencia), Sueldo):-
    Sueldo is 10000 * AniosExperiencia.

sueldoTrabajo(reportero(AniosExperiencia, NotasRealizadas), Sueldo):-
    Sueldo is (10000 * AniosExperiencia) + (100 * NotasRealizadas).

sueldoTrabajo(periodista(AniosExperiencia, Titulo), Sueldo):-
    SueldoParcial is 5000 * AniosExperiencia,
    porcentaje(Titulo, Porcentaje),
    aumento(SueldoParcial, Porcentaje, Sueldo).

sueldoTrabajo(ingeniero(AniosExperiencia, AniosCarrera), Sueldo):- % Agregado para el punto 6
    Sueldo is 100000 * AniosExperiencia / AniosCarrera.

porcentaje(licenciatura, 20 / 100).
porcentaje(posgrado, 35 / 100).

aumento(Sueldo, Porcentaje, SueldoFinal):-
    SueldoFinal is Sueldo + (Sueldo * Porcentaje).

% Punto 6

/* El concepto que se relaciona con esto es el de polimorfismo, que gracias a su utilizacion, en este caso, los predicados pueden
consultar genericamente los sueldos de los trabajos, en vez de tener que consultar por cada trabajo en especifico. */