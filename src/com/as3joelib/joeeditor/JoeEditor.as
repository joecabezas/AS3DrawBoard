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
	import com.as3joelib.joeeditor.menus.WebcamMenu;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Transform;
	import flash.media.Camera;
	import flash.media.Video;
	
	/**
	 * ...
	 * @author Joe Cabezas
	 */
	//[SWF(backgroundColor='#ffffff',frameRate='30')]
	
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
		
		//instancia de video para la webcam
		private var video:Video;
		private var bi_video:BoardItem;
		
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
			this.addEventListener(PrimaryMenu.INIT_WEBCAM, onInitWebcam);
			
			this.addEventListener(DrawMenu.CHANGE_COLOR, onChangeColor);
			this.addEventListener(DrawMenu.CHANGE_TICKNESS, onChangeTickness);
			
			this.addEventListener(WebcamMenu.WEBCAM_READY, onWebCamReady);
		}
		
		private function onWebCamReady(e:Event):void
		{
			//quitar
			//obtener el bitmapdata del video
			var bmpd:BitmapData = new BitmapData(this.video.width, this.video.height, false);
			
			//dibujar el video, quitandolo del main board
			bmpd.draw(this.main_board.poplastItem());
			
			//crear el bitmap
			var bmp:Bitmap = new Bitmap(bmpd);
			
			//aplicar matrix al bitmap
			bmp.transform.matrix = this.main_board.getToolMatrix();
			
			//crear board item
			var bi:BoardItem = new BoardItem();
			bi.generateFromDisplayObject(bmp);
			
			//agregar board item al main board
			this.main_board.addItem(bi);
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
			this.createStickerFromDrawBoard();
			
			if (this.contains(this.draw_board) && this.draw_board)
			{
				this.draw_board.endDraw();
				this.removeChild(this.draw_board);
			}
		}
		
		private function onInitWebcam(e:Event):void 
		{
			trace('JoeEditor.onInitWebcam');
			
			//quitar la herramienta
			this.main_board.selectNone();
			
			//activar la herramienta
			this.main_board.enableTool();
			
			//obtener video de la webcam y agregarlo al board
			
			//obtener instancia de camera
			var cam:Camera = Camera.getCamera();
			
			//camera configs
			cam.setQuality(0, 100);
			cam.setMode(320, 240, 25, true);
			
			//agregar el stream de la cam a un objeto de video
			this.video = new Video();
			this.video.attachCamera(cam);
			
			//generar el board item
			this.bi_video = new BoardItem();
			this.bi_video.generateFromDisplayObject(this.video);
			
			this.main_board.addItem(this.bi_video);
			//this.addChild(video);
			
			
			if (this.contains(this.draw_board) && this.draw_board)
			{
				this.draw_board.endDraw();
				this.removeChild(this.draw_board);
			}
		}
		
		private function createStickerFromDrawBoard():void 
		{
			var bi:BoardItem = new BoardItem();
			bi.generateFromDisplayObject(this.draw_board.getDraw());
			
			this.main_board.addItem(bi);
			
			//borrar dibujo
			this.draw_board.erase();
			
			//pero seguir atento a que el usuario puede seguir dibujando
			this.draw_board.beginDraw();
		}

		private function onClickStickerFromMenu(e:Event):void
		{
			trace('JoeEditor.onClickStickerFromMenu');
			
			//habilitar la herramienta del board
			this.main_board.enableTool();
			
			var scn:StickersMenuCategoryNode = e.target as StickersMenuCategoryNode;
			
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

		public function getBitmapData():BitmapData
		{
			//transformar todo lo dibujado (si es que hay), en sticker
			if ((Sprite(this.draw_board.getDraw()).width >= 0) || (Sprite(this.draw_board.getDraw()).height >= 0)) {
				this.createStickerFromDrawBoard();
			}
			
			//quitar el tool del board
			this.main_board.selectNone();

			//to do: quiza sea necesario poner las dimensiones de las texturas que necesito hacer
			//por ahora pongo las mas grandes posibles y utiles
			
			//generar un bitmap
			var bmpd:BitmapData = new BitmapData(this.stage.stageWidth,this.stage.stageHeight,true,0xffff00)
			bmpd.draw(this.main_board);
			
			return bmpd;
		}
	}
}
