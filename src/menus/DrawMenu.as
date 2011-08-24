package menus
{
	import com.bit101.components.ColorChooser;
	import com.bit101.components.HBox;
	import com.bit101.components.HSlider;
	import com.bit101.components.PushButton;
	import com.bit101.components.ScrollBar;
	import com.bit101.components.Slider;
	import com.bit101.components.VBox;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Joe Cabezas
	 */
	public class DrawMenu extends Sprite
	{
		//eventos
		public static const CHANGE_COLOR:String = 'changeColor';
		public static const CHANGE_TICKNESS:String = 'changeTickness';
		
		private var vbox:VBox;
		
		private var scrollbar:HSlider;
		private var color_pick:ColorChooser;
		
		//variables configurables en este menu
		private var _tickness:Number;
		private var _color:uint;
		
		public function DrawMenu()
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
			this.vbox = new VBox(this, 0, 0);
			
			this.scrollbar = new HSlider(this.vbox, 0, 0, onHslider);
			this.color_pick = new ColorChooser(this.vbox, 0, 0, 0x31335e, onColorChooser);
			this.color_pick.usePopup = true;
		}
		
		private function onColorChooser(e:Event):void 
		{
			//trace(e);
			this._color = ColorChooser(e.target).value;
			this.dispatchEvent(new Event(CHANGE_COLOR, true));
		}
		
		private function onHslider(e:Event):void 
		{
			this._tickness = HSlider(e.target).value;
			this.dispatchEvent(new Event(CHANGE_TICKNESS, true));
		}
		
		private function agregarListeners():void
		{
		
		}
		
		private function dibujar():void
		{
			//this.addChild(this.vbox);
			//this.addChild(this.color_pick);
			//this.color_pick.y = 0;
		}
		
		public function get color():uint 
		{
			return _color;
		}
		
		public function get tickness():Number 
		{
			return _tickness;
		}
	
	}

}