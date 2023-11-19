class Mensaje {
	
	var emisor
	var contenido
	
	method emisor() = emisor
	
	method pesoMensaje() =  5 + contenido.peso() * 1.3
	
	method contiene(texto) = emisor.contiene(texto) || contenido.contiene(texto)
	
}

class Texto {
	
	const texto
	
	method peso() = texto.size()
	
	method contiene(text) = texto.contains(text) 
	
}

class Audio {
	
	var duracion
	
	method peso() = 1.2 * duracion
	
	method contiene(texto) = false
	
}

class Imagen {
	
	const alto
	const ancho
	const compresion
	
	method pixeles() = alto * ancho
	
	method peso() = compresion.comprimir(self.pixeles()) * 2
	
	method contiene(texto) = false
	
}

object original {
	
	method comprimir(pixeles) = pixeles
	
}

class Variable {
	
	const porcentajeCompresion
	
	method comprimir(pixeles) = pixeles * porcentajeCompresion
	
}

object maxima {
	
	method comprimir(pixeles) = if(pixeles < 10000) pixeles else 10000
	
}

class Gif inherits Imagen {
	
	const cuadros
	
	override method peso() = super() * cuadros
	
}

class Contacto {
	
	const usuario
	
	method peso() = 3
	
	method contiene(texto) = usuario.contiene(texto)
	
}