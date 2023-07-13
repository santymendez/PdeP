
% De cada restaurante, en caso que se le hayan otorgado estrellas en la guía, se conoce cuántas son y en qué barrio se ubica:
restaurante(panchoMayo, 2, barracas).
restaurante(finoli, 3, villaCrespo).
restaurante(superFinoli, 5, villaCrespo).

/* De los restaurantes se sabe qué ofrecen de menú, que pueden tener platos a la carta o por pasos. 
En el menú a la carta se indica el precio y una descripción del plato.
El menú por pasos, diseñado por un chef en conjunto con un sommelier de vino, consta de un número determinado de "pasos", un precio, 
una lista de vinos y una cantidad estimada de comensales que comparte el menú.  */

menu(panchoMayo, carta(1000, pancho)).
menu(panchoMayo, carta(200, hamburguesa)).
menu(finoli, carta(2000, hamburguesa)).
menu(finoli, pasos(15, 15000, [chateauMessi, francescoliSangiovese, susanaBalboaMalbec], 6)).
menu(noTanFinoli, pasos(2, 3000, [guinoPin, juanaDama],3)).

% Y luego, de cada vino se conoce su país de origen y su costo por botella
vino(chateauMessi, francia, 5000).
vino(francescoliSangiovese, italia, 1000).
vino(susanaBalboaMalbec, argentina, 1200).
vino(christineLagardeCabernet, argentina, 5200).
vino(guinoPin, argentina, 500).
vino(juanaDama, argentina, 1000).

/* Se pide saber:
Cuáles son los restaurantes de más de N estrellas por barrio.
Por ejemplo:
¿Cuáles son los restaurantes de mas de 2 estrellas en villa crespo? 
finoli y superFinoli */

restoConMasDe(NEstrellas, Barrio, Restaurante):-
    restaurante(Restaurante, Estrellas, Barrio),
    Estrellas > NEstrellas.
    
/* Cuáles son los restaurantes sin estrellas.
Por ejemplo:
¿Cuáles son los restaurantes sin estrellas? 
noTanFinoli */

restoSinEstrella(Restaurante):-
    tieneMenu(Restaurante),
    not(tieneEstrellas(Restaurante)).

tieneMenu(Restaurante):-
    menu(Restaurante, _).

tieneEstrellas(Restaurante):-
    restaurante(Restaurante, Estrellas, _),
    Estrellas > 0.

/* Si un restaurante está mal organizado, que es cuando tiene algún menú que tiene más pasos que la cantidad de vinos disponibles 
o cuando tiene en su menú a la carta dos veces una misma comida con diferente precio.
Por ejemplo:
¿Está mal organizado finoli? 
Si
¿Está mal organizado panchoMayo?
No */

malOrganizado(Restaurante):-
    menu(Restaurante, pasos(Pasos, _, Vinos, _)),
    length(Vinos, CantVinos),
    Pasos > CantVinos.

malOrganizado(Restaurante):-
    menu(Restaurante, carta(Precio1, Comida)),
    menu(Restaurante, carta(Precio2, Comida)),
    Precio1 \= Precio2.

/* Qué restaurante es copia barata de qué otro restaurante, lo que sucede cuando el primero tiene todos los platos a la carta que ofrece el otro restaurante, 
pero a un precio menor. Además, no puede tener más estrellas que el otro. 
Por ejemplo:
¿Existe algún restaurante que sea copia barata de otro?
Si, panchoMayo de finoli
¿Existe algún restaurante que sea copia barata de panchoMayo?
No */

copiaBarata(Copia, Restaurante):-
    tieneTodos(Copia, Restaurante),
    masBaratos(Copia, Restaurante).

tieneTodos(Copia, Restaurante):-
    tieneCarta(Copia),
    tieneCarta(Restaurante),
    Restaurante \= Copia,
    forall(menu(Restaurante, carta(_, Plato)), menu(Copia, carta(_, Plato))).

tieneCarta(Restaurante):-
    menu(Restaurante, carta(_, _)).

masBaratos(Copia, Restaurante):-
    menu(Restaurante, carta(Precio, Plato)),
    menu(Copia, carta(PrecioCopia, Plato)),
    PrecioCopia < Precio.

/* Cuál es el precio promedio de los menúes de cada restaurante, por persona. 
En los platos, se considera el precio indicado ya que se asume que es para una persona.
En los menú por pasos, el precio es el indicado más la suma de los precios de todos los vinos incluidos, pero dividido en la cantidad de comensales. 
Los vinos importados pagan una tasa aduanera del 35% por sobre su precio publicado. */

precioPromedio(Restaurante, PrecioPromedio):-
    menu(Restaurante, _),
    findall(Precio, precioMenu(Restaurante, Precio), Precios),
    length(Precios, CantMenu),
    sumlist(Precios, SumaPrecios),
    PrecioPromedio is SumaPrecios / CantMenu.

precioMenu(Restaurante, Precio):-
    menu(Restaurante, carta(Precio, _)).

precioMenu(Restaurante, Precio):-
    menu(Restaurante, pasos(_, PrecioIndicado, Vinos, Comensales)),
    findall(PrecioVino, (member(Vino, Vinos), precioVino(Vino, PrecioVino)), PrecioVinos),
    sumlist(PrecioVinos, PrecioTot),
    %precioVinos(Vinos, PrecioVinos),
    Precio is (PrecioIndicado + PrecioTot) / Comensales.

precioVino(Vino, Precio):-
    vino(Vino, argentina, Precio).

precioVino(Vino, Precio):-
    vino(Vino, Origen, PrecioVino),
    Origen \= argentina,
    Precio is PrecioVino + (PrecioVino * 35 / 100).

/* Por ejemplo:
¿Cuáles son los precios promedio de los restaurantes?
De panchoMayo, 600$ -> (1000 + 200) / 2
De finoli, 3025$            -> (2000 + (15000 + (5000 * 1.35 + 1000 * 1.35  + 1200))/6) / 2
De noTanFinoli, 1500$ -> (3000 + (500 + 1000)) / 3  */


/* Inventar un nuevo tipo de menú diferente a los anteriores, con su correspondiente forma de calcular el precio. 
¿Qué podría hacerse en relación a los restaurantes mal organizados o copias baratas? Justificar. 
 */