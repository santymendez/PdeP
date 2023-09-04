object alambiqueVeloz {
	
	var combustible = 100
	
	method esRapido() = true
	
	method combustibleLleno() = combustible == 100
	
	method sufrirConsecuencias(){
		combustible -= 5
	}
}

object portadorDeFamilia {
	
	var property tripulantes = 3
	
	method estaLleno() = tripulantes <= 4
	
	method esRapido() = tripulantes <= 2
	
	method sufrirConsecuencias(){
		tripulantes -= 1
	}
	
}