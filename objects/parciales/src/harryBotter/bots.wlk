import casas.*

class Bot {
	
	var cargaElectrica
	var aceitePuro
	
	method cargaElectrica() = cargaElectrica
	
	method cargaElectrica(cant){
		cargaElectrica = 0.max(cant)
	}
	
	method aceitePuro() = aceitePuro
	
	method ensuciarAceite(){
		aceitePuro = false
	}
	
	method sufrirConsecuencias(hechizo){
		hechizo.hechizar(self)
	}
	
	method activo() = cargaElectrica > 0
	
}

class SombreroBotSeleccionador inherits Bot {
	
	const casas = [gryffindor, slytherin, ravenclaw, hufflepuff]
	const recienLlegados = []
	
	method llegaEstudiante(estudiante){
		recienLlegados.add(estudiante)
	}
	
	method asignarCasa(estudiante){
		estudiante.casa(casas.head())
		casas.add(casas.head())
		casas.remove(casas.head())
	}
	
	method distribuir(){
		recienLlegados.forEach({estudiante => 
			self.asignarCasa(estudiante) 
			recienLlegados.remove(estudiante)
		})
	}
	
	override method ensuciarAceite(){}
	
}

class Hechicero inherits Bot {
	
	var property casa
	const hechizos = []
	
	method hechizos() = hechizos
	
	method puedeLanzarHechizo(hechizo) = hechizos.contains(hechizo) && self.activo() && hechizo.condiciones(self)
	
	method lanzarHechizo(hechizo, bot){
		if(self.puedeLanzarHechizo(hechizo))
			bot.sufrirConsecuencias(hechizo)
		else
			throw new DomainException(message = "No se puede lanzar el hechizo")
	}
	
	method experimentado() = hechizos.size() > 3 && self.cargaElectrica() > 50
	
}

class Estudiante inherits Hechicero {
	
	method aprenderHechizo(hechizo){
		hechizos.add(hechizo)
	}
	
	method asistirAMateria(materia){
		self.aprenderHechizo(materia.hechizo())
	}
	
}

class Profesor inherits Hechicero {
	
	const materiasDictadas = []
	
	override method experimentado() = super() && materiasDictadas.size() >= 2
	
	override method cargaElectrica(cant){
		if(cant == 0)
			cargaElectrica /= 2
		else {}
	}
	
}

class Materia {
	
	var profesor
	var hechizo
	const alumnos = []

	method profesor() = profesor
	
	method hechizo() = hechizo
	
	method grupoAsistente(){
		alumnos.forEach({alumno => alumno.asistirAMateria(self)})
	}
	
}