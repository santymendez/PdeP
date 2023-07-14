{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Eta reduce" #-}
module Library where
import PdePreludat

--Punto 1

type Base = Number
type Altura = Number
type Cabezal = (Number, Number)
type Posicion = (Number, Number)
data Direccion = Norte | Sur | Oeste | Este deriving (Show, Eq)
data Bolita = Verde | Azul | Rojo | Negro deriving (Show, Eq)

type Celda = ([Bolita], Posicion)
type ListaCeldas = [Celda]

data Tablero = UnTablero {
    base :: Base,
    altura :: Altura,
    cabezal :: Cabezal,
    celdas :: ListaCeldas --[([Bolitas],(x,y)),...]
} deriving (Show,Eq)

type Sentencia = Tablero -> Tablero
type Condicion = Tablero -> Bool

--Punto 2

inicializarTablero :: Base -> Altura -> Tablero
inicializarTablero base altura = UnTablero base altura (1,1) (crearCeldas base altura)

crearCeldas :: Base -> Altura -> ListaCeldas
crearCeldas base altura = [([], (x, y)) | x <- [1..base], y <- [1..altura]] --Llena las celdas con las posiciones

esCeldaActual :: Posicion -> Celda -> Bool
esCeldaActual pos celda = snd celda == pos

celdaActual :: Tablero -> Celda
celdaActual tablero = head . filter (esCeldaActual (cabezal tablero)) . celdas $ tablero

--Punto 3

mover :: Direccion -> Sentencia
mover direccion tablero
    | puedeMoverse direccion tablero = tablero {cabezal = moverCabezal direccion . cabezal $ tablero}
    | otherwise = error "Te caíste del tablero"

moverCabezal :: Direccion -> Cabezal -> Cabezal
moverCabezal direccion (x, y)
    | direccion == Norte = (x, y + 1)
    | direccion == Sur = (x, y - 1)
    | direccion == Oeste = (x - 1, y)
    | direccion == Este = (x + 1, y)

poner :: Bolita -> Sentencia
poner bolita tablero =
  tablero {celdas = map (ponerBolita (cabezal tablero) bolita) (celdas tablero)}

ponerBolita :: Posicion -> Bolita -> Celda -> Celda
ponerBolita pos bolita celda
  | esCeldaActual pos celda = (bolita : fst celda, pos) --Agrega la bolita en la lista de bolitas
  | otherwise = celda

sacar :: Bolita -> Sentencia
sacar bolita tablero | hayBolitas bolita tablero = tablero {celdas = map (ubicarCelda bolita (cabezal tablero)) (celdas tablero) } --hayBolitas permite contemplar el caso en que no esté el color pedido
  | otherwise = error "No está la bolita pedida"

ubicarCelda :: Bolita -> Posicion -> Celda -> Celda
ubicarCelda bolita pos celda
    | esCeldaActual pos celda = eliminarLaBolita bolita celda
    | otherwise = celda

eliminarLaBolita :: Bolita -> Celda -> Celda
eliminarLaBolita _ ([], pos) = ([], pos)  -- Caso base: la lista está vacía, no hay cambios
eliminarLaBolita bolita (x:xs, pos)
    | x == bolita = (xs, pos)  -- Se encontró la coincidencia, se elimina x y se retorna la lista modificada
    | otherwise = (x : eliminarLaBolitaDeLaLista bolita xs, pos)  -- Se busca en el resto de la lista recursivamente

eliminarLaBolitaDeLaLista :: Bolita -> [Bolita] -> [Bolita]
eliminarLaBolitaDeLaLista bolita (x:xs)
    | x == bolita = xs
    | otherwise = x : eliminarLaBolitaDeLaLista bolita xs

--Punto 4

si ::  Condicion -> [Sentencia] -> Sentencia
si condicion listaSentencias tablero = alternativa condicion listaSentencias [] tablero

sino :: Condicion -> [Sentencia] -> Sentencia
sino condicion listaSentencias tablero = si (not.condicion) listaSentencias tablero

alternativa :: Condicion -> [Sentencia] -> [Sentencia] -> Sentencia
alternativa condicion listaSentencias1 listaSentencias2 tablero
 |condicion tablero = programa listaSentencias1 tablero
 |otherwise = programa listaSentencias2 tablero

repetir :: Number -> [Sentencia] -> Sentencia
repetir cantidad listaSentencias tablero
  |cantidad <= 0 = tablero
  |otherwise = programa listaSentencias (repetir (cantidad - 1) listaSentencias tablero)

mientras :: Condicion -> [Sentencia] -> Sentencia
mientras condicion listaSentencias tablero
  |condicion tablero = mientras condicion listaSentencias (programa listaSentencias tablero)
  |otherwise = tablero

irAlBorde :: Direccion ->  Sentencia
irAlBorde direccion tablero = mientras (puedeMoverse direccion) [mover direccion] tablero

--Punto 5

puedeMoverse :: Direccion -> Condicion
puedeMoverse direccion tablero
  | direccion == Norte = (< altura tablero) . snd . cabezal $ tablero
  | direccion == Sur = (>1) . snd . cabezal $ tablero
  | direccion == Oeste = (>1) . snd . cabezal $ tablero
  | direccion == Este = (< base tablero) . snd . cabezal $ tablero

hayBolitas :: Bolita -> Condicion
hayBolitas bolita tablero =
    bolita `elem` fst (celdaActual tablero)

nroBolitas :: Bolita -> Tablero -> Number
nroBolitas bolita tablero = length . filter (== bolita) . fst . celdaActual $ tablero

--Punto 6

programa :: [Sentencia] -> Sentencia
programa listaSentencias tablero = foldr ($) tablero (reverse listaSentencias)

-- Punto 7

codigo :: Tablero
codigo = programa [
  mover Norte,
  poner Negro,
  poner Negro,
  poner Azul,
  mover Norte,
  repetir 15 [
    poner Rojo,
    poner Azul
  ],
  si (hayBolitas Verde) [
    mover Este,
    poner Negro
  ],
  sino (hayBolitas Verde) [
    mover Sur,
    mover Este,
    poner Azul
  ],
  mover Este,
  mientras ((<=9) . nroBolitas Verde) [
    poner Verde
  ],
  poner Azul
  ] (inicializarTablero 3 3)

--Pruebas

tableroDePrueba :: Tablero
tableroDePrueba = UnTablero 3 3 (1,1) [([Azul, Azul],(1,1)),([Verde],(1,2)),([],(1,3)),([],(2,1)),([],(2,2)),([],(2,3)),([],(3,1)),([],(3,2)),([],(3,3))]

listaSentenciasPrueba :: [Sentencia]
listaSentenciasPrueba = [poner Verde, poner Rojo, mover Norte, repetir 5 [poner Verde]]

listaSentenciasPrueba2 :: [Sentencia]
listaSentenciasPrueba2 = [poner Rojo, si (hayBolitas Rojo)[mover Norte, poner Azul], mover Este, mover Este]