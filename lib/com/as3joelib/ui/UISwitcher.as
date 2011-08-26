package com.as3joelib.ui
{
	import com.greensock.TweenLite;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Joe Cabezas
	 */
	public class UISwitcher
	{
		static public const DURATION:Number = 0.3;
		static public const OFFSET_Y:Number = 10;
		
		private var items:Vector.<DisplayObjectContainer>
		
		private var item_actual_index:int;
		
		private var origin:Point;
		
		public function UISwitcher()
		{
			this.setup();
			this.agregarListeners();
			this.dibujar();
		}
		
		private function setup():void
		{
			this.items = new Vector.<DisplayObjectContainer>;
			this.origin = new Point(0, 0);
		}
		
		private function agregarListeners():void
		{
		
		}
		
		public function addItem(i:DisplayObjectContainer):void {
			i.mouseEnabled = false;
			i.mouseChildren = false;
			this.items.push(i);
			this.item_actual_index = this.items.length - 1;
		}
		
		public function hideAllItems():void {
			for each(var i:DisplayObjectContainer in this.items) {
				i.mouseEnabled = false;
				i.mouseChildren = false;
				TweenLite.to(i, 0, {y:this.origin.y, alpha:0} );
			}
		}
		
		public function switchTo(index:uint):void {
			this.hideItem(this.item_actual_index);
			this.showItem(index);
			
			this.item_actual_index = index;
		}
		
		private function hideItem(index:uint):void 
		{
			this.items[index].mouseEnabled = false;
			this.items[index].mouseChildren = false;
			TweenLite.to(this.items[index], DURATION, {y:this.origin.y + OFFSET_Y, alpha:0} );
		}
		
		private function showItem(index:uint):void 
		{
			this.items[index].mouseEnabled = true;
			this.items[index].mouseChildren = true;
			TweenLite.to(this.items[index], DURATION, {y:this.origin.y, alpha:1} );
		}
		
		private function dibujar():void
		{
		}	
	}

}