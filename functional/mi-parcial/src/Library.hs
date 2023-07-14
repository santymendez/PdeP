{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
module Library where
import PdePreludat

doble :: Number -> Number
doble numero = numero + numero

-- Punto 1

type Poder = Nave -> Nave

data Nave = UnaNave {
    nombre :: String,
    durabilidad :: Number,
    escudo :: Number,
    ataque :: Number,
    poder :: Poder
} deriving (Show, Eq)

modificarAtaque :: Number -> Nave -> Nave
modificarAtaque valor nave = nave {ataque = ataque nave + valor}

modificarDurabilidad :: Number -> Nave -> Nave
modificarDurabilidad valor nave = nave {durabilidad = durabilidad nave + valor}

modificarEscudo :: Number -> Nave -> Nave
modificarEscudo valor nave = nave {escudo = escudo nave + valor}

reparacionEmergencia :: Poder
reparacionEmergencia = modificarAtaque (-30) . modificarDurabilidad 50

movSuperTurbo :: Number -> Poder
movSuperTurbo potencia nave
    | potencia > 0 = modificarDurabilidad (-45) . movSuperTurbo (potencia -1) $ nave
    | otherwise = nave

tieFighter :: Nave
tieFighter = UnaNave "TIE Fighter" 200 100 50 (modificarAtaque 25)

xWing :: Nave
xWing = UnaNave "X Wing" 300 150 100 reparacionEmergencia

naveDarthVader :: Nave
naveDarthVader = UnaNave "Nave de Darth Vader" 500 300 200 (movSuperTurbo 3)

millenniumFalcon :: Nave
millenniumFalcon = UnaNave "Millennium Falcon" 1000 500 50 (reparacionEmergencia . modificarEscudo 100)

naveTrooper :: Nave
naveTrooper = UnaNave "Nave Trooper" 200 50 100 (modificarAtaque 30 . modificarEscudo (-45))

-- Punto 2

type Flota = [Nave]

durabilidadesFlota :: Flota -> [Number]
durabilidadesFlota = map durabilidad

durabilidadTotal :: Flota -> Number
durabilidadTotal = sum . durabilidadesFlota

-- Punto 3

dañoRecibido :: Nave -> Nave -> Number
dañoRecibido atacante atacada = max 0 (ataque atacante - escudo atacada)

activarHabilidad :: Nave -> Nave
activarHabilidad nave = poder nave nave

naveAtacada :: Nave -> Nave -> Nave
naveAtacada atacada nave
    | escudo atacada > ataque nave = atacada
    | otherwise = modificarDurabilidad (-dañoRecibido (activarHabilidad nave) (activarHabilidad atacada)) atacada

-- Punto 4

naveFueraCombate :: Nave -> Bool
naveFueraCombate = (0==) . durabilidad

-- Punto 5

type Estrategia = Nave -> Bool

misionSorpresa :: Nave -> Flota -> Estrategia -> Flota
misionSorpresa _ [] _ = []
misionSorpresa nave (x:xs) strat
    | strat x = naveAtacada x nave : misionSorpresa nave xs strat
    | otherwise = x : misionSorpresa nave xs strat

navesDebiles :: Estrategia
navesDebiles = (<200) . escudo

navesCiertaPeligrosidad :: Number -> Estrategia
navesCiertaPeligrosidad valor = (>valor) . ataque

navesFueraCombate :: Nave -> Estrategia
navesFueraCombate atacante = naveFueraCombate . naveAtacada atacante

navesLentas :: Estrategia
navesLentas = (>10) . length . nombre 

-- Punto 6

mejorEstrategia :: Nave -> Flota -> Estrategia -> Estrategia -> Estrategia
mejorEstrategia nave flota strat1 strat2
    | durabilidadTotal (misionSorpresa nave flota strat1) < durabilidadTotal (misionSorpresa nave flota strat2) = strat1
    | otherwise = strat2

usarMejorEstrategia :: Nave -> Flota -> Estrategia -> Estrategia -> Flota
usarMejorEstrategia nave flota strat1 strat2 = misionSorpresa nave flota (mejorEstrategia nave flota strat1 strat2)

-- Punto 7

navesInfinitas :: Flota
navesInfinitas = repeat xWing

-- No se puede saber la durabilidad total, ya que para eso se tiene que recorrrer toda la lista, pero es infinita.

-- Como la flota es infinita, al intentar hacer una mision sobre ella, el programa va a quedar colgado, ya que la funcion va evaluando si puede o no atacar cada nave 
-- de la flota, por lo que nunca va a parar de evaluarla.