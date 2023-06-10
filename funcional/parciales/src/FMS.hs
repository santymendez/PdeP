module FMS where
import PdePreludat

type Palabra = String
type Verso = String
type Estrofa = [Verso]
type Artista = String

esVocal :: Char -> Bool
esVocal = flip elem "aeiou"

tieneTilde :: Char -> Bool
tieneTilde = flip elem "áéíóú"

cumplen :: (a -> b) -> (b -> b -> Bool) -> a -> a -> Bool
cumplen f comp v1 v2 = comp (f v1) (f v2)

-- ===== Rimas =====

rimaAsonante :: Palabra -> Palabra -> Bool
rimaAsonante = cumplen (ultimasVocales 2) (==)

rimaConsonante :: Palabra -> Palabra -> Bool
rimaConsonante = cumplen (ultimasLetras 3) (==)

riman :: Palabra -> Palabra -> Bool
riman p1 p2 = p1 /= p2 && (rimaAsonante p1 p2 || rimaConsonante p1 p2)

ultimasLetras :: Number -> Palabra -> String
ultimasLetras n = reverse . take n . reverse

ultimasVocales :: Number -> Palabra -> String
ultimasVocales n = ultimasLetras n . filter vocal

vocal :: Char -> Bool
vocal letra = esVocal letra || tieneTilde letra

-- ===== Conjugaciones =====

type Conjugacion = Verso -> Verso -> Bool

utlimaPalabra :: Verso -> Palabra
utlimaPalabra = last . words

primeraPalabra :: Verso -> Palabra
primeraPalabra = head . words

porRimas :: Conjugacion
porRimas = cumplen (last . words) riman

porAnadiplosis :: Conjugacion
porAnadiplosis v1 v2 = utlimaPalabra v1 == primeraPalabra v2

-- ===== Patrones =====

type Patron = Estrofa -> Bool

simple :: (Number, Number) -> Patron
simple (x,y) estrofa = (!!) estrofa (x-1) `porRimas` (!!) estrofa (y-1)

esEsdrujula :: Palabra -> Bool
esEsdrujula = tieneTilde . head . ultimasVocales 3

esdrujulas :: Patron
esdrujulas = all (esEsdrujula . utlimaPalabra)

anafora :: Patron
anafora estrofa = all (primeraPalabra (head estrofa) ==) estrofa

cadena :: Conjugacion -> Patron
cadena _ [] = False
cadena _ [x] = True
cadena conjugacion (x:x':xs) = x `conjugacion` x' && cadena conjugacion (x':xs)

combinaDos :: Patron -> Patron -> Patron
combinaDos patron1 patron2 estrofa = patron1 estrofa && patron2 estrofa

aabb :: Patron
aabb = simple (1,2) `combinaDos` simple (3,4)

abab :: Patron
abab = simple (1,3) `combinaDos` simple (2,4)

abba :: Patron
abba = simple (1,4) `combinaDos` simple (2,3)

hardcore :: Patron
hardcore = cadena porRimas `combinaDos` esdrujulas

-- ===== Puestas en Escena =====

data PuestaEnEscena = UnaPuestaEnEscena {
    publicoExaltado :: Bool,
    potencia :: Potencia,
    estrofa :: Estrofa,
    artista :: Artista 
} deriving (Show, Eq)

type Potencia = Number
type Estilo = PuestaEnEscena -> PuestaEnEscena

exaltarPublico :: PuestaEnEscena -> PuestaEnEscena
exaltarPublico puesta = puesta {publicoExaltado = True}

modificarPotencia :: Number -> PuestaEnEscena -> PuestaEnEscena
modificarPotencia n puesta = puesta {potencia = potencia puesta + n}

gritar :: Estilo
gritar puesta = modificarPotencia (potencia puesta * 0.5) puesta

responderAcote :: Bool -> Estilo
responderAcote efectiva puesta
    | efectiva = modificarPotencia (potencia puesta * 0.2) . exaltarPublico $ puesta

tirarTecnicas :: Patron -> Estilo
tirarTecnicas patron puesta 
    | patron (estrofa puesta) = modificarPotencia (potencia puesta * 0.1) . exaltarPublico $ puesta

puestaBase :: Artista -> Estrofa -> PuestaEnEscena 
puestaBase artista estrofa = UnaPuestaEnEscena {potencia = 1, publicoExaltado = False, estrofa = estrofa, artista = artista}

tirarFreestyle :: Estilo -> Artista -> Estrofa -> PuestaEnEscena
tirarFreestyle puesta artista = puesta . puestaBase artista 

-- ===== Jurados =====

type Jurado = [Criterio]
type Criterio = (PuestaEnEscena -> Bool, Number)

alToke :: Jurado
alToke = [(aabb . estrofa, 0.5), ((esdrujulas `combinaDos` simple (1,4)) . estrofa, 1), (publicoExaltado, 1), ((>1.5) . potencia, 2)]

criterioCumplido :: PuestaEnEscena -> Criterio -> Bool
criterioCumplido puesta criterio = (fst criterio) puesta

criteriosCumplidos :: Jurado -> PuestaEnEscena -> [Criterio]
criteriosCumplidos jurado puesta = filter (criterioCumplido puesta) jurado

listaPuntajes :: Jurado -> PuestaEnEscena -> [Number]
listaPuntajes jurado puesta = map (snd) (criteriosCumplidos jurado puesta)

maximoSuma3 :: [Number] -> Number
maximoSuma3 lista
    | (>=3) . sum $ lista = 3
    | otherwise = sum lista

puntaje :: Jurado -> PuestaEnEscena -> Number
puntaje jurado = maximoSuma3 . (listaPuntajes jurado)