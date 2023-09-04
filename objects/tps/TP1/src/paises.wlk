import vehiculos.*

object paris {
	
	method recuerdo() = "llaveroTorreEiffel"
	
	method puedeIngresar(vehiculo) = alambiqueVeloz.combustibleLleno()
	
}

object buenosAires {
	
	var presidente = "albertoFernandez"
	
	var property recuerdo = "mateSinYerba"
	
	method presidente(nuevoPresidente){
		presidente = nuevoPresidente
	}
	
	method puedeIngresar(vehiculo) = vehiculo.esRapido()
	
}

object bagdad {
	
	var property recuerdo = "replicaJardinesColgantes"
	
	method puedeIngresar(vehiculo) = true
	
}

object lasVegas {
	
	var homenajeado = paris
	
	method homenajeado(pais){
		homenajeado = pais
	}
	
	method recuerdo() = homenajeado.recuerdo()
	
	method puedeIngresar(vehiculo) = homenajeado.puedeIngresar(vehiculo)
	
}

object napoles {  
	
	method recuerdo() = "pizzaNapolitana"
	
	method puedeIngresar(vehiculo) = !vehiculo.estaLleno()
	
}