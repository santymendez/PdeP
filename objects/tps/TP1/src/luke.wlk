import vehiculos.*
import paises.*

object luke {
	
	var recuerdo
	var vehiculo = alambiqueVeloz
	var lugaresVisitados = 0
	
	method recuerdo() = recuerdo
	
	method vehiculo(otroVehiculo){
		vehiculo = otroVehiculo
	}
	
	method lugaresVisitados() = lugaresVisitados
	
	method visitarPais(pais, vehiculoUtilizado){
		if (pais.puedeIngresar(vehiculoUtilizado)){
			recuerdo = pais.recuerdo()
			lugaresVisitados += 1
		    vehiculo.sufrirConsecuencias()
		}
	}
	
}