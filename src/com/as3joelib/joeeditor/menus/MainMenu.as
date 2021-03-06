package com.as3joelib.joeeditor.menus
{
	import com.as3joelib.joeeditor.JoeEditor;
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
			this.addEventListener(PrimaryMenu.INIT_EXTERNAL_IMAGE, onInitExternalImage);
			this.addEventListener(PrimaryMenu.INIT_WEBCAM, onInitWebcam);
			
			//atento a cuando hagan click en boton de "tomar foto de webcam"
			this.addEventListener(WebcamMenu.WEBCAM_READY, onActionReady);
			//y cambiar al menu de stickers
			this.addEventListener(DrawMenu.DRAW_READY, onActionReady);
			
		}
		
		private function onActionReady(e:Event):void 
		{
			switch(e.type) {
				case DrawMenu.DRAW_READY:
				case WebcamMenu.WEBCAM_READY:
					this.primary_menu.initAction(PrimaryMenu.INIT_STICKERS);
					break;
			}
		}
		
		public function initAction(a:String):void {
			switch(a) {
				case JoeEditor.ACTIVITY_DRAW:
					this.primary_menu.initAction(PrimaryMenu.INIT_DRAW);
					break;
				case JoeEditor.ACTIVITY_STICKERS:
					this.primary_menu.initAction(PrimaryMenu.INIT_STICKERS);
					break;
				case JoeEditor.ACTIVITY_EXTERNAL_IMAGE:
					this.primary_menu.initAction(PrimaryMenu.INIT_EXTERNAL_IMAGE);
					break;
				case JoeEditor.ACTIVITY_WEBCAM:
					this.primary_menu.initAction(PrimaryMenu.INIT_WEBCAM);
					break;
			}
		}

		private function onInitDraw(e:Event):void
		{
			this.secondary_menu.showItem(SecondaryMenu.MENU_DRAW);
		}
		
		private function onInitStickers(e:Event):void
		{
			this.secondary_menu.showItem(SecondaryMenu.MENU_STICKERS);
		}
		
		private function onInitExternalImage(e:Event):void 
		{
			this.secondary_menu.showItem(SecondaryMenu.MENU_EXTERNAL_IMAGE);
		}
		
		private function onInitWebcam(e:Event):void 
		{
			this.secondary_menu.showItem(SecondaryMenu.MENU_WEBCAM);
		}
		
		private function dibujar():void
		{
			this.addChild(this.primary_menu);
			this.primary_menu.x = this.stage.stageWidth - primary_menu.width - 5;
			this.primary_menu.y = 10;
			
			this.addChild(this.secondary_menu);
			this.secondary_menu.x = this.stage.stageWidth - 250;
			this.secondary_menu.y = this.primary_menu.y + this.primary_menu.height + 5;
			
			this.secondary_menu.showItem(SecondaryMenu.MENU_STICKERS);
		}
	}

}