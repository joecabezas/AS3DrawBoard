package menus
{
	import com.as3joelib.ui.UISwitcher;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Joe Cabezas
	 */
	public class MainMenu extends Sprite
	{
		private var primary_menu:PrimaryMenu;
		private var secondary_menu:SecondaryMenu;
		
		public function MainMenu()
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
			this.primary_menu = new PrimaryMenu();
			this.secondary_menu = new SecondaryMenu();
		}
		
		private function agregarListeners():void
		{
			this.addEventListener(PrimaryMenu.INIT_DRAW, onInitDraw);
			this.addEventListener(PrimaryMenu.INIT_STICKERS, onInitStickers);
		}
		
		private function onInitDraw(e:Event):void
		{
			this.secondary_menu.showItem(SecondaryMenu.MENU_DRAW);
		}
		
		private function onInitStickers(e:Event):void
		{
			this.secondary_menu.showItem(SecondaryMenu.MENU_STICKER);
		}
		
		private function dibujar():void
		{
			this.addChild(this.primary_menu);
			this.primary_menu.x = this.stage.stageWidth - primary_menu.width - 50;
			this.primary_menu.y = 10;
			
			this.addChild(this.secondary_menu);
			this.secondary_menu.x = this.stage.stageWidth - 250;
			this.secondary_menu.y = this.primary_menu.y + this.primary_menu.height + 5;
			
			this.secondary_menu.showItem(SecondaryMenu.MENU_STICKER);
		}
	
	}

}