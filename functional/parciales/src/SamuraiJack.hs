module SamuraiJack where
import PdePreludat

data Elemento = UnElemento {
    tipo :: String,
    ataque :: (Personaje -> Personaje),
    defensa :: (Personaje -> Personaje)
} deriving (Show, Eq)

data Personaje = UnPersonaje {
    nombre :: String,
    salud :: Number,
    elementos :: [Elemento],
    anioPresente :: Number
} deriving (Show, Eq)

noHaceNada = id

mandarAlAnio :: Number -> Personaje -> Personaje
mandarAlAnio anio personaje = personaje {anioPresente = anio}

meditar :: Personaje -> Personaje
meditar personaje = personaje {salud = salud personaje + salud personaje / 2}

causarDanio :: Number -> Personaje -> Personaje
causarDanio cant personaje = personaje {salud = salud personaje - cant}

tipoElementos :: Personaje -> [String]
tipoElementos personaje = map tipo (elementos personaje)

esMalvado :: Personaje -> Bool
esMalvado = elem "Maldad" . tipoElementos

usarAtaque :: Elemento -> Personaje -> Personaje
usarAtaque elemento = ataque elemento

danioQueProduce :: Personaje -> Elemento -> Number
danioQueProduce personaje elemento = salud personaje - salud (usarAtaque elemento personaje)

personajeMuerto :: Personaje -> Bool
personajeMuerto = (==0) . salud

hayElementoAsesino :: Personaje -> [Elemento] -> Bool
hayElementoAsesino personaje (x:xs) 
    | personajeMuerto (usarAtaque x personaje) = True
    | otherwise = hayElementoAsesino personaje xs

hayEnemigoAsesino :: Personaje -> Personaje -> Bool
hayEnemigoAsesino personaje enemigo = hayElementoAsesino personaje (elementos enemigo)

enemigosMortales :: Personaje -> [Personaje] -> [Personaje]
enemigosMortales personaje = filter (hayEnemigoAsesino personaje) 

aplicarMeditar :: Number -> Personaje -> Personaje
aplicarMeditar cant = aplicarMeditar (cant - 1) . meditar

concentracion :: Number -> Elemento
concentracion cant = UnElemento {tipo = "Magia", ataque = noHaceNada, defensa = aplicarMeditar cant}


esbirro :: Elemento
esbirro = UnElemento {tipo = "Maldad", ataque = causarDanio 1, defensa = noHaceNada}

esbirrosMalvados :: Number -> [Elemento]
esbirrosMalvados cant = replicate cant esbirro

katanaMagica :: Elemento
katanaMagica = UnElemento {tipo = "Magia", ataque = causarDanio 1000, defensa = noHaceNada}

jack :: Personaje
jack = UnPersonaje {nombre = "Jack", salud = 300, elementos = [concentracion 3, katanaMagica], anioPresente = 200}

portalFuturo :: Number -> Elemento
portalFuturo anio = UnElemento {tipo = "Magia", ataque = mandarAlAnio (2800 + anio), defensa = aku (2800 + anio) . salud}

aku :: Number -> Number -> Personaje
aku anio cantSalud = UnPersonaje {nombre = "Aku", salud = cantSalud, elementos = esbirrosMalvados (100 * anio) ++ [concentracion 4, portalFuturo anio], anioPresente = anio}

ataques :: [Elemento] -> [Personaje -> Personaje]
ataques = map ataque 

defensas :: [Elemento] -> [Personaje -> Personaje]
defensas = map defensa

defender :: Personaje -> [Elemento] -> Personaje 
defender defensor listaElementos = foldr ($) defensor (ataques listaElementos)

atacar :: Personaje -> [Elemento] -> Personaje
atacar atacante listaElementos = foldr ($) atacante (defensas listaElementos)

proximoAtacante :: Personaje -> Personaje -> Personaje
proximoAtacante atacante defensor = defender defensor (elementos atacante)

proximoDefensor :: Personaje -> Personaje -> Personaje
proximoDefensor atacante defensor = atacar atacante (elementos defensor)

luchar :: Personaje -> Personaje -> (Personaje, Personaje)
luchar atacante defensor 
    | personajeMuerto atacante = (defensor, atacante)
    | otherwise = luchar (proximoAtacante atacante defensor) (proximoDefensor atacante defensor)