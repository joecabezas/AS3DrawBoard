package menus 
{
	import com.somerandomdude.coordy.layouts.twodee.Grid;
	import com.somerandomdude.coordy.layouts.twodee.ILayout2d;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Joe Cabezas
	 */
	public class StickersMenuCategory extends Sprite 
	{
		//constantes publicas de diseño
		public static const LAYOUT_WIDTH:Number=240+3*2;
		public static const LAYOUT_COLUMNS:Number = 3;
		
		private var nodes:Vector.<StickersMenuCategoryNode>;
		
		//layout
		private var layout:Grid;
		
		//datos de la categoria
		//private var name:String
		
		public function StickersMenuCategory(name:String) 
		{
			this.name = name;
			
			this.setup();
			this.agregarListeners();
			//this.dibujar();
		}
		
		public function addNode(node:StickersMenuCategoryNode):void {
			this.nodes.push(node);
			
			/*this.layout.addNode(node,false);
			this.addChild(node);
			
			//actualizar height del layout
			//trace(node.height);
			this.layout.height = (this.layout.size % LAYOUT_COLUMNS) * node.height + node.height + 7;
			//this.layout.columns = (this.layout.size % LAYOUT_COLUMNS) + 1;
			
			//update layout
			this.layout.updateAndRender();*/
		}
		
		public function updateAndRender():void 
		{
			var node_height:Number = this.nodes[this.nodes.length - 1].height;
			var rows_number:Number = Math.ceil(this.nodes.length / LAYOUT_COLUMNS);
			var layout_height:Number =  rows_number * node_height + 7;
			
			this.layout = new Grid(LAYOUT_WIDTH, layout_height, LAYOUT_COLUMNS, rows_number);
			
			this.dibujar();
		}
		
		private function setup():void 
		{
			this.nodes = new Vector.<StickersMenuCategoryNode>;
			//this.layout = new Grid(LAYOUT_WIDTH, LAYOUT_WIDTH, LAYOUT_COLUMNS, 3);
		}
		
		private function agregarListeners():void 
		{
			
		}
		
		private function dibujar():void 
		{
			//trace('StickerMenuCategory.dibujar'+this.nodes);
			for each(var node:StickersMenuCategoryNode in this.nodes) {
				this.layout.addNode(node);
				this.addChild(node);
			}
		}
		
	}

}