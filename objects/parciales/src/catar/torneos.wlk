class Torneo {
	
	const catadores = []
	const platosParticipantes = []
	
	method agregarCatador(catador){
		catadores.add(catador)
	}
	
	method hacerParticiparACocinero(cocinero) {
		platosParticipantes.add(cocinero.cocinar())
	}
	
	method calificacion(plato) = catadores.sum({catador => catador.catar(plato)})
	
	method ganador() {
		
		if(platosParticipantes.isEmpty())
			throw new DomainException(message = "No se puede definir el ganador si no hay platos que participen del torneo")
		return platosParticipantes.max({plato => self.calificacion(plato)}).cocinero()
		
	}
	
}
























