package com.as3joelib.joeeditor.menus
{
	import com.bit101.components.PushButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author ...
	 */
	public class WebcamMenu extends Sprite
	{
		//eventos
		public static const WEBCAM_READY:String = 'webCamReady';
		
		//ui
		private var btn_apply:PushButton;
		
		public function WebcamMenu()
		{
			this.setup();
			this.agregarListeners();
			this.dibujar();
		}
		
		private function setup():void
		{
			this.btn_apply = new PushButton(this, 0, 0, 'Listo', onApplyButtonClick);
		}
		
		private function onApplyButtonClick(e:MouseEvent):void
		{
			trace('WebcamMenu.onApplyButtonClick');
			this.dispatchEvent(new Event(WEBCAM_READY, true));
		}
		
		private function agregarListeners():void
		{
			//this.btn_apply.addEventListener(MouseEvent.CLICK, onApplyButtonClick);
		}
		
		private function dibujar():void
		{
		
		}
	}

}