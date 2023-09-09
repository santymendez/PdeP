object alambiqueVeloz {
	
	var combustible = 100
	
	method esRapido() = true
	
	method combustibleLleno() = combustible == 100
	
	method sufrirConsecuencias(){
		0.max(combustible -= 5)
	}
}

object portadorDeFamilia {
	
	var tripulantes = 3
	
	method tripulantes(cantidad){
		tripulantes = cantidad
	}
	
	method combustibleLleno() = false
	
	method estaLleno() = tripulantes >= 5
	
	method esRapido() = tripulantes <= 2
	
	method sufrirConsecuencias(){
		1.max(tripulantes -= 1)			// no muere, baja del auto y se queda en la ciudad
	}
	
}