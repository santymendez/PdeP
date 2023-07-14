module Minigolfito where
import PdePreludat

data Jugador = UnJugador {
  nombre :: String,
  padre :: String,
  habilidad :: Habilidad
} deriving (Eq, Show)

data Habilidad = Habilidad {
  fuerzaJugador :: Number,
  precisionJugador :: Number
} deriving (Eq, Show)

bart = UnJugador "Bart" "Homero" (Habilidad 25 60)
todd = UnJugador "Todd" "Ned" (Habilidad 15 80)
rafa = UnJugador "Rafa" "Gorgory" (Habilidad 10 1)

data Tiro = UnTiro {
  velocidad :: Number,
  precision :: Number,
  altura :: Number
} deriving (Eq, Show)

type Puntos = Number

between n m x = elem x [n .. m]

maximoSegun f = foldl1 (mayorSegun f)
mayorSegun f a b
  | f a > f b = a
  | otherwise = b

type Palo = Habilidad -> Tiro

-- ===== Palos =====

putter :: Palo
putter habilidad = UnTiro {velocidad = 10, precision = (2 * precisionJugador habilidad), altura = 0}

madera :: Palo
madera habilidad = UnTiro {velocidad = 100, precision = precisionJugador habilidad / 2, altura = 5}

hierro :: Number -> Palo
hierro n habilidad = UnTiro {velocidad = fuerzaJugador habilidad * n, precision = precisionJugador habilidad / n, altura = alturaMinimo0 n 3}

alturaMinimo0 :: Number -> Number -> Number
alturaMinimo0 n n1
    | n - n1 > 0 = n - n1
    | otherwise = 0

palos :: [Palo]
palos = [putter, madera] ++ mapear hierro 

mapear hierro = map (hierro) [1..10]

-- ===== Funcion Golpe =====

golpe :: Jugador -> Palo -> Tiro
golpe jugador palo = palo (habilidad jugador)

-- ===== Obstaculos =====

type Obstaculo = Tiro -> Bool

modificarVelocidad :: Number -> Tiro -> Tiro
modificarVelocidad n tiro = tiro {velocidad = n}

modificarPrecision :: Number -> Tiro -> Tiro
modificarPrecision n tiro = tiro {precision = n}

modificarAltura :: Number -> Tiro -> Tiro
modificarAltura n tiro = tiro {altura = n}

tunelConRampita :: Obstaculo
tunelConRampita tiro = precision tiro > 90

superaTunelConRampita :: Tiro -> Tiro
superaTunelConRampita tiro
    | tunelConRampita tiro = modificarVelocidad (2 * velocidad tiro) . modificarPrecision 100 . modificarAltura 0 $ tiro
    | otherwise = tiroNulo

laguna :: Obstaculo
laguna tiro = velocidad tiro > 80 && between 1 5 (altura tiro)

superaLaguna :: String -> Tiro -> Tiro
superaLaguna tipoLaguna tiro
    | laguna tiro = modificarAltura (altura tiro / length tipoLaguna) tiro
    | otherwise = tiroNulo

hoyo :: Obstaculo
hoyo tiro = between 5 20 (velocidad tiro) && precision tiro > 95

aciertaHoyo :: Tiro -> Tiro
aciertaHoyo tiro
    | hoyo tiro = tiroNulo
    | otherwise = tiro

tiroNulo :: Tiro
tiroNulo = UnTiro 0 0 0

-- ===== Utilidad de Palos =====

palosUtiles :: Jugador -> Obstaculo -> [Palo]
palosUtiles jugador obstaculo = filter (obstaculo . golpe jugador) palos

superadosConsecutivos :: Tiro -> [Obstaculo] -> Number
superadosConsecutivos _ [] = 0
superadosConsecutivos tiro (x:xs)
  | x tiro = 1 + superadosConsecutivos tiro xs
  | otherwise = 0

supera tiro (x:xs)
  | x tiro = x : supera tiro xs
  | otherwise = []

paloMasUtil :: Jugador -> [Obstaculo] -> Palo
paloMasUtil jugador obstaculos = maximoSegun (flip superadosConsecutivos obstaculos . golpe jugador) palos

padresPerdedores :: [(Jugador, Puntos)] -> [String]
padresPerdedores [] = []
padresPerdedores [x] = [padre (fst x)]
padresPerdedores (x:x':xs) 
  | snd x < snd x' = padre (fst x) : padresPerdedores (x':xs)
  | otherwise = padre (fst x') : padresPerdedores (x:xs)