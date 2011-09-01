package com.as3joelib.joeeditor.board
{
	import com.greensock.loading.ImageLoader;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Joe Cabezas
	 */
	public class BoardItem extends Sprite
	{
		//constantes de eventos
		public static const MOUSE_DOWN_BOARD_ITEM:String = 'mouseDownBoardItem';
		
		private var url:String;
		private var loader:ImageLoader;
		private var img:DisplayObject;
		
		//tamaños deseados si es que el board item debe ser cargado desde una url
		private var width_desired:Number;
		private var height_desired:Number;
		
		public function BoardItem()
		{
		}
		
		public function generateFromUrl(url:String, w:Number=0, h:Number=0):void
		{
			this.url = url;
			this.width_desired = w;
			this.height_desired = h;
			
			this.setup();
			this.load();
			this.agregarListeners();
			this.dibujar();
		}
		
		public function generateFromDisplayObject(d:DisplayObject):void
		{			
			//si recibimos un objeto que no se ve
			//osea de tamaño cero (dibujo vacio por ejemplo)
			if ((d.width <= 0) && (d.height <= 0))
				return;
			
			this.img = d;
			
			this.agregarListeners();
			this.dibujar();
		}
		
		public function getBitmapData():BitmapData 
		{
			var bmpd:BitmapData = new BitmapData(this.img.width, this.img.height, false);
			bmpd.draw(this.img);
			
			return bmpd;
		}
		
		private function setup():void
		{
			trace('BoardItem.setup');
			trace(this.width_desired);
			trace(this.height_desired);
			this.loader = new ImageLoader(this.url, {centerRegistration: true, width:this.width_desired, height:this.height_desired});
			this.img = this.loader.content;
		}
		
		private function load():void
		{
			this.loader.load();
		}
		
		private function agregarListeners():void
		{
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			trace('BoardItem.onMouseDown');
			this.dispatchEvent(new Event(MOUSE_DOWN_BOARD_ITEM, true));
		}
		
		private function dibujar():void
		{
			this.addChild(this.img);
		}
	}
}