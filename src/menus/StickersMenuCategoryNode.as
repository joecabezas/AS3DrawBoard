package menus 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Joe Cabezas
	 */
	public class StickersMenuCategoryNode extends Sprite 
	{
		//constantes de eventos
		public static const CLICK_STICKER_NODE:String = 'clickStickerNode';
		
		//private var name:String;
		private var img:Sprite;
		private var _url:String
		
		public function StickersMenuCategoryNode(name:String, img:Sprite, url:String) 
		{
			this.name = name;
			this.img = img;
			this._url = url;
			
			this.setup();
			this.agregarListeners();
			this.dibujar();
		}
		
		private function setup():void 
		{
			
		}
		
		private function agregarListeners():void 
		{
			this.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick(e:MouseEvent):void 
		{
			//trace((e.target as Sprite).name);
			this.dispatchEvent(new Event(CLICK_STICKER_NODE, true));
		}
		
		private function dibujar():void 
		{
			//trace('StickerMenuCategoryNode.dibujar'+this.img);
			this.addChild(this.img);
		}
		
		public function get url():String 
		{
			return _url;
		}
		
	}

}