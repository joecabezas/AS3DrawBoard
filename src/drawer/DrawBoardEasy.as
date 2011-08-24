package drawer
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Joe Cabezas
	 */
	
	//Drawing board class, port to AS3
	//original idea (AS2) from:
	//http://www.kirupa.com/forum/showthread.php?40686-Flash-Drawing-Board-(MX)
	
	public class DrawBoardEasy extends Sprite
	{
		//are we drawing?
		private var is_drawing:Boolean;
		
		//points array
		private var points:Array;
		
		//draw container
		private var draw_container:Sprite;
		
		//draw board area		
		private var _rect:Rectangle;
		
		//pen properties
		private var _tickness:Number;
		private var _color:uint;
		
		public function DrawBoardEasy()
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
			this.addListeners();
			this.draw();
		}
		
		private function setup():void
		{
			//hey! setup-time!, we are not drawing :)
			this.is_drawing = false;
			
			//instantiating the container
			this.draw_container = new Sprite();
			
			//setting the rect
			if (this.rect == null)
			{
				this.rect = new Rectangle(0, 0, 520, 480);
			}
			
			//setting the default pen style
			this.tickness = 7;
			this.color = 0x31335e;
			
			this.beginDraw();
		}
		
		public function beginDraw():void
		{
			this.draw_container.graphics.lineStyle(this.tickness, this.color);
		}
		
		private function addListeners():void
		{
			this.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onMouseMove(e:MouseEvent):void
		{
			//if we are not drawing, do nothing
			if (!this.is_drawing)
				return;
			
			//if we are outside of the drawing limits (drawing area), stop drawing
			if (this.isInsideArea())
			{
				//adding to the array the actual mouse position
				this.points.push(new Array(mouseX, mouseY));
				this.smooth();
			}
			else
			{
				//reseting the array
				this.points = new Array();
				
				//move the cursor of the drawing API
				//to the actual mouse position
				this.draw_container.graphics.moveTo(mouseX, mouseY);
				
				this.smooth();
			}
		
		}
		
		private function onMouseUp(e:MouseEvent):void
		{
			//ok we're done, no more drawing
			this.is_drawing = false;
			
			//smooth the rest of the points
			this.smooth();
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			//reseting the array
			this.points = new Array();
			
			//activating the drawing mode
			this.is_drawing = true;
			
			//adding to the array the actual mouse position
			this.points.push(new Array(mouseX, mouseY));
			
			//move the cursor of the drawing API
			//to the actual mouse position
			this.draw_container.graphics.moveTo(mouseX, mouseY);
		}
		
		private function smooth():void
		{
			//if there is no points instantiated, do nothing
			if (!this.points)
				return;
			
			var i:int = this.points.length - 1;
			
			//we need at least 1 point, if not, do nothing
			if (i < 1)
				return;
			
			//the magic beings
			var ptx:Number = points[i][0];
			var pty:Number = points[i][1];
			
			var ancx:Number = this.points[i - 1][0];
			var ancy:Number = this.points[i - 1][1];
			
			ptx += ancx;
			pty += ancy;
			
			this.draw_container.graphics.curveTo(ancx, ancy, ptx / 2, pty / 2);
		}
		
		public function erase():void
		{
			this.draw_container.graphics.clear();
		}
		
		private function isInsideArea():Boolean
		{
			if ((this.rect.left <= mouseX) && (mouseX <= this.rect.right) && (this.rect.top <= mouseY) && (mouseY <= this.rect.bottom))
			{
				return true;
			}
			return false;
		}
		
		public function get rect():Rectangle
		{
			return _rect;
		}
		
		public function set rect(value:Rectangle):void
		{
			_rect = value;
		
		/*this.draw_container.graphics.clear();
		   this.draw_container.graphics.beginFill(0, 0.05);
		   this.draw_container.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
		 this.draw_container.graphics.endFill();*/
		
		}
		
		public function get tickness():Number
		{
			return _tickness;
		}
		
		public function set tickness(value:Number):void
		{
			_tickness = value;
			this.draw_container.graphics.lineStyle(this.tickness, this.color);
		}
		
		public function get color():uint
		{
			return _color;
		}
		
		public function set color(value:uint):void
		{
			_color = value;
			this.draw_container.graphics.lineStyle(this.tickness, this.color);
		}
		
		/*private function setRegPoint(obj:DisplayObjectContainer, newX:Number, newY:Number):void
		   {
		   //get the bounds of the object and the location
		   //of the current registration point in relation
		   //to the upper left corner of the graphical content
		   //note: this is a PSEUDO currentRegX and currentRegY, as the
		   //registration point of a display object is ALWAYS (0, 0):
		   var bounds:Rectangle = obj.getBounds(obj.parent);
		   var currentRegX:Number = obj.x - bounds.left;
		   var currentRegY:Number = obj.y - bounds.top;
		
		   var xOffset:Number = newX - currentRegX;
		   var yOffset:Number = newY - currentRegY;
		   //shift the object to its new location--
		   //this will put it back in the same position
		   //where it started (that is, VISUALLY anyway):
		   obj.x += xOffset;
		   obj.y += yOffset;
		
		   //shift all the children the same amount,
		   //but in the opposite direction
		   for (var i:int = 0; i < obj.numChildren; i++)
		   {
		   obj.getChildAt(i).x -= xOffset;
		   obj.getChildAt(i).y -= yOffset;
		   }
		 }*/

		public function getDraw():DisplayObject
		{			
			var sp:Sprite = new Sprite();
			sp.graphics.copyFrom(this.draw_container.graphics);

			return sp;
		}
		
		private function draw():void
		{
			this.addChild(this.draw_container);
		}
	}
}