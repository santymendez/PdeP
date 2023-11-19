class Plato {
	
	var azucar
	var cocinero
	
	method cocinero() = cocinero
	
	method azucar() = azucar
	
	method calorias() = 3 * azucar + 100
	
}

class Entrada inherits Plato(azucar = 0) {
	
	method bonito() = true
	
}

class Principal inherits Plato{
	
	var bonito
	
	method bonito() = bonito
	
}

class Postre inherits Plato(azucar = 120){
	
	var color
	
	method color() = color
	
	method bonito() = self.color() > 3
	
}