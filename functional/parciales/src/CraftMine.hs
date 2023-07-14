module CraftMine where
import PdePreludat

-- ===== CRAFT =====

type Material = String

data Jugador = UnJugador {
    nombre :: String,
    puntaje :: Number,
    inventario :: [Material]
} deriving (Show, Eq)

santi :: Jugador
santi = UnJugador "Santiago" 100 ["Madera", "Fosforo", "Pollo", "Lana"]

data Receta = UnaReceta {
    nombreReceta :: String,
    materialesNecesarios :: [Material],
    tiempo :: Number
} deriving (Show, Eq)

fogata :: Receta
fogata = UnaReceta "Fogata" ["Madera", "Fosforo"] 10

polloAsado :: Receta
polloAsado = UnaReceta "Pollo Asado" ["Fogata", "Pollo"] 300

sueter :: Receta
sueter = UnaReceta "Sueter" ["Lana", "Agujas", "Tintura"] 600

agregarObjeto :: Material -> Jugador -> Jugador
agregarObjeto objeto jugador = jugador {inventario = objeto : inventario jugador}

quitarMaterial :: Material -> [Material] -> [Material]
quitarMaterial material (x:xs)
    | x == material = xs
    | otherwise = x : quitarMaterial material xs

quitarMateriales :: [Material] -> Jugador -> Jugador
quitarMateriales listaMateriales jugador = jugador {inventario = foldr (quitarMaterial) (inventario jugador) listaMateriales}

hacerReceta :: Receta -> Jugador -> Jugador
hacerReceta receta = agregarObjeto (nombreReceta receta) . quitarMateriales (materialesNecesarios receta) 

modificarPuntaje :: Number -> Jugador -> Jugador
modificarPuntaje valor jugador = jugador {puntaje = puntaje jugador + valor}

hayMaterial :: Jugador -> Material -> Bool
hayMaterial jugador material = material `elem` (inventario jugador)

hayMateriales :: Jugador -> Receta -> Bool
hayMateriales jugador = all (hayMaterial jugador) . materialesNecesarios 

craftear :: Receta -> Jugador -> Jugador
craftear receta jugador
    | hayMateriales jugador receta = modificarPuntaje (10 * tiempo receta) . hacerReceta receta $ jugador 
    | otherwise = modificarPuntaje (-100) jugador


duplicaPuntaje :: Jugador -> Receta -> Bool
duplicaPuntaje jugador receta = puntaje (craftear receta jugador) >= 2 * puntaje jugador

duplicadorasDePuntaje :: Jugador -> [Receta] -> [Receta]
duplicadorasDePuntaje jugador = filter (duplicaPuntaje jugador) 

objetosCrafteables :: Jugador -> [Receta] -> [Receta]
objetosCrafteables jugador recetas = filter (hayMateriales jugador) recetas

craftearDuplicando :: Jugador -> [Receta] -> [Receta]
craftearDuplicando jugador = objetosCrafteables jugador . duplicadorasDePuntaje jugador

craftearSucesivamente :: [Receta] -> Jugador -> Jugador
craftearSucesivamente recetas jugador = foldr (craftear) jugador recetas

mejorAlReves :: [Receta] -> Jugador -> Bool
mejorAlReves recetas jugador = puntaje (craftearSucesivamente recetas jugador) < puntaje (craftearSucesivamente (reverse recetas) jugador)

-- ===== Mine =====

data Bioma = UnBioma {
    materiales :: [Material],
    elementoNecesario :: Material
} deriving (Show, Eq)

artico :: Bioma
artico = UnBioma ["Hielo", "Iglues", "Lobos"] "Sueter"

type Herramienta = [Material] -> Material

hacha :: Herramienta
hacha = last

espada :: Herramienta
espada = head

pico :: Number -> Herramienta
pico precision = flip (!!) (precision - 1)

azada :: Herramienta
azada mats = pico (length mats `div` 2) mats

minarMaterial :: Herramienta -> Bioma -> Jugador -> Jugador
minarMaterial herramienta bioma = agregarObjeto (herramienta (materiales bioma)) 

minar :: Herramienta -> Bioma -> Jugador -> Jugador
minar herramienta bioma jugador
    | hayMaterial jugador (elementoNecesario bioma) = modificarPuntaje 50 . minarMaterial herramienta bioma $ jugador
    | otherwise = jugador

biomaInfinito :: Bioma
biomaInfinito = UnBioma (repeat "Hielo") "Pollo"

-- ghci> minar hacha biomaInfinito santi
-- esto no funciona, ya que el hacha toma el ultimo material, y tenemos materiales infinitos.

-- ghci> minar espada biomaInfinito santi
-- esto si funciona, ya que haskell utiliza evaluacion diferida y espada toma el primer material.

-- ghci> minar (pico 7) biomaInfinito santi
-- lo mismo sucede en este caso, ya que va a ir a la 6ta pos de la lista y toma ese elemento.

-- ghci> minar azada biomaInfinito santi 
-- por ultimo, con la azada tambien queda colgado el programa, ya que se basa en la funcion length, y al tener una lista infinita, no concemos el largo de esta.