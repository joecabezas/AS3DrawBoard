package menus
{
	import com.as3joelib.ui.UISwitcher;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Joe Cabezas
	 */
	public class SecondaryMenu extends Sprite
	{
		//constantes de los elementos
		public static const MENU_STICKER:int = 0;
		public static const MENU_DRAW:int = 1;
		
		//elementos
		private var menu_stickers:StickersMenu;
		private var menu_draw:DrawMenu;
		
		private var switcher:UISwitcher;
		
		public function SecondaryMenu()
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
			this.menu_stickers = new StickersMenu('../assets/data.json');
			this.menu_draw = new DrawMenu();
			
			this.switcher = new UISwitcher();
			
			this.switcher.addItem(this.menu_stickers);
			this.switcher.addItem(this.menu_draw);
			
			this.switcher.hideAllItems();
		}
		
		private function agregarListeners():void
		{
		
		}
		
		public function showItem(s:int):void {
			this.switcher.switchTo(s);
		}
		
		private function dibujar():void
		{
			this.addChild(this.menu_stickers);
			this.addChild(this.menu_draw);
		}
	
	}

}