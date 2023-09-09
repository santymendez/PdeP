import vehiculos.*

object paris {
	
	method recuerdo() = "llaveroTorreEiffel"
	
	method puedeIngresar(vehiculo) = vehiculo.combustibleLleno()
	
}

object buenosAires {
	
	var presidente
	
	method presidente(nuevoPresidente){
		presidente = nuevoPresidente
	}
	
	method recuerdo() = if (presidente == "amanteDelMate") "mateConYerba" else "mateSinYerba"
	
	method puedeIngresar(vehiculo) = vehiculo.esRapido()
	
}

object bagdad {
	
	var property recuerdo = "replicaJardinesColgantes"
	
	method puedeIngresar(vehiculo) = true
	
}

object lasVegas {
	
	var homenajeado = paris
	
	method homenajeado(destino){
		homenajeado = destino
	}
	
	method recuerdo() = homenajeado.recuerdo()
	
	method puedeIngresar(vehiculo) = homenajeado.puedeIngresar(vehiculo)
	
}

object napoles {  
	
	method recuerdo() = "pizzaNapolitana"
	
	method puedeIngresar(vehiculo) = !vehiculo.estaLleno()
	
}