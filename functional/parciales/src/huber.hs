module Huber where
import PdePreludat

-- ===== Chofer, Viaje y Cliente =====

type Nombre = String
type Kilometraje = Number
type Condicion = Viaje -> Bool

data Chofer = UnChofer {
    nombre :: Nombre,
    km :: Kilometraje,
    viajes :: [Viaje],
    condicion :: Condicion
} deriving (Show, Eq)

type Costo = Number
type Fecha = String

data Viaje = UnViaje {
    fecha :: Fecha,
    cliente :: Cliente,
    costo :: Costo
} deriving (Show, Eq)

type Direccion = String

data Cliente = UnCliente {
    nombreCliente :: Nombre,
    dondeVive :: Direccion
} deriving (Show, Eq)

-- ===== Condiciones =====

cualquierViaje :: Condicion
cualquierViaje _ = True

viajesMasCaros :: Condicion
viajesMasCaros = (>200) . costo

viajeNombreCliente :: Number -> Condicion
viajeNombreCliente n = (>n) . length . nombreCliente . cliente

viajeCuidadoso :: Direccion -> Condicion
viajeCuidadoso dir = (dir /=) . dondeVive . cliente

-- ===== Ejemplos =====

lucas :: Cliente
lucas = UnCliente "Lucas" "Victoria"

daniel :: Chofer
daniel = UnChofer "Daniel" 23500 [UnViaje "20/04/2017" lucas 150] (viajeCuidadoso "Olivos")

alejandra :: Chofer
alejandra = UnChofer "Alejandra" 180000 [] cualquierViaje

-- ===== Saber si un Chofer puede tomar un Viaje =====

tomaViaje :: Viaje -> Chofer -> Bool
tomaViaje viaje chofer = condicion chofer $ viaje

-- ===== Liquidacion de un Chofer =====

costoViajes :: [Viaje] -> Number
costoViajes = sum . map costo

liquidacionChofer :: Chofer -> Number
liquidacionChofer = costoViajes . viajes

-- ===== Realizar un Viaje =====

tomanViaje :: Viaje -> [Chofer] -> [Chofer]
tomanViaje viaje = filter (tomaViaje viaje)

cantidadViajes :: Chofer -> Number
cantidadViajes = length . viajes

choferConMenosViaje :: [Chofer] -> Chofer
choferConMenosViaje [x] = x
choferConMenosViaje (x:x':xs)
    | cantidadViajes x < cantidadViajes x' = choferConMenosViaje (x:xs)
    | otherwise = choferConMenosViaje (x':xs)

incorporarViaje :: Viaje -> Chofer -> Chofer
incorporarViaje viaje chofer = chofer {viajes = viaje : viajes chofer}

realizarViaje :: Viaje -> [Chofer] -> Chofer
realizarViaje viaje = incorporarViaje viaje . choferConMenosViaje . tomanViaje viaje

-- ===== Infinidad de Viajes =====

repetirViaje viaje = repeat viaje

nitoInfy :: Chofer
nitoInfy = UnChofer "Nito Infy" 70000 (repetirViaje (UnViaje "11/03/2017" lucas 50)) (viajeNombreCliente 3)

-- no se puede calcular la liquidacion de nito, ya que hay infinitos viajes de $50
-- podemos saber si nito puede tomar un viaje de lucas de $500 el 2/5/2017 porque no involucra a la lista infinita

-- ===== Inferencia de Tipo ====

-- gongNeng arg1 arg2 arg3 = max arg1 . head . filter arg2 . map arg3

gongNeng :: (Ord a) => a -> (a -> Bool) -> (b -> a) -> [b] -> a
gongNeng arg1 arg2 arg3 = max arg1 . head . filter arg2 . map arg3