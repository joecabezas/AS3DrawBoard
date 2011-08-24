package menus
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
		private static const ACTIVITY_GROUP:String = 'activityGroup';
		private static const PINTAR:String = 'Pintar';
		private static const STICKERS:String = 'Stickers';
		
		//eventos
		public static const INIT_DRAW:String = 'initDraw';
		public static const INIT_STICKERS:String = 'initStickers';
		
		private var radio_button_pintar:RadioButton;
		private var radio_button_stickers:RadioButton;
		
		public function PrimaryMenu()
		{
			this.setup();
			this.agregarListeners();
			this.dibujar();
		}
		
		private function setup():void
		{			
			this.radio_button_pintar = new RadioButton(this, 0, 0, PINTAR, false, onClickRadioButton);
			this.radio_button_stickers = new RadioButton(this, 0, 0, STICKERS, true, onClickRadioButton);
		}
		
		private function onClickRadioButton(e:Event):void 
		{
			switch(RadioButton(e.target).label) {
				case PINTAR:
					this.dispatchEvent(new Event(INIT_DRAW,true));
					break;
				case STICKERS:
					this.dispatchEvent(new Event(INIT_STICKERS,true));
					break;
			}
		}
		
		private function agregarListeners():void
		{
		}
		
		private function dibujar():void
		{
			this.addChild(this.radio_button_pintar);
			this.addChild(this.radio_button_stickers);
			this.radio_button_stickers.x += 50;
		}
	}

}