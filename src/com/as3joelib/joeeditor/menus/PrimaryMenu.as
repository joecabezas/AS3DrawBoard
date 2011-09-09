package com.as3joelib.joeeditor.menus
{
	import com.bit101.components.RadioButton;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Joe Cabezas
	 */
	public class PrimaryMenu extends Sprite
	{
		//private static const ACTIVITY_GROUP:String = 'activityGroup';
		private static const PINTAR:String = 'Pintar';
		private static const STICKERS:String = 'Stickers';
		private static const IMAGEN_EXTERNA:String = 'Imagen Externa';
		private static const WEBCAM:String = 'Webcam';
		
		//eventos
		public static const INIT_DRAW:String = 'initDraw';
		public static const INIT_STICKERS:String = 'initStickers';
		public static const INIT_EXTERNAL_IMAGE:String = 'initExternalImage';
		public static const INIT_WEBCAM:String = 'initWebcam';
		
		private var radio_button_pintar:RadioButton;
		private var radio_button_stickers:RadioButton;
		private var radio_button_external_image:RadioButton;
		private var radio_button_webcam:RadioButton;
		
		public function PrimaryMenu()
		{
			this.setup();
			this.agregarListeners();
			this.dibujar();
		}
		
		private function setup():void
		{
			this.radio_button_pintar = new RadioButton(this, 0, 0, PINTAR, false, onClickRadioButton);
			this.radio_button_stickers = new RadioButton(this, 0, 0, STICKERS, false, onClickRadioButton);
			this.radio_button_external_image = new RadioButton(this, 0, 0, IMAGEN_EXTERNA, false, onClickRadioButton);
			this.radio_button_webcam = new RadioButton(this, 0, 0, WEBCAM, false, onClickRadioButton);
		}
		
		private function onClickRadioButton(e:Event):void
		{
			
			switch (RadioButton(e.target).label)
			{
				case PINTAR: 
					this.initAction(INIT_DRAW);
					break;
				case STICKERS:
					this.initAction(INIT_STICKERS);
					break;
				case IMAGEN_EXTERNA:
					this.initAction(INIT_EXTERNAL_IMAGE);
					break;
				case WEBCAM:
					this.initAction(INIT_WEBCAM);
					break;
			}
		}
		
		private function agregarListeners():void
		{
		}
		
		public function initAction(a:String):void
		{
			switch (a)
			{
				case INIT_DRAW: 
					this.radio_button_pintar.selected = true;
					this.dispatchEvent(new Event(INIT_DRAW, true));
					break;
				case INIT_STICKERS: 
					this.radio_button_stickers.selected = true;
					this.dispatchEvent(new Event(INIT_STICKERS, true));
					break;
				case INIT_EXTERNAL_IMAGE: 
					this.radio_button_external_image.selected = true;
					this.dispatchEvent(new Event(INIT_EXTERNAL_IMAGE, true));
					break;
				case INIT_WEBCAM: 
					this.radio_button_webcam.selected = true;
					this.dispatchEvent(new Event(INIT_WEBCAM, true));
					break;
			}
		}
		
		private function dibujar():void
		{
			//this.addChild(this.radio_button_pintar);
			//this.addChild(this.radio_button_stickers);
			this.radio_button_stickers.x += 50;
			this.radio_button_stickers.selected = true;
			
			this.radio_button_webcam.x += 105;
			
			this.radio_button_external_image.x = 160;
		}
	}

}