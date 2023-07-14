module HarryPostre where
import PdePreludat

-- ===== Modelado de Postres =====

type Sabor = String
type Peso = Number
type Temperatura = Number

data Postre = UnPostre {
    sabores :: [Sabor],
    peso :: Peso,
    temperatura :: Temperatura
} deriving (Show, Eq)

chocotorta :: Postre
chocotorta = UnPostre ["Queso Crema", "Dulce de Leche", "Chocolinas", "Cafe"] 5 15

-- ===== Modelado de Hechizos =====

type Hechizo = Postre -> Postre

modificarTemp :: Number -> Postre -> Postre
modificarTemp valor postre = postre {temperatura = temperatura postre + valor}

modificarPeso :: Number -> Postre -> Postre
modificarPeso valor postre = postre {peso = peso postre + valor}

modificarPesoPorc :: Number -> Postre -> Postre
modificarPesoPorc porcentaje postre = postre {peso = peso postre - (porcentaje * peso postre) / 100}

agregarSabor :: Sabor -> Postre -> Postre
agregarSabor sabor postre = postre {sabores = sabor : sabores postre}

congelarPostre :: Postre -> Postre
congelarPostre postre = postre {temperatura = 0}

perderSabores :: Postre -> Postre
perderSabores postre = postre {sabores = []}


incendio :: Hechizo
incendio = modificarTemp 1 . modificarPesoPorc 50

immobulus :: Hechizo
immobulus = congelarPostre

wingardiumLeviosa :: Hechizo
wingardiumLeviosa = agregarSabor ("concentrado") . modificarPesoPorc 10

diffindo :: Number -> Hechizo
diffindo = modificarPesoPorc

riddikulus :: Sabor -> Hechizo
riddikulus sabor = agregarSabor (reverse sabor)

avadaKedavra :: Hechizo
avadaKedavra = perderSabores . immobulus


promedio :: [Number] -> Number
promedio nros = sum nros / length nros

postreListo :: Postre -> Bool
postreListo postre = peso postre > 0 && temperatura postre > 0 && length (sabores postre) > 0

postresHechizados :: [Postre] -> Hechizo -> [Postre]
postresHechizados postres hechizo = map (hechizo) postres

postresHechizadosListos :: [Postre] -> Hechizo -> Bool
postresHechizadosListos postres = all postreListo . postresHechizados postres

pesoPromedioListos :: [Postre] -> Number
pesoPromedioListos = promedio . map peso . filter postreListo

-- ===== Magos =====

data Mago = UnMago {
    hechizosAprendidos :: [Hechizo],
    horrorcruxes :: Number
} deriving (Show, Eq)

modificarHorrorcruxes :: Number -> Mago -> Mago
modificarHorrorcruxes valor mago = mago {horrorcruxes = horrorcruxes mago + valor}

aprenderHechizo :: Hechizo -> Mago -> Mago
aprenderHechizo hechizo mago = mago {hechizosAprendidos = hechizo : hechizosAprendidos mago}

practicarHechizo :: Mago -> Hechizo -> Postre -> Mago
practicarHechizo mago hechizo postre
    | hechizo postre == avadaKedavra postre = aprenderHechizo hechizo . modificarHorrorcruxes 1 $ mago
    | otherwise = aprenderHechizo hechizo mago

mejorHechizo :: Postre -> [Hechizo] -> Hechizo
mejorHechizo postre (x:x':xs)
    | length (sabores (x postre)) < length (sabores (x' postre)) = mejorHechizo postre (x':xs)
    | otherwise = mejorHechizo postre (x:xs)

mejorHechizoMagico :: Postre -> Mago -> Hechizo
mejorHechizoMagico postre = mejorHechizo postre . hechizosAprendidos

-- ===== Infinita Magia =====

postresInfinitos :: [Postre]
postresInfinitos = repeat chocotorta

magoInfinito :: Mago
magoInfinito = UnMago (repeat immobulus) 0

-- teniendo una mesa con infinitos postres y preguntando si algun hechizo los deja listos, para que me sepa responder tendria que usar algun hechizo que no deje listo un
-- postre, asi la funcion all me devolveria false al encontrar un postre que no este listo.  
 
-- teniendo un mago con infinitos hechizos, no se puede saber cual es el mejor hechizo, ya que esa funcion compara hechizos uno detras de otro, y al haber una lista !!
-- infinita de hechizos, nunca dejaria de comparar.