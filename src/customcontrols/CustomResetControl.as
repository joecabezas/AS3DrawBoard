package customcontrols{
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import com.senocular.display.TransformTool;
	import com.senocular.display.TransformToolControl;
	import com.senocular.display.TransformToolCursor;
	
	public class CustomResetControl extends TransformToolControl {
		
		public function CustomResetControl() {
			addEventListener(TransformTool.CONTROL_INIT, init, false, 0, true);
			
			this.dibujar();
		}
		
		private function dibujar():void 
		{
			var c:Circle = new Circle(7);
			this.addChild(c);
			
			c.x = c.width;
			c.y = -c.x + 2 + c.height;
		}
		
		private function init(event:Event):void {
			
			// add event listeners 
			transformTool.addEventListener(TransformTool.NEW_TARGET, update, false, 0, true);
			transformTool.addEventListener(TransformTool.TRANSFORM_TOOL, update, false, 0, true);
			transformTool.addEventListener(TransformTool.CONTROL_TRANSFORM_TOOL, update, false, 0, true);
			addEventListener(MouseEvent.CLICK, resetClick);
			
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
		
		private function resetClick(event:MouseEvent):void {
			
			// reset the matrix but keep the current location by 
			// noting the change in the registration point
			var origReg:Point = transformTool.registration;
			
			// global matrix as a default matrix (identity)
			transformTool.globalMatrix = new Matrix();
			
			// find change in positioning based on registration
			// Note: registration location is based within
			// the coordinate space of the tool (not global)
			var regDiff:Point = origReg.subtract(transformTool.registration);
			
			// update the tool matrix with the change in position
			// offsetting movement from the new matrix to have
			// the old and new registration points match
			var toolMatrix:Matrix = transformTool.toolMatrix;
			toolMatrix.tx += regDiff.x;
			toolMatrix.ty += regDiff.y;
			transformTool.toolMatrix = toolMatrix;
			
			// apply the new matrix to the target
			transformTool.apply();
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