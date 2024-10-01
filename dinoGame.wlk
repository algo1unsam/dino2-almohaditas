import wollok.game.*

const velocidad = 250

object juego{

	method configurar(){
		game.width(12)
		game.height(8)
		game.title("Dino Game")
		game.boardGround("fondo3.png")
		game.addVisual(suelo)
		game.addVisual(cactus)
		game.addVisual(dino)
		game.addVisual(reloj)
	
		keyboard.up().onPressDo({dino.saltar()})
		keyboard.space().onPressDo{ self.jugar()}
		game.onCollideDo(dino,{ obstaculo => obstaculo.chocar(dino)})
		
	} 
	
	method iniciar(){
		dino.iniciar()
		reloj.iniciar()
		cactus.iniciar()
	}
	
	method jugar(){
		if (dino.estaVivo()) 
			dino.saltar()
		else {
			game.removeVisual(gameOver)
			self.iniciar()
		}
		
	}
	
	method terminar(){
		game.addVisual(gameOver)
		cactus.detener()
		reloj.detener()
		dino.morir()
	}
	
}

object gameOver {
	method position() = game.center()
	method text() = "GAME OVER"
}

object reloj {
	var property tiempo = 0 
	method text() = tiempo.toString()
  	method textColor() = "00FF00FF"
	method position() = game.at(1, game.height()-1)
	
	method pasarTiempo() {
		if (!self.detener()){
			tiempo+=1
		}
	}
	method iniciar(){
		tiempo = 0

		game.onTick(1000,"tiempo",{self.pasarTiempo()})
	}
	method detener() = cactus.position() == dino.position()
}

object cactus {
	var property position = self.posicionInicial()

	method image() = "cactus.png"
	method posicionInicial() = game.at(game.width()-1,suelo.position().y())

	method iniciar(){
		position = self.posicionInicial()
		game.onTick(velocidad,"moverCactus",{self.mover()})
	}
	
	method mover(){
		if (!self.detener()){
			position = position.left(1)
		}
	}
	
	method chocar(dino){
		game.schedule(1000, {juego.terminar()})
	}

    method detener() = self.position() == dino.position() 
}

object suelo{
	method position() = game.origin().up(1)
	method image() = "suelo.png"
}


object dino {
	var vivo = true
	var property position = game.at(1,suelo.position().y())
	
	method image() = "dino.png"
	
	method saltar(){
		game.schedule(velocidad, {self.subir()})
		game.schedule(1000, {self.bajar()})
	}
	
	method subir(){
		position = position.up(1)
	}
	
	method bajar(){
		position = position.down(1)
	}
	method morir(){
		game.say(self,"¡Auch!")
		vivo = false
	}
	method iniciar() {
		vivo = true
	}
	method estaVivo() {
		return vivo
	}
}
