package com.as3joelib.joeeditor.customcontrols{
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import com.senocular.display.TransformTool;
	import com.senocular.display.TransformToolControl;
	import com.senocular.display.TransformToolCursor;
	
	public class CustomRemoveControl extends TransformToolControl {
		
		//eventos
		public static const CLICK_REMOVE_CONTROL:String = 'clickRemoveControl';
		
		public function CustomRemoveControl() {
			addEventListener(TransformTool.CONTROL_INIT, init, false, 0, true);
			
			this.dibujar();
		}
		
		private function dibujar():void 
		{
			var c:Circle = new Circle(7);
			this.addChild(c);
			
			c.x = c.width;
			c.y = -c.x;
		}
		
		private function init(event:Event):void {
			
			// add event listeners 
			transformTool.addEventListener(TransformTool.NEW_TARGET, update, false, 0, true);
			transformTool.addEventListener(TransformTool.TRANSFORM_TOOL, update, false, 0, true);
			transformTool.addEventListener(TransformTool.CONTROL_TRANSFORM_TOOL, update, false, 0, true);
			addEventListener(MouseEvent.CLICK, onClick);
			
			// initial positioning
			update();
		}
		
		private function update(event:Event = null):void {
			if (transformTool.target) {
				// find to top right of selection
				var maxX:Number = Math.max(transformTool.boundsTopLeft.x, transformTool.boundsTopRight.x);
				maxX = Math.max(maxX, transformTool.boundsBottomRight.x);
				maxX = Math.max(maxX, transformTool.boundsBottomLeft.x);
				
				var minY:Number = Math.min(transformTool.boundsTopLeft.y, transformTool.boundsTopRight.y);
				minY = Math.min(minY, transformTool.boundsBottomRight.y);
				minY = Math.min(minY, transformTool.boundsBottomLeft.y);
				
				// set location to found values
				x = maxX;
				y = minY;
			}
		}
		
		private function onClick(event:MouseEvent):void {
			
			this.dispatchEvent(new Event(CLICK_REMOVE_CONTROL, true));
		}
	}
}

import flash.display.Shape;

internal class Circle extends Shape
{
	public function Circle(radius:Number)
	{
		graphics.lineStyle(1, 0x5d504f);
		graphics.beginFill(0xded3d1, .75);
		graphics.drawCircle(0, 0, radius);
		graphics.endFill();
		graphics.lineStyle(1, 0x5d504f);
		graphics.moveTo(0, 0);
		graphics.lineTo(0, radius);
	}
}