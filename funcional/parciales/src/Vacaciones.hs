module Vacaciones where
import PdePreludat

-- ===== Modelado de Datos =====

type Cansancio = Number
type Stress = Number
type Acompaniado = Bool
type Idiomas = [String]
type Idioma = String

type Excursion = Turista -> Turista

data Turista = UnTurista {
    cansancio :: Cansancio,
    stress :: Stress,
    acompaniado :: Acompaniado,
    idiomas :: Idiomas
} deriving (Show, Eq)

ana :: Turista
ana = UnTurista 0 21 True ["Espaniol"]

beto :: Turista
beto = UnTurista 15 15 False ["Aleman"]

cathi :: Turista
cathi = UnTurista 15 15 False ["Aleman", "Catalan"]

-- ===== Excursiones ===== 

modificarCansancio :: Number -> Turista -> Turista
modificarCansancio nro turista = turista {cansancio = cansancio turista + nro}

modificarStress :: Number -> Turista -> Turista
modificarStress nro turista = turista {stress = stress turista + nro}

irALaPlaya :: Excursion
irALaPlaya turista
    | acompaniado turista = modificarStress (-1) turista
    | otherwise = modificarCansancio (-5) turista 

apreciarPaisaje :: String -> Excursion
apreciarPaisaje elemento = modificarStress (-length elemento)

salirHablarIdioma :: Idioma -> Excursion
salirHablarIdioma idioma turista = turista {idiomas = agregarIdioma idioma (idiomas turista), acompaniado = True}

agregarIdioma :: Idioma -> Idiomas -> Idiomas
agregarIdioma idioma listaIdiomas
    | idioma `elem` listaIdiomas = listaIdiomas
    | otherwise = idioma : listaIdiomas

caminar :: Number -> Excursion
caminar minutos = modificarCansancio (intensidadCaminata minutos) . modificarStress (-intensidadCaminata minutos)

intensidadCaminata :: Number -> Number
intensidadCaminata minutos = minutos `div` 4

paseoEnBarco :: String -> Excursion
paseoEnBarco estadoMarea turista
    | estadoMarea == "Fuerte" = modificarCansancio 10 . modificarStress 6 $ turista
    | estadoMarea == "Tranquila" = caminar 10 . apreciarPaisaje "Mar" . salirHablarIdioma "Aleman" $ turista
    | otherwise = turista

-- ===== Hacer Excursion ===== 

hacerExcursion :: Excursion -> Turista -> Turista
hacerExcursion excursion turista = modificarStress (- stress turista * 0.1) . excursion $ turista

-- ===== Diferencias ===== 

deltaSegun :: (a -> Number) -> a -> a -> Number
deltaSegun f algo1 algo2 = f algo1 - f algo2

deltaExcursionSegun :: (Turista -> Number) -> Turista -> Excursion -> Number
deltaExcursionSegun indice turista excursion = deltaSegun indice turista (hacerExcursion excursion turista)

-- ===== Excursiones Desestresantes y Educativas =====

esEducativa :: Turista -> Excursion -> Bool
esEducativa turista = (<0) . deltaExcursionSegun (length . idiomas) turista

esDesestresante :: Turista -> Excursion -> Bool
esDesestresante turista = (>=3) . deltaExcursionSegun stress turista

excursionesDesestresantes :: Turista -> [Excursion] -> [Excursion]
excursionesDesestresantes turista = filter (esDesestresante turista)

-- ===== Tours =====

type Tour = [Excursion]

tourCompleto :: [Excursion]
tourCompleto = [caminar 20, apreciarPaisaje "cascada", caminar 40, salirHablarIdioma "melmacquiano"]

tourLadoB :: Excursion -> [Excursion]
tourLadoB excursion = [paseoEnBarco "Tranquila", excursion, caminar 20]

tourIslaVecina :: String -> [Excursion]
tourIslaVecina marea
    | marea == "Fuerte" = [paseoEnBarco marea, apreciarPaisaje "lago", paseoEnBarco marea]
    | otherwise = [paseoEnBarco marea, irALaPlaya, paseoEnBarco marea]

-- ===== Hacer Tour =====

hacerTour :: Tour -> Turista -> Turista
hacerTour tour turista =  (foldr ($) (modificarStress (length tour) turista) tour)

-- ===== Tour Convincente ===== 

tourConvincente :: Turista -> Tour -> Bool
tourConvincente turista tour = any (esDesestresante turista) tour && acompaniado (hacerTour tour turista)

hayTourConvincente :: [Tour] -> Turista -> Bool
hayTourConvincente tours turista = any (tourConvincente turista) tours

-- ===== Espiritualidad y Efectividad =====

espiritualidad :: Tour -> Turista -> Number
espiritualidad tour turista = deltaSegun stress turista (hacerTour tour turista) + deltaSegun cansancio turista (hacerTour tour turista)

turistasConvencidos :: Tour -> [Turista] -> [Turista]
turistasConvencidos tour conjTuristas = filter (flip tourConvincente tour) conjTuristas

espiritualidadesTuristasConvencidos :: Tour -> [Turista] -> [Number]
espiritualidadesTuristasConvencidos tour conjTuristas = map (espiritualidad tour) (turistasConvencidos tour conjTuristas)

tourEfectivo :: Tour -> [Turista] -> Number
tourEfectivo tour conjTuristas = foldl (+) 0 (espiritualidadesTuristasConvencidos tour conjTuristas)

-- ===== Visita infinita a la playa ===== 

playasInfinitas :: Tour
playasInfinitas = repeat irALaPlaya

-- no se puede saber si el tour infinito es convincente para ana, ya que esa funcion hace uso de la funcion any, que va a buscar por toda la lista hasta encontrar algun 
-- elemento que cumpla la condicion, y como la excursion irALaPlaya para ana no es desestresante, va a buscar infinitamente.
-- con beto sucede lo mismo.

-- no se puede saber la efectividad de un tour, ya que se usa la funcion hacerTour que va a ejectuar infinitamente la excursion irALaPlaya sobre el turista