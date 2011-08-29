package com.as3joelib.joeeditor
{
	import com.as3joelib.joeeditor.board.Board;
	import com.as3joelib.joeeditor.board.BoardItem;
	import com.as3joelib.joeeditor.drawer.DrawBoardEasy;
	import com.as3joelib.joeeditor.interfaces.IEditor;
	import com.as3joelib.joeeditor.menus.DrawMenu;
	import com.as3joelib.joeeditor.menus.MainMenu;
	import com.as3joelib.joeeditor.menus.PrimaryMenu;
	import com.as3joelib.joeeditor.menus.StickersMenuCategoryNode;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Joe Cabezas
	 */
	[SWF(backgroundColor='#ffffff',frameRate='30')]
	
	//Descomentar esto si esta es la DocumentClass
	//[Frame(factoryClass="joeeditor.Preloader")]
	
	public class JoeEditor extends Sprite implements IEditor
	{
		//menus
		private var main_menu:MainMenu;
		
		//board
		private var main_board:Board;
		
		//drawboard
		private var draw_board:DrawBoardEasy;
		
		public function JoeEditor():void
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
			//quitar la herramienta
			this.main_board.selectNone();
			
			//desactivar la herramienta
			this.main_board.disableTool();
			
			trace(e);
			//iniciar drawboard
			this.addChild(this.draw_board);
			this.draw_board.beginDraw();
		}
		
		private function onInitStickers(e:Event):void
		{
			//quitar la herramienta
			this.main_board.selectNone();
			
			//activar la herramienta
			this.main_board.enableTool();
			
			//obtener el dibujo y hacerlo sticker
			var bi:BoardItem = new BoardItem();
			bi.generateFromDisplayObject(this.draw_board.getDraw());
			
			this.main_board.addItem(bi);
			
			if (this.contains(this.draw_board) && this.draw_board)
			{
				this.draw_board.erase();
				this.draw_board.endDraw();
				this.draw_board.endDraw();
				this.removeChild(this.draw_board);
			}
		}
		
		private function onClickStickerFromMenu(e:Event):void
		{
			trace('JoeEditor.onClickStickerFromMenu');
			
			//habilitar la herramienta del board
			this.main_board.enableTool();
			
			var scn:StickersMenuCategoryNode = e.target as StickersMenuCategoryNode;
			trace(scn.width);
			trace(scn.height);
			
			var bi:BoardItem = new BoardItem();
			bi.generateFromUrl(scn.url, scn.width, scn.height);
			
			this.main_board.addItem(bi, true);
		}
		
		private function dibujar():void
		{
			this.addChild(this.main_menu);
			this.addChild(this.main_board);
		}
		
		/* INTERFACE com.as3joelib.joeeditor.interfaces.IEditor */
		
		public function getBitmap():Bitmap 
		{
			//quitar el tool del board
			this.main_board.selectNone();
			
			//generar un bitmap
			var bmp:Bitmap = new Bitmap()
			bmp.bitmapData.draw(this.main_board);
			
			return bmp;
		}
	}
}
