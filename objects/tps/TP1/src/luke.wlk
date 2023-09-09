import vehiculos.*
import destinos.*

object luke {
	
	var recuerdo
	var vehiculo = alambiqueVeloz
	var lugaresVisitados = 0
	
	method recuerdo() = recuerdo
	
	method vehiculo(nuevoVehiculo){
		vehiculo = nuevoVehiculo
	}
	
	method lugaresVisitados() = lugaresVisitados
	
	method visitar(destino){
		if (destino.puedeIngresar(vehiculo)){
			recuerdo = destino.recuerdo()
			lugaresVisitados += 1
		    vehiculo.sufrirConsecuencias()
		}
	}
	
}