package com.as3joelib.joeeditor
{
	import com.adobe.crypto.MD5;
	import com.adobe.utils.StringUtil;
	import com.as3joelib.joeeditor.board.Board;
	import com.as3joelib.joeeditor.board.BoardItem;
	import com.as3joelib.joeeditor.drawer.DrawBoardEasy;
	import com.as3joelib.joeeditor.interfaces.IEditor;
	import com.as3joelib.joeeditor.menus.DrawMenu;
	import com.as3joelib.joeeditor.menus.MainMenu;
	import com.as3joelib.joeeditor.menus.PrimaryMenu;
	import com.as3joelib.joeeditor.menus.StickersMenuCategoryNode;
	import com.as3joelib.joeeditor.menus.WebcamMenu;
	import com.as3joelib.utils.Singleton;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
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
		//constantes para la actividad actual
		public static const ACTIVITY_DRAW:String = 'activityDraw';
		public static const ACTIVITY_STICKERS:String = 'activityStickers';
		public static const ACTIVITY_WEBCAM:String = 'activityWebcam';
		
		//variable de la actividad actual
		private var actividad_actual:String;
		
		//menus
		private var main_menu:MainMenu;
		
		//board
		private var main_board:Board;
		
		//drawboard
		private var draw_board:DrawBoardEasy;
		
		//instancia de video para la webcam
		private var video:Video;
		
		//uniqueId de este editor
		//private var unique_id:String;
		
		public function JoeEditor(stickers_json_url:String):void
		{
			this.setStickersJsonUrl(stickers_json_url);
			
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
			/*
			   //set unique id
			   this.unique_id = '';
			   for (var i:uint = 0; i < 32; i++) {
			   this.unique_id += String(Math.round(Math.random() * 10));
			   }
			   this.unique_id = MD5.hash(this.unique_id);
			 */
			
			this.actividad_actual = JoeEditor.ACTIVITY_STICKERS;
			
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
		}
		
		private function onWebCamReady(e:Event):void
		{
			this.createStickerFromWebcam();
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
			//crear sticker de otras actividades no finalizadas
			this.createStickerFromActivities();
			
			//quitar la herramienta
			this.main_board.selectNone();
			
			//desactivar la herramienta
			this.main_board.disableTool();
			
			trace(e);
			//iniciar drawboard
			this.addChild(this.draw_board);
			this.draw_board.beginDraw();
			
			//actualziar la actividad actual
			this.actividad_actual = JoeEditor.ACTIVITY_DRAW;
		}
		
		private function onInitStickers(e:Event):void
		{
			trace('JoeEditor.onInitStickers');
			
			//quitar la herramienta
			this.main_board.selectNone();
			
			//activar la herramienta
			this.main_board.enableTool();
			
			//crear sticker de otras actividades no finalizadas
			this.createStickerFromActivities();
			
			if (this.contains(this.draw_board) && this.draw_board)
			{
				this.draw_board.endDraw();
				this.removeChild(this.draw_board);
			}
			
			//actualizar la actividad actual
			this.actividad_actual = JoeEditor.ACTIVITY_STICKERS;
		}
		
		private function onInitWebcam(e:Event):void
		{
			trace('JoeEditor.onInitWebcam');
			
			//crear sticker de otras actividades no finalizadas
			this.createStickerFromActivities();
			
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
			var bi:BoardItem = new BoardItem();
			bi.generateFromDisplayObject(this.video);
			
			this.main_board.addItem(bi, true);
			
			if (this.contains(this.draw_board) && this.draw_board)
			{
				this.draw_board.endDraw();
				this.removeChild(this.draw_board);
			}
			
			//actualziar la actividad actual
			this.actividad_actual = JoeEditor.ACTIVITY_WEBCAM;
		}
		
		private function createStickerFromActivities():void
		{
			switch (this.actividad_actual)
			{
				case JoeEditor.ACTIVITY_DRAW: 
					if ((Sprite(this.draw_board.getDraw()).width >= 0) || (Sprite(this.draw_board.getDraw()).height >= 0))
						this.createStickerFromDrawBoard();
					break;
				case JoeEditor.ACTIVITY_WEBCAM: 
					this.createStickerFromWebcam();
					break;
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
			//this.draw_board.beginDraw();
		}
		
		private function createStickerFromWebcam():void
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
		
			//remover referencia del video
			//this.video = null;
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
			//crear sticker de otras actividades no finalizadas
			//this.createStickerFromActivities();
			
			//quitar el tool del board
			this.main_board.selectNone();
			
			//to do: quiza sea necesario poner las dimensiones de las texturas que necesito hacer
			//por ahora pongo las mas grandes posibles y utiles
			
			//generar un bitmap
			var bmpd:BitmapData = new BitmapData(this.main_board.getBounds(this.stage).width, this.main_board.getBounds(this.stage).height, true, 0xffff00)
			var matrix:Matrix = new Matrix();
			matrix.translate(-this.main_board.getBounds(this.stage).x, -this.main_board.getBounds(this.stage).y);
			
			bmpd.draw(this.main_board, matrix);
			
			//hacer que la actividad principal sea ahora la de los stickers
			this.main_menu.initAction(JoeEditor.ACTIVITY_STICKERS);
			this.actividad_actual = JoeEditor.ACTIVITY_STICKERS;
			
			return bmpd;
		}
		
		private function setStickersJsonUrl(s:String):void
		{
			if (!Singleton.getInstance().data)
			{
				Singleton.getInstance().data = new Object();
			}
			
			if (!Singleton.getInstance().data.joeeditor_stickers_json_url)
			{
				Singleton.getInstance().data.joeeditor_stickers_json_url = s;
			}
		}
	}
}
