module EscuelitaDeThanos where
import PdePreludat

-- ===== Personaje, Guantelete y Universo =====

type Material = String
type Gema = Personaje -> Personaje

data Guantelete = UnGuantelete {
    material :: Material,
    gemas :: [Gema]
}

type Nombre = String
type Edad = Number
type Energia = Number
type Habilidad = String
type Planeta = String

data Personaje = UnPersonaje {
    nombre :: Nombre,
    edad :: Edad,
    energia :: Energia,
    habilidades :: [Habilidad],
    planeta :: Planeta
}

type Universo = [Personaje]

cantidadGemas :: Guantelete -> Number
cantidadGemas = length . gemas

guanteleteCompleto :: Guantelete -> Bool
guanteleteCompleto guantelete = cantidadGemas guantelete == 6 && "uru" == material guantelete

mitadUniverso :: Universo -> Universo
mitadUniverso universo =  take (length universo `div` 2) universo 

chasquearUniverso :: Guantelete -> Universo -> Universo
chasquearUniverso guantelete universo
    | guanteleteCompleto guantelete = mitadUniverso universo
    | otherwise = error "el guantelete no esta completo"

universoAptoPendex :: Universo -> Bool
universoAptoPendex universo = any ((<45) . edad) universo

energiaTotal :: Universo -> Energia
energiaTotal = sum . map energia . filter ((>1) . length . habilidades)

-- ===== Gemas =====

reducirEnergia :: Number -> Personaje -> Personaje
reducirEnergia valor personaje = personaje {energia = energia personaje - valor}

laMente :: Number -> Gema
laMente = reducirEnergia 

eliminarHabilidad :: Habilidad -> [Habilidad] -> [Habilidad]
eliminarHabilidad habilidad (x:xs)
    | x == habilidad = xs
    | otherwise = x : eliminarHabilidad habilidad xs

elAlma :: Habilidad -> Gema
elAlma habilidad personaje = reducirEnergia 10 personaje {habilidades = eliminarHabilidad habilidad (habilidades personaje)}

transportar :: Planeta -> Personaje -> Personaje
transportar planeta personaje = personaje {planeta = planeta}

elEspacio :: Planeta -> Gema
elEspacio planeta = reducirEnergia 20 . transportar planeta 

tienePocasHabilidades :: Personaje -> Bool
tienePocasHabilidades = (<2) . length . habilidades

eliminarHabilidades :: Personaje -> Personaje
eliminarHabilidades personaje = personaje {habilidades = []}

elPoder :: Gema
elPoder personaje
    | tienePocasHabilidades personaje = reducirEnergia (energia personaje) . eliminarHabilidades $ personaje
    | otherwise = reducirEnergia (energia personaje) personaje

mitadEdad :: Personaje -> Personaje
mitadEdad personaje
    | edad personaje >= 36 = personaje {edad = edad personaje `div` 2}
    | otherwise = personaje {edad = 18}

elTiempo :: Gema
elTiempo = reducirEnergia 50 . mitadEdad

gemaLoca :: Gema -> Gema
gemaLoca gema = gema . gema

-- ===== Implementacion de las Gemas =====

-- ===== Ejemplo Guantelete =====

guanteleteEjemplo :: Guantelete
guanteleteEjemplo = UnGuantelete {material = "goma", gemas = [elTiempo, elAlma "usar Mjolnir", gemaLoca (elAlma "programacion en Haskell")]}

-- ===== Utilizar Gemas =====

utilizar :: [Gema] -> Personaje -> Personaje
utilizar gemas enemigo = foldr ($) enemigo gemas -- la funcion utilizar aplicara en orden las gemas sobre el personaje

-- ===== Gema mas Poderosa =====

busquedaGemaPoderosa :: [Gema] -> Personaje -> Gema
busquedaGemaPoderosa (x:x':xs) personaje
    | energia (x personaje) < energia (x' personaje) = busquedaGemaPoderosa (x:xs) personaje
    | otherwise = busquedaGemaPoderosa (x':xs) personaje

gemaMasPoderosa :: Guantelete -> Personaje -> Gema
gemaMasPoderosa guantelete = busquedaGemaPoderosa (gemas guantelete)

-- ===== Punto Teorico =====

infinitasGemas :: Gema -> [Gema]
infinitasGemas gema = gema:(infinitasGemas gema)

guanteleteDeLocos :: Guantelete
guanteleteDeLocos = UnGuantelete "vesconite" (infinitasGemas elTiempo)

usoLasTresPrimerasGemas :: Guantelete -> Personaje -> Personaje
usoLasTresPrimerasGemas guantelete = (utilizar . take 3. gemas) guantelete

--gemaMasPoderosa punisher guanteleteDeLocos -- esta funcion no va a poder ejecutarse, ya que esa funcion va a comparar infinitamente.

-- usoLasTresPrimerasGemas guanteleteDeLocos punisher -- esta funcion, en cambio, gracias a la evaluacion diferida, en la que haskell va analizando la lista a medida que
-- lo necesita, va a poder ejecutarse utilizando solamente 3 de las gemas infinitas.