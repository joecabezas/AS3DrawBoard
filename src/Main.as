package
{
	import board.BoardItem;
	import com.bit101.components.HSlider;
	import com.senocular.display.TransformTool;
	import customcontrols.CustomMoveControl;
	import customcontrols.CustomResetControl;
	import drawer.DrawBoard;
	import drawer.DrawBoardEasy;
	import flash.display.Sprite;
	import flash.events.Event;
	import menus.DrawMenu;
	import menus.MainMenu;
	import menus.PrimaryMenu;
	import menus.StickersMenu;
	import menus.StickersMenuCategory;
	import board.Board;
	import menus.StickersMenuCategoryNode;
	
	/**
	 * ...
	 * @author Joe Cabezas
	 */
	[SWF(backgroundColor='#ffffff',frameRate='30')]
	[Frame(factoryClass="Preloader")]
	
	public class Main extends Sprite
	{
		//menus
		private var main_menu:MainMenu;
		
		//board
		private var main_board:Board;
		
		//drawboard
		private var draw_board:DrawBoardEasy;
		
		public function Main():void
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
			this.agregarListeners();
			this.dibujar();
		}
		
		private function setup():void
		{
			this.main_menu = new MainMenu();
			//this.stickers_menu = new StickersMenu('../assets/data.json');
			this.main_board = new Board();
			this.draw_board = new DrawBoardEasy();
		}
		
		private function agregarListeners():void
		{
			this.addEventListener(StickersMenuCategoryNode.CLICK_STICKER_NODE, onClickStickerFromMenu);
			this.addEventListener(PrimaryMenu.INIT_DRAW, onInitDraw);
			this.addEventListener(PrimaryMenu.INIT_STICKERS, onInitStickers);
			
			this.addEventListener(DrawMenu.CHANGE_COLOR, onChangeColor);
			this.addEventListener(DrawMenu.CHANGE_TICKNESS, onChangeTickness);
		}
		
		private function onChangeColor(e:Event):void
		{
			//trace(DrawMenu(e.target).color);
			this.draw_board.color = DrawMenu(e.target).color;
		}
		
		private function onChangeTickness(e:Event):void
		{
			//trace(DrawMenu(e.target).tickness);
			this.draw_board.tickness = DrawMenu(e.target).tickness;
		}
		
		private function onInitDraw(e:Event):void
		{
			trace(e);
			//iniciar drawboard
			this.addChild(this.draw_board);
			this.draw_board.beginDraw();
		}
		
		private function onInitStickers(e:Event):void
		{
			//obtener el dibujo y hacerlo sticker
			var bi:BoardItem = new BoardItem();
			bi.generateFromDisplayObject(this.draw_board.getDraw());
			
			this.main_board.addItem(bi);
			
			if (this.contains(this.draw_board) && this.draw_board)
			{
				this.draw_board.erase();
				this.removeChild(this.draw_board);
			}
		}
		
		private function onClickStickerFromMenu(e:Event):void
		{
			trace(e.target);
			var scn:StickersMenuCategoryNode = e.target as StickersMenuCategoryNode;
			trace(scn);
			
			var bi:BoardItem = new BoardItem();
			bi.generateFromUrl(scn.url);
			
			this.main_board.addItem(bi,true);
		}
		
		private function dibujar():void
		{
			this.addChild(this.main_menu);
			this.addChild(this.main_board);
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