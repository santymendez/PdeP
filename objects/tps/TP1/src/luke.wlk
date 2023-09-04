import vehiculos.*
import paises.*

object luke {
	
	var recuerdo
	var vehiculo = alambiqueVeloz
	var lugaresVisitados = 0
	
	method recuerdo() = recuerdo
	
	method lugaresVisitados() = lugaresVisitados
	
	method vehiculo(otroVehiculo){
		vehiculo = otroVehiculo
	}
	
	method visitarPais(pais, vehiculoUtilizado){
		if (pais.puedeIngresar(vehiculoUtilizado)){
			recuerdo = pais.recuerdo()
			lugaresVisitados += 1
		    vehiculo.sufrirConsecuencias()
		}
	}
	
}