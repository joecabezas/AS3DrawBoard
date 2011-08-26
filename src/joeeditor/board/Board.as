package joeeditor.board
{
	import com.senocular.display.TransformTool;
	import joeeditor.customcontrols.CustomRemoveControl;
	import joeeditor.customcontrols.CustomResetControl;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Joe Cabezas
	 */
	public class Board extends Sprite
	{
		private var items:Vector.<BoardItem>;
		
		//transformtool
		private var tool:TransformTool;
		
		//indica si este Board tiene la
		//transform tool activada o no
		private var is_tool_enabled:Boolean;
		
		public function Board()
		{
			
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			this.setup();
			this.setupTransformTool();
			this.agregarListeners();
			this.dibujar();
		}
		
		private function setupTransformTool():void
		{
			//var tt:TransformTool = new TransformTool();
			//this.addChild(tt);
			//tt.target = c;
			
			this.tool.raiseNewTargets = true;
			//this.tool.moveNewTargets = true;
			this.tool.moveUnderObjects = false;
			
			this.tool.registrationEnabled = true;
			this.tool.rememberRegistration = false;
			
			this.tool.rotationEnabled = true;
			//this.tool.constrainRotation = true;
			//this.tool.constrainRotationAngle = 90 / 4;
			
			this.tool.constrainScale = true;
			//this.tool.maxScaleX = 2;
			//this.tool.maxScaleY = 2;
			
			this.tool.moveEnabled = true;
			
			//this.tool.skewEnabled = false;
			
			/*this.tool.setSkin(TransformTool.SCALE_TOP_LEFT, new Circle(5));
			   this.tool.setSkin(TransformTool.SCALE_TOP_RIGHT, new Circle(5));
			   this.tool.setSkin(TransformTool.SCALE_BOTTOM_RIGHT, new Circle(5));
			   this.tool.setSkin(TransformTool.SCALE_BOTTOM_LEFT, new Circle(5));
			   this.tool.setSkin(TransformTool.SCALE_TOP, new Circle(5));
			   this.tool.setSkin(TransformTool.SCALE_RIGHT, new Circle(5));
			   this.tool.setSkin(TransformTool.SCALE_BOTTOM, new Circle(5));
			 this.tool.setSkin(TransformTool.SCALE_LEFT, new Circle(5));*/
			
			//this.tool.addControl(new CustomRotationControl());
			this.tool.addControl(new CustomResetControl());
			this.tool.addControl(new CustomRemoveControl());
			//this.tool.addControl(new CustomMoveControl());
		}
		
		public function addItem(i:BoardItem, centered:Boolean = false):void
		{
			trace('Board.addItem');
			trace(i.width);
			trace(i.height);
			
			//si recibimos un objeto que no se ve
			//osea de tamaño cero (dibujo vacio por ejemplo)
			if ((i.width <= 0) && (i.height <= 0))
				return;
			
			this.items.push(i);
			this.addChild(i);
			
			if (centered)
			{
				i.x = i.width / 2 + 100;
				i.y = i.height / 2 + 100;
			}
			//i.x = this.mouseX;
			//i.y = this.mouseY;
			
			//activar a este nuevo elemento el tool
			this.updateTarget(i);
		}
		
		private function setup():void
		{
			this.items = new Vector.<BoardItem>;
			this.tool = new TransformTool();
			this.disableTool();
		}
		
		private function agregarListeners():void
		{
			//atento a cuando hagan click en ningun sticker
			this.stage.addEventListener(MouseEvent.CLICK, onClick);
			
			this.addEventListener(BoardItem.MOUSE_DOWN_BOARD_ITEM, onClickBoardItem);
			
			//atento a cuando quieran remover un sticker
			this.addEventListener(CustomRemoveControl.CLICK_REMOVE_CONTROL, onClickRemoveItem);
		}
		
		private function onClick(e:MouseEvent):void
		{
			trace('Board.onClick');
			if (e.target == this.stage) {
				this.selectNone();
			}
		}
		
		private function onClickRemoveItem(e:Event):void
		{
			//trace(CustomRemoveControl(e.target).transformTool.target);
			var bi:BoardItem = CustomRemoveControl(e.target).transformTool.target as BoardItem
			
			//falta updatear el vector!! (que pensandolo bien, no hace nada entrete)
			if (this.contains(bi))
			{
				this.removeChild(bi);
				this.tool.target = null;
			}
		}
		
		private function onClickBoardItem(e:Event):void
		{
		trace('Board.onClickBoardItem');
		trace(this.is_tool_enabled);
			if (!this.is_tool_enabled)
				return;
			
			this.updateTarget(e.target as BoardItem);
		}
		
		private function updateTarget(bi:BoardItem):void
		{
			if (this.contains(this.tool) && this.tool)
			{
				//this.removeChild(this.tool);
			}
			//this.addChild(this.tool);
			
			this.tool.target = bi;
			this.tool.registration = this.tool.boundsCenter;
		}
		
		public function selectNone():void
		{
			this.tool.target = null;
		}
		
		public function enableTool():void
		{
			trace('Board.enableTool');
			this.is_tool_enabled = true;
		}
		
		public function disableTool():void
		{
			trace('Board.disableTool');
			this.is_tool_enabled = false;
		}
		
		private function dibujar():void
		{
			this.addChild(this.tool);
		}
	
	}

}

import flash.display.Shape;

internal class Circle extends Shape
{
	public function Circle(radius:Number)
	{
		graphics.lineStyle(1, 0x5d504f);
		graphics.beginFill(0xffd3d1, .75);
		graphics.drawCircle(0, 0, radius);
		graphics.endFill();
		graphics.lineStyle(1, 0x5d504f);
		graphics.moveTo(0, 0);
		graphics.lineTo(0, radius);
	}
}