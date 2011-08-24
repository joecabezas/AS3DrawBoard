package board
{
	import com.greensock.loading.ImageLoader;
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
		
		public function BoardItem()
		{
		}
		
		public function generateFromUrl(url:String):void
		{
			this.url = url;
			
			this.setup();
			this.load();
			this.agregarListeners();
			this.dibujar();
		}
		
		public function generateFromDisplayObject(d:DisplayObject):void
		{
			trace(d.width);
			this.img = d;
			
			this.img.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			this.dibujar();
		}
		
		private function setup():void
		{
			this.loader = new ImageLoader(this.url, {centerRegistration: true});
			this.img = this.loader.content;
		}
		
		private function load():void
		{
			this.loader.load();
		}
		
		private function agregarListeners():void
		{
			this.img.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			this.dispatchEvent(new Event(MOUSE_DOWN_BOARD_ITEM, true));
		}
		
		private function dibujar():void
		{
			this.addChild(this.img);
		}
	}
}