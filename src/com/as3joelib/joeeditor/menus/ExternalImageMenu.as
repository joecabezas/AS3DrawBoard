package com.as3joelib.joeeditor.menus
{
	import com.bit101.components.InputText;
	import com.bit101.components.PushButton;
	import com.bit101.components.VBox;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Joe Cabezas
	 */
	public class ExternalImageMenu extends Sprite
	{
		//eventos
		public static const CLICK_EXTERNAL_IMAGE_BUTTON:String = 'clickExternalImagePushButton';
		
		//ui
		private var textfield:InputText
		private var button:PushButton
		
		private var layout:VBox;
		
		public function ExternalImageMenu()
		{
			this.setup();
			this.agregarListeners();
			this.dibujar();
		}
		
		private function setup():void
		{
			this.layout = new VBox(this);
			
			this.textfield = new InputText(this.layout);
			this.textfield.setSize(245,this.textfield.height);
			this.button = new PushButton(this.layout, 0, 0, 'Agregar Imagen', onClickButton);
		}
		
		private function onClickButton(e:MouseEvent):void 
		{
			//trace(this.textfield.text);
			this.dispatchEvent(new Event(CLICK_EXTERNAL_IMAGE_BUTTON, true));
		}
		
		private function agregarListeners():void
		{
		}
		
		private function dibujar():void
		{
		}
		
		public function setFocus():void {
			this.stage.focus = this.textfield.textField;
		}
		
		public function get external_url():String 
		{
			return this.textfield.textField.text;
		}
	
	}

}