import platos.*

class Cocinero {
	
	var especialidad
	const nombre
	
	method especialidad(nuevaEspecialidad){
		especialidad = nuevaEspecialidad
	}
	
	method catar(plato) = especialidad.catar(plato)
	
	method cocinar() = especialidad.cocinar(nombre)
	
}

class Pastelero {
	
	const nivelDulzor
	
	method catar(plato) = (5 * plato.azucar() / nivelDulzor).min(10)
	
	method cocinar(nombre) = new Postre(cocinero = nombre, color = nivelDulzor / 50)
	
}

class Chef {
	
	const caloriasMax
	
	method cumpleExpectativas(plato) = plato.bonito() && plato.calorias() < caloriasMax
	
	method calificacionSiNoCumple(plato) = 0
	
	method catar(plato) = if (self.cumpleExpectativas(plato)) 10 else self.calificacionSiNoCumple(plato)
	
	method cocinar(nombre) = new Principal(cocinero = nombre, azucar = caloriasMax, bonito = true)
	
}

class SousChef inherits Chef {
	
	override method calificacionSiNoCumple(plato) = 6.max(plato.calorias() / 100)
	
	override method cocinar(nombre) = new Entrada(cocinero = nombre)
	
}