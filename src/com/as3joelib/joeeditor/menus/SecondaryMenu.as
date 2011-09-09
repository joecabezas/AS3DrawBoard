package com.as3joelib.joeeditor.menus
{
	import com.as3joelib.ui.UISwitcher;
	import com.as3joelib.utils.Singleton;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Joe Cabezas
	 */
	public class SecondaryMenu extends Sprite
	{
		//constantes de los elementos
		public static const MENU_STICKERS:String = 'menuStickers';
		public static const MENU_DRAW:String = 'menuDraw';
		public static const MENU_EXTERNAL_IMAGE:String = 'menuWebcam';
		public static const MENU_WEBCAM:String = 'menuWebcam';
		
		//elementos
		private var menu_stickers:StickersMenu;
		private var menu_draw:DrawMenu;
		private var menu_external_image:ExternalImageMenu;
		private var menu_webcam:WebcamMenu;
		
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
			this.menu_stickers = new StickersMenu(Singleton.getInstance().data.joeeditor_stickers_json_url);
			this.menu_draw = new DrawMenu();
			this.menu_external_image = new ExternalImageMenu();
			this.menu_webcam = new WebcamMenu();
			
			this.switcher = new UISwitcher();
			
			this.switcher.addItem(this.menu_stickers);
			this.switcher.addItem(this.menu_draw);
			this.switcher.addItem(this.menu_external_image);
			this.switcher.addItem(this.menu_webcam);
			
			this.switcher.hideAllItems();
		}
		
		private function agregarListeners():void
		{
		
		}
		
		public function showItem(s:String):void {
			switch(s) {
				case MENU_STICKERS:
					this.switcher.switchTo(this.menu_stickers);	
					break;
				case MENU_DRAW:
					this.switcher.switchTo(this.menu_draw);
					break;
				case MENU_EXTERNAL_IMAGE:
					this.switcher.switchTo(this.menu_external_image);
					this.menu_external_image.setFocus();
					break;
				case MENU_WEBCAM:
					this.switcher.switchTo(this.menu_webcam);
					break;
			}
		}
		
		private function dibujar():void
		{
			this.addChild(this.menu_stickers);
			this.addChild(this.menu_draw);
			this.addChild(this.menu_external_image);
			this.addChild(this.menu_webcam);
		}
	
	}

}