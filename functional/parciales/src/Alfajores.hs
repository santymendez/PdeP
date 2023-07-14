module Alfajores where
import PdePreludat

-- ===== Alfajores y Relleno =====

type Nombre = String
type Peso = Number
type Dulzor = Number

data Relleno = UnRelleno {
    tipoRelleno :: String,
    precio :: Number
} deriving (Show, Eq)

dulceDeLeche :: Relleno
dulceDeLeche = UnRelleno "Dulce de Leche" 12

mousse :: Relleno
mousse = UnRelleno "Mousse" 15

fruta :: Relleno
fruta = UnRelleno "Fruta" 10

data Alfajor = UnAlfajor {
    relleno :: [Relleno],
    peso :: Peso,
    dulzor :: Dulzor,
    nombre :: Nombre
} deriving (Show, Eq)

jorgito :: Alfajor
jorgito = UnAlfajor {relleno = [dulceDeLeche], peso = 80, dulzor = 8, nombre = "Jorgito"}

havanna :: Alfajor
havanna = UnAlfajor {relleno = [mousse, mousse], peso = 60, dulzor = 12, nombre = "Havanna"}

capitanDelEspacio :: Alfajor
capitanDelEspacio = UnAlfajor {relleno = [dulceDeLeche], peso = 40, dulzor = 12, nombre = "Capitan del Espacio"}

-- ===== Propiedades de Alfajores =====

coeficienteDulzor :: Alfajor -> Number
coeficienteDulzor alfajor = dulzor alfajor / peso alfajor

precioRelleno :: [Relleno] -> Number
precioRelleno = sum . map precio 

precioAlfajor :: Alfajor -> Number
precioAlfajor alfajor = 2 * peso alfajor + precioRelleno (relleno alfajor)

capasIguales :: [Relleno] -> Bool
capasIguales (x:xs) = (>0) . length . filter (/=x) $ xs 

esPotable :: Alfajor -> Bool
esPotable alfajor = length (relleno alfajor) > 0 && capasIguales (relleno alfajor) && coeficienteDulzor alfajor >= 0.1

-- ===== Modificaciones para los Alfajores =====

reducirPeso :: Number -> Alfajor -> Alfajor
reducirPeso valor alfajor = alfajor {peso = max 5 (peso alfajor - valor)}

reducirDulzor :: Number -> Alfajor -> Alfajor
reducirDulzor valor alfajor = alfajor {dulzor = dulzor alfajor - valor} 

abaratar :: Alfajor -> Alfajor
abaratar = reducirPeso 10 . reducirDulzor 7

renombrar :: Nombre -> Alfajor -> Alfajor
renombrar nuevo alfajor = alfajor {nombre = nuevo}

agregarCapa :: Relleno -> Alfajor -> Alfajor
agregarCapa capa alfajor = alfajor {relleno = capa : relleno alfajor}

premium :: Alfajor -> Alfajor
premium alfajor 
    | esPotable alfajor = agregarCapa (head (relleno alfajor)) . renombrar (nombre alfajor ++ "premium") $ alfajor
    | otherwise = alfajor

hacerPremium :: Number -> Alfajor -> Alfajor
hacerPremium grado = hacerPremium (grado - 1) . premium 

jorgitito :: Alfajor
jorgitito = renombrar ("Jorgitito") . abaratar $ jorgito

jorgelin :: Alfajor
jorgelin = renombrar ("Jorgelin") . agregarCapa (dulceDeLeche) $ jorgito

capEspacioCostaCosta :: Alfajor
capEspacioCostaCosta = renombrar ("Capitan el espacio de costa a costa") . hacerPremium 4 . abaratar $ capitanDelEspacio

-- ===== Clientes del Kiosko =====

type Criterio = Alfajor -> Bool

data Cliente = UnCliente {
    dinero :: Number,
    alfajoresComprados :: [Alfajor],
    criterio :: [Criterio]
} deriving (Show, Eq)

dulcero :: Criterio
dulcero = (>0.15) . coeficienteDulzor

buscadorDe :: Nombre -> Criterio
buscadorDe marca = (marca==) . nombre

antisabor :: Relleno -> Criterio
antisabor sabor = not . elem sabor . relleno

extranio :: Criterio
extranio = not . esPotable

emi :: Cliente
emi = UnCliente {dinero = 120, alfajoresComprados = [], criterio = [buscadorDe "Capitan del Espacio"]}

tomi :: Cliente
tomi = UnCliente {dinero = 100, alfajoresComprados = [], criterio = [dulcero]}

dante :: Cliente
dante = UnCliente {dinero = 200, alfajoresComprados = [], criterio = [antisabor dulceDeLeche, extranio]}

juan :: Cliente
juan = UnCliente {dinero = 500, alfajoresComprados = [], criterio = [dulcero, buscadorDe "Jorgito", antisabor mousse]}

-- ===== Funciones de Alfajores =====

alfajorCumpleCriterio :: Alfajor -> Criterio -> Bool
alfajorCumpleCriterio alfajor criterio = criterio alfajor

alfajorGusta :: Cliente -> Alfajor -> Bool
alfajorGusta cliente alfajor = all (alfajorCumpleCriterio alfajor) (criterio cliente)

alfajoresQueGustan :: [Alfajor] -> Cliente -> [Alfajor]
alfajoresQueGustan alfajores cliente = filter (alfajorGusta cliente) alfajores 

agregarAlfajor :: Alfajor -> Cliente -> Cliente
agregarAlfajor alfajor cliente = cliente {alfajoresComprados = alfajor : alfajoresComprados cliente}

comprarAlfajor :: Alfajor -> Cliente -> Cliente
comprarAlfajor alfajor cliente
    | dinero cliente > precioAlfajor alfajor = agregarAlfajor alfajor cliente
    | otherwise = cliente

comprarLosQueGustan :: Cliente -> [Alfajor] -> Cliente
comprarLosQueGustan cliente alfajores = foldr (comprarAlfajor) cliente (alfajoresQueGustan alfajores cliente)