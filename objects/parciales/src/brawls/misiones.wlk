class Mision {
	
	var tipoMision = normal
	
	method cambiarTipoMision(nuevoTipo){
		tipoMision = nuevoTipo
	}
	
	method puedeRealizarse()
	
	method puedeSerSuperada()
	
	method repartirCopas()
	
	method realizarMision(){
		if(self.puedeRealizarse())
			self.repartirCopas()
		else
			throw new DomainException(message = "Mision no puede comenzar")
	}
	
	method superada() = if (self.puedeSerSuperada()) 1 else -1
	
	method copasFinales() = tipoMision.copasFinales(self)
	
}

class Boost {
	
	var property multiplicador
	
	method copasFinales(mision) = mision.copasEnJuego() * self.multiplicador()
	
}

object bonus {
	
	method copasFinales(mision) = mision.copasEnJuego() + mision.cantParticipantes()
	
}

object normal {
	
	method copasFinales(mision) = mision.copasEnJuego()
}

class Individual inherits Mision {
	
	var dificultad
	var personaje
	
	method copasEnJuego() = 2 * dificultad
	
	override method puedeSerSuperada() = personaje.tieneEstrategia() || personaje.destreza() > dificultad
	
	override method puedeRealizarse() = personaje.copas() > 10
	
	override method repartirCopas(){
		personaje.realizarMision(self.copasFinales() * self.superada())
	}
	
	method cantParticipantes() = 1
	
}

class PorEquipo inherits Mision{
	
	const participantes = []
	
	method copasEnJuego() = 50 / participantes.size()
	
	override method puedeSerSuperada() = self.equipoEstrategico() || self.equipoConDestreza()
	
	method equipoEstrategico() = participantes.count({participante => participante.tieneEstrategia()}) > participantes.size()
	
	method equipoConDestreza() = participantes.all({participante => participante.destreza() > 400})
	
	override method puedeRealizarse() = participantes.sum({participante => participante.copas()}) >= 60
	
	override method repartirCopas(){
		participantes.forEach({participante => participante.realizarMision(self.copasFinales() * self.superada())})
	}
	
	method cantParticipantes() = participantes.size()
	
}
