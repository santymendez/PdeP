class Notificacion {
	
	const property chat
	var property leida = false
	
	method leer(){
		leida = true
	}
}

class Chat {
	
	const property mensajes = []
	const participantes = []
	
	method espacioOcupado() = mensajes.sum({m => m.pesoMensaje()})
	
	method puedeEnviar(mensaje) = participantes.contains(mensaje.emisor()) && participantes.all({p => p.tieneEspacio()})
	
	method enviar(mensaje){
		if (self.puedeEnviar(mensaje)){ 
			mensajes.add(mensaje)
			self.notificar()
		}
		else 
			throw new DomainException(message = "No se puede enviar el mensaje")
	}
	
	method contiene(texto) = mensajes.any({mensaje => mensaje.contiene(texto)})
	
	method mensajeMasPesado() = mensajes.max({mensaje => mensaje.pesoMensaje()})
	
	method notificar() = participantes.forEach({p => p.recibirNotificacion(new Notificacion(chat = self))})
	
}

class ChatPremium inherits Chat {
	
	const creador
	const restriccion
	
	override method puedeEnviar(mensaje) = super(mensaje) && restriccion.puedeEnviar(mensaje, creador)
	
}

object difusion {
	
	method puedeEnviar(mensaje, creador) = mensaje.emisor() == creador
	
}

class Ahorro {
	
	var pesoMaximo
	
	method puedeEnviar(mensaje, creador) = mensaje.peso() < pesoMaximo	
	
}