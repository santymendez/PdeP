class Mision {
	
	const habilidadesNecesarias = []
	var peligrosidad
	
	method puedeSerCumplidaPor(asignado) = 
		habilidadesNecesarias.all({habilidad => asignado.puedeUsarHabilidad(habilidad)})
	
	method serRealizadaPor(asignado){
		if(self.puedeSerCumplidaPor(asignado)){
			asignado.recibirDanio(peligrosidad)
			asignado.completarMision(self)
		} else
			throw new DomainException(message = "No se puede realizar la mision")
	}
	
}