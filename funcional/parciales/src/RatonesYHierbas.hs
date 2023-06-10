module RatonesYHierbas where
import PdePreludat

--  ===== Modelado de Datos =====

type Nombre = String
type Edad = Number
type Peso = Number
type Enfermedad = String

type Hierba = Raton -> Raton
type Medicamento = Raton -> Raton

data Raton = UnRaton {
    nombre :: Nombre,
    edad :: Edad,
    peso :: Peso,
    enfermedades :: [Enfermedad]
} deriving (Show, Eq)

cerebro :: Raton
cerebro = UnRaton "cerebro" 9 0.2 ["Brucelosis", "Sarampion", "Tuberculosis"]

bicenterrata :: Raton
bicenterrata = UnRaton "bicenterrata" 256 0.2 []

huesudo :: Raton
huesudo = UnRaton "huesudo" 4 10 ["AltaObesidad", "Sinusitis"]

-- ===== Tipos de Hierbas =====

hierbaBuena :: Hierba
hierbaBuena raton = raton {edad = sqrt (edad raton)}

hierbaVerde :: String -> Hierba
hierbaVerde str raton = raton {enfermedades = filter (not . eliminarSiTermina str) (enfermedades raton)}

eliminarSiTermina :: String -> Enfermedad -> Bool
eliminarSiTermina str enfermedad = str == drop (length enfermedad - length str) enfermedad

alcachofa :: Hierba
alcachofa raton = raton {peso = perderPeso (peso raton)}

perderPeso :: Peso -> Peso
perderPeso peso
    | peso > 2.0 = peso - peso * 0.1
    | otherwise = peso - peso * 0.05

hierbaZort :: Hierba
hierbaZort raton = raton {nombre = "pinky", edad = 0, enfermedades = []}

hierbaDelDiablo :: Hierba
hierbaDelDiablo raton = raton {peso = perderPocoPeso (peso raton), enfermedades = filter ((>10) . length) (enfermedades raton)}

perderPocoPeso :: Peso -> Peso
perderPocoPeso peso
    | peso > 0 = peso - 0.1
    | otherwise = peso

-- ===== Medicamentos =====

pondsAntiAge :: Hierba
pondsAntiAge = hierbaBuena . hierbaBuena . hierbaBuena . alcachofa

reduceFatFast :: Number -> Hierba
reduceFatFast potencia raton = hierbaVerde "obesidad" (foldr ($) raton (replicate potencia alcachofa))

pdepCilina :: Hierba
pdepCilina raton = foldr ($) raton (map (hierbaVerde) sufijosInfecciosas)

sufijosInfecciosas :: [String]
sufijosInfecciosas = ["sis", "itis", "emia", "cocos"]

-- ====== Experimentos =====

cantidadIdeal :: (Number -> Bool) -> Number
cantidadIdeal f = head (filter f [1..])

lograEstabilizar :: [Raton] -> Medicamento -> Bool
lograEstabilizar comunidad medicamento = ningunoConSobrepeso (medicarComunidadRatones medicamento comunidad) && menosDe3Enfermedades (medicarComunidadRatones medicamento comunidad)

medicarComunidadRatones :: Medicamento -> [Raton] -> [Raton]
medicarComunidadRatones = map 

ningunoConSobrepeso :: [Raton] -> Bool
ningunoConSobrepeso = all ((<1) . peso) 

menosDe3Enfermedades :: [Raton] -> Bool
menosDe3Enfermedades = all ((<3) . length . enfermedades) 

experimento :: [Raton] -> Number
experimento comunidad = cantidadIdeal (\potencia -> lograEstabilizar comunidad (reduceFatFast potencia))

-- ===== Comunidad Infinita =====

-- si un medicamento deja a todos los ratones con menos de 1 kg y sin enfermedades, no vamos a poder saber si se logra estabilizar la comunidad ya que va a evaluar la lista infinitamente
-- si un medicamento deja a todos los ratones con 2kg y 4 enfermedades, en cambio si vamos a poder saber, ya que cuando la funcion all va a encontrar un elemento que no cumpla la condicion
-- y devuelve false, esto es gracias al concepto de lazy evaluation.

-- ===== Preguntas concretas =====

-- para agregar una nueva hierba no hay que modificar nada, simplemente agregarla, igual que con el medicamento

-- el concepto de esto, es el TAD (tipo abstracto de datos) y se trata de modelar los datos para que no haya que modificar las estructuras si se quieren agregar nuevas.

-- si se quiere modificar el peso del raton de kg a libras, solo habria que hacer la conversion de los pesos de los ratones creados, las funciones no se modifican.