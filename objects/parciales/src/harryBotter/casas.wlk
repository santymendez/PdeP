class Casa {
	
	const integrantes = []
	
	method esPeligrosa() = integrantes.count({integrante => !integrante.aceitePuro()}) > integrantes.count({integrante => integrante.aceitePuro()})
	
	method lanzarHechizoGrupal(botMaligno){
		integrantes.forEach({integrante => integrante.lanzarHechizo(integrante.hechizos().last(), botMaligno)})
	}
	
}

object gryffindor inherits Casa {
	
	override method esPeligrosa() = false
	
}

object slytherin inherits Casa {
	
	override method esPeligrosa() = true
	
}

object ravenclaw inherits Casa{}

object hufflepuff inherits Casa{}