class Empleado {
	
	const habilidades = []
	var salud
	var puesto
	
	method habilidades() = habilidades
	
	method puesto(nuevoPuesto){
		puesto = nuevoPuesto
	}
	
	method estaIncapacitado() = salud < puesto.saludCritica()
	
	method puedeUsarHabilidad(habilidad) = not self.estaIncapacitado() 
		and self.tieneHabilidad(habilidad)
	
	method tieneHabilidad(habilidad) = habilidades.contains(habilidad)
	
	method recibirDanio(cant){
		salud = 0.max(salud - cant)
	}
	
	method estaVivo() = salud > 0
	
	method completarMision(mision){
		if(self.estaVivo())
			puesto.completarMision(mision, self)
	}
	
}

class Jefe inherits Empleado {
	
	const subordinados = []
	
	override method puedeUsarHabilidad(habilidad) = super(habilidad) 
		and subordinados.any({subordinado => subordinado.puedeUsarHabilidad(habilidad)})
	
}

object espia {
	
	method completarMision(mision, empleado){
		empleado.habilidades().add({
			habilidad => mision.esHabilidadNecesaria(habilidad) 
				and not empleado.tieneHabilidad(habilidad)
		})
	}
	
	method saludCritica() = 15
	
}

object oficinista {
	
	var estrellas
	
	method ganarEstrella(){
		estrellas += 1
	}
	
	method completarMision(mision, empleado){
		self.ganarEstrella()
		if (estrellas == 3)
			empleado.puesto(espia)
	}
	
	method saludCritica() = 40 - 5 * estrellas
	
}

class Equipo {
	
	const empleados = []
	
	method puedeUsarHabilidad(habilidad) = empleados.any({empleado => empleado.puedeUsarHabilidad(habilidad)})
	
	method recibirDanio(cant){
		empleados.forEach({empleado => empleado.recibirDanio(cant / 3)})
	}
	
	method completarMision(mision){
		empleados.forEach({empleado => empleado.completarMision(mision)})
	}
	
}