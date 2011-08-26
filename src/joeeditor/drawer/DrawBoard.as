package joeeditor.drawer
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import smooth.Canvas;
	
	/**
	 * ...
	 * @author Joe Cabezas
	 */
	public class DrawBoard extends Sprite
	{
		private var target:Stage;
		
		//Are we drawing or not?
		private var drawing:Boolean;
		
		private var draw_container:Sprite;
		
		//contenedor del dibujo
		private var canvas:Canvas;
		
		public function DrawBoard()
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			this.setup();
			this.agregarListeners();
			this.dibujar();
		}
		
		private function setup():void
		{
			drawing = false; //to start with
			this.draw_container = new Sprite();
			this.draw_container.graphics.lineStyle(5, 0xff0000);
			
			//canvas
			this.canvas = new Canvas();
			this.canvas.rect = new Rectangle(0, 0, 540, 500);
			this.canvas.smoothDistance = 50;
			this.canvas.smoothTolerance = 1;
			this.canvas.thickness = 5
		}
		
		private function agregarListeners():void
		{
		}
		
		private function dibujar():void
		{
			//this.addChild(this.draw_container);
			
			this.addChild(this.canvas.container);
		}
	
	}

}