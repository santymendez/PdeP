module Spec where
import PdePreludat
import Library
import Test.Hspec

correrTests :: IO ()
correrTests = hspec $ do
  describe "Punto 3" $do
    it "Mover" $do
      mover Norte tableroDePrueba `shouldBe` UnTablero 3 3 (1,2) [([Azul, Azul],(1,1)),([Verde],(1,2)),([],(1,3)),([],(2,1)),([],(2,2)),([],(2,3)),([],(3,1)),([],(3,2)),([],(3,3))]
    it "Poner" $do
      poner Verde tableroDePrueba `shouldBe` UnTablero {base = 3, altura = 3, cabezal = (1,1), celdas = [([Verde,Azul, Azul],(1,1)),([Verde],(1,2)),([],(1,3)),([],(2,1)),([],(2,2)),([],(2,3)),([],(3,1)),([],(3,2)),([],(3,3))]}
    it "Sacar" $do
      sacar Azul tableroDePrueba `shouldBe` UnTablero {base = 3, altura = 3, cabezal = (1,1), celdas = [([Azul],(1,1)),([Verde],(1,2)),([],(1,3)),([],(2,1)),([],(2,2)),([],(2,3)),([],(3,1)),([],(3,2)),([],(3,3))]}
  describe "Punto 4" $do
    it "Sino" $do
      sino ((<=2) . nroBolitas Azul) listaSentenciasPrueba tableroDePrueba `shouldBe` UnTablero {base = 3, altura = 3, cabezal = (1,1), celdas = [([Azul,Azul],(1,1)),([Verde],(1,2)),([],(1,3)),([],(2,1)),([],(2,2)),([],(2,3)),([],(3,1)),([],(3,2)),([],(3,3))]}
    it "Repetir" $do
      repetir 2 listaSentenciasPrueba tableroDePrueba `shouldBe` UnTablero {base = 3, altura = 3, cabezal = (1,3), celdas = [([Rojo,Verde,Azul,Azul],(1,1)),([Rojo,Verde,Verde,Verde,Verde,Verde,Verde,Verde],(1,2)),([Verde,Verde,Verde,Verde,Verde],(1,3)),([],(2,1)),([],(2,2)),([],(2,3)),([],(3,1)),([],(3,2)),([],(3,3))]}
    it "Ir al borde" $do
      irAlBorde Norte tableroDePrueba `shouldBe` UnTablero {base = 3, altura = 3, cabezal = (1,3), celdas = [([Azul,Azul],(1,1)),([Verde],(1,2)),([],(1,3)),([],(2,1)),([],(2,2)),([],(2,3)),([],(3,1)),([],(3,2)),([],(3,3))]}
  describe "Punto 5" $do
    it "Puede Moverse" $do
      puedeMoverse Este tableroDePrueba `shouldBe` True
    it "Hay Bolita" $do
      hayBolitas Azul tableroDePrueba `shouldBe` True
    it "Cantidad de Bolitas" $do
      nroBolitas Azul tableroDePrueba `shouldBe` 2
  describe "Punto 7" $do
    it "Ejeccución del código" $do
      codigo `shouldBe` UnTablero {base = 3, altura = 3, cabezal = (3,2), celdas = [([],(1,1)),([Azul,Negro,Negro],(1,2)),([Azul,Rojo,Azul,Rojo,Azul,Rojo,Azul,Rojo,Azul,Rojo,Azul,Rojo,Azul,Rojo,Azul,Rojo,Azul,Rojo,Azul,Rojo,Azul,Rojo,Azul,Rojo,Azul,Rojo,Azul,Rojo,Azul,Rojo],(1,3)),([],(2,1)),([Azul],(2,2)),([],(2,3)),([],(3,1)),([Azul,Verde,Verde,Verde,Verde,Verde,Verde,Verde,Verde,Verde,Verde],(3,2)),([],(3,3))]}
