module FMI where
import PdePreludat

-- ===== Paises =====

type Ingreso = Number
type Cantidad = Number
type Recurso = String
type Deuda = Number

data Pais = UnPais {
    ingresoPerCapita :: Ingreso,
    sectorPublico :: Cantidad,
    sectorPrivado :: Cantidad,
    recursosNaturales :: [Recurso],
    deuda :: Deuda -- En Millones
} deriving (Show, Eq)

namibia :: Pais
namibia = UnPais 4140 400000 650000 ["Mineria", "Ecoturismo"] 50

-- ===== Estrategias FMI =====

type Estrategia = Pais -> Pais

intereses :: Number -> Number
intereses valor = valor * 1.5

prestarMillones :: Cantidad -> Estrategia
prestarMillones n pais = pais {deuda = deuda pais + intereses n}

reducirIngresoPerCapita :: Estrategia
reducirIngresoPerCapita pais
    | sectorPublico pais > 100 = pais {ingresoPerCapita = ingresoPerCapita pais - ingresoPerCapita pais * 0.2}
    | otherwise = pais {ingresoPerCapita = ingresoPerCapita pais - ingresoPerCapita pais * 0.2}

reducirPuestos :: Cantidad -> Estrategia
reducirPuestos cant pais = reducirIngresoPerCapita pais {sectorPublico = sectorPublico pais - cant}

eliminarRecurso :: Recurso -> [Recurso] -> [Recurso]
eliminarRecurso recurso (x:xs)
    | recurso == x = xs
    | otherwise = x : eliminarRecurso recurso xs

explotarRecurso :: Recurso -> Estrategia
explotarRecurso recurso pais = pais {deuda = deuda pais - 2, recursosNaturales = eliminarRecurso recurso (recursosNaturales pais)}

pbi :: Pais -> Number
pbi pais = ingresoPerCapita pais * (sectorPrivado pais + sectorPublico pais)

blindaje :: Estrategia
blindaje pais = reducirPuestos 500 . prestarMillones (pbi pais) $ pais

-- ===== Recetas =====

type Receta = [Estrategia]

receta :: Receta
receta = [prestarMillones 20, explotarRecurso "Mineria"]

aplicarReceta :: Receta -> Pais -> Pais
aplicarReceta receta pais = foldr ($) pais receta

-- ===== Lista de Paises =====

puedenZafar :: [Pais] -> [Pais]
puedenZafar = filter $ (elem "Petroleo") . recursosNaturales

deudaTotal :: [Pais] -> Number
deudaTotal = sum . map deuda

-- ===== Lista de Recetas Ordenadas de Peor a Mejor =====

ordenadoPeorAMejor :: Pais -> [Receta] -> Bool
ordenadoPeorAMejor _ [x] = True
ordenadoPeorAMejor pais (x:x':xs)
    | pbi (aplicarReceta x pais) < pbi (aplicarReceta x' pais) = ordenadoPeorAMejor pais (x':xs)
    | otherwise = False

-- ====== Recursos Infinitos =====

recursosInfinitos :: [Recurso]
recursosInfinitos = "Energia" : recursosInfinitos

-- la funcion puedenZafar no va a poder aplicarse, porque va a evaluar infinitamente.

-- la funcion deudaTotal si va a poder aplicarse, ya que no requiere de los recursos para evaluar.