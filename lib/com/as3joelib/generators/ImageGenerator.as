package utils
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;

	public class ImageHelper extends Sprite
	{
		//eventos
		public static const IMAGEHELPER_IMAGE_LOADED:String = 'imageHelperImageLoaded';
		
		private var cont:Sprite;
		private var cargando:Sprite;
		
		private var loader:Loader;
		private var url:String;
		
		public var isLoaded:Boolean;
		
		private var w:Number;
		private var h:Number;
		
		private var opciones:Object;
		
		public function ImageHelper(_url:String,_opciones_usuario:Object = null)
		{
			url = _url;
			//trace(url);
			
			this.opciones = new Object();
			
			//defaults
			this.opciones = {
				triggerResizeEvent:true,
				centeredX:false,
				centeredY:false,
				loadingBar:false,
				loadingBarY:0
			};
			
			//mezclar con las opciones del usuario y sobreescribir las por defecto
			this.opciones = ArrayUtil.mergeObjects(opciones,_opciones_usuario);			
			
			cont = new Sprite;
			this.addChild(this.cont);
			
			this.isLoaded = false;
			
			ponerCargando();
			cargar();			
		}
		
		private function cargar():void{
			loader = new Loader();
			
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onProgress);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			
			try{
				loader.load(new URLRequest(url));
			} catch(e:Error){
				trace(e);
			}
		}
		
		private function onComplete(e:Event):void{
			sacarCargando();
			cont.addChild(loader);
			
			this.isLoaded = true;
			
			if(this.w && this.h){
				this.setSize(this.w,this.h);
			}
			
			if(this.opciones.centeredX){
				loader.x = - loader.width/2;
			}
			
			if(this.opciones.centeredY){
				loader.y = - loader.height/2;
			}
			
			//enviar evento resize para que los liquid se ajusten
			if(this.opciones.triggerResizeEvent){
				this.dispatchEvent(new Event(Event.RESIZE,true));	
			}
			
			//enviar evento para que los interesados sepan que esta todo listo
			//trace('disparando evento: IMAGEHELPER_IMAGE_LOADED');
			this.dispatchEvent(new Event(IMAGEHELPER_IMAGE_LOADED,true));
		}
		
		//The resizing function
		// parameters
		// required: maxW = either the size of the box to resize to, or just the maximum desired width
		// optional: maxH = if desired resize area is not a square, the maximum desired height. default is to match to maxW (so if you want to resize to 200x200, just send 200 once)
		// optional: constrainProportions = boolean to determine if you want to constrain proportions or skew image. default true.
		public function setSize(maxW:Number, maxH:Number=0, constrainProportions:Boolean=true):void{
			maxH = maxH == 0 ? maxW : maxH;
			
			this.w = maxW;
			this.h = maxH;
			
			this.loader.width = maxW;
			this.loader.height = maxH;
			if (constrainProportions) {
				this.loader.scaleX < this.loader.scaleY ? this.loader.scaleY = this.loader.scaleX : this.loader.scaleX = this.loader.scaleY;
			}
		}
		
		private function onProgress(e:ProgressEvent):void{
			
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void 
		{ 
			//trace("ioErrorHandler: " + event); 
		} 
		
		private function ponerCargando():void{
			if(this.opciones.loadingBar){
				cargando = new AppleStylePreloaderAsset();
				cargando.scaleX = 0.1;
				cargando.scaleY = 0.1;
				cont.addChild(cargando);
				
				cargando.y = this.opciones.loadingBarY;
			}
		}
		
		private function sacarCargando():void{
			if(this.opciones.loadingBar){
				if(cont.contains(cargando)){
					cont.removeChild(cargando);
				}
			}
		}
	}
}