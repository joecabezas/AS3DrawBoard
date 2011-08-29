package com.as3joelib.joeeditor.menus
{
	import com.adobe.serialization.json.JSON;
	import com.as3joelib.utils.ObjectUtil;
	import com.bit101.components.ComboBox;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.DataLoader;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	//import com.liamr.ui.dropDown.DropDown;
	//import com.liamr.ui.dropDown.Events.DropDownEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Joe Cabezas
	 */
	public class StickersMenu extends Sprite
	{
		//constantes de diseño
		public static const STICKERS_SIZE:Number = 80;
		
		//constantes de loaders
		private static const JSON_LOADER:String = 'jsonLoader';
		
		//datos
		private var json_url:String;
		private var json_loader:DataLoader;
		private var json_object:Object;
		
		//loader de imagenes
		private const STICKER_MAX_LOADER:String = 'stickerMaxLoader';
		private var stickers_loader_max:LoaderMax;
		
		//vector de categorias
		private var categories:Vector.<StickersMenuCategory>;
		
		//container de los stickers
		private var stickers_container:Sprite;
		
		//dropdownmenu
		//private var dropdown_menu:DropDown;
		private var combo_box:ComboBox;
		
		public function StickersMenu(json_url:String)
		{
			this.json_url = json_url;
			
			this.setup();
			this.load();
			this.agregarListeners();
		}
		
		private function setup():void
		{
			this.categories = new Vector.<StickersMenuCategory>;
			this.json_loader = new DataLoader(this.json_url, {name: JSON_LOADER, onComplete: onJsonLoaderComplete});
			this.stickers_loader_max = new LoaderMax( { name: STICKER_MAX_LOADER, onComplete: onStickerMaxLoaderComplete } );
			
			this.stickers_container = new Sprite();
		}
		
		private function load():void
		{
			this.json_loader.load();
		}
		
		private function onJsonLoaderComplete(e:LoaderEvent):void
		{
			this.json_object = JSON.decode(this.json_loader.content);
			//ObjectUtil.pr(this.json_object);
			
			this.setupStickerLoaderMax();
			this.dibujar();
		}
		
		private function setupStickerLoaderMax():void
		{
			trace('setupStickerLoaderMax');
			//por cada categoria
			for each (var c:Object in this.json_object.stickers.categorias.categoria)
			{
				
				var category:StickersMenuCategory = new StickersMenuCategory(c.name);
				
				//por cada imagen
				for each (var img:Object in c.imagen)
				{
					//trace('+')
					//ObjectUtil.pr(img);
					//trace(img.url);
					
					var imgl:ImageLoader = new ImageLoader(img.url, {name: img.name,
						
							width: STICKERS_SIZE, height: STICKERS_SIZE,
							
							bgColor: 0xffffff});
					
					this.stickers_loader_max.append(imgl);
					
					//crear el nodo
					var node:StickersMenuCategoryNode = new StickersMenuCategoryNode(imgl.name, imgl.content, imgl.url);
					
					//agregar a categoria
					category.addNode(node);
				}
				
				//actualizar y renderear categoria
				category.updateAndRender();
				
				//agregar categoria al vector de caterogias
				this.categories.push(category);
			}
			
			this.agregarCategoriasAlDropDownMenu();
			this.stickers_loader_max.load();
		}
		
		private function agregarCategoriasAlDropDownMenu():void 
		{
			var lista:Array = new Array();
			for each (var category:StickersMenuCategory in this.categories)
			{
				lista.push({label:category.name});
			}
			ObjectUtil.pr(lista);
			
			this.combo_box = new ComboBox(this, 0, 0, 'Seleccione Categoria', lista);
			this.combo_box.setSize(245, this.combo_box.height);
			this.combo_box.addEventListener(Event.SELECT, onComboBoxSelect);
			
			//this.dropdown_menu = new DropDown(lista, 'Selecciona Categoria');
			//this.dropdown_menu.addEventListener(DropDown.ITEM_SELECTED, onItemSelected);
		}
		
		private function onComboBoxSelect(e:Event):void 
		{
			trace('StickersMenu.onComboBoxSelect');
			//trace(e);
			//trace(ComboBox(e.target).selectedItem.label);
			this.dibujarCategoria(ComboBox(e.target).selectedItem.label);
		}
		
		private function onStickerMaxLoaderComplete(e:LoaderEvent):void
		{
		
		}
		
		private function agregarListeners():void
		{
			
		}
		
		/*private function onItemSelected(e:DropDownEvent):void 
		{
			//trace(e.selectedData);
			//trace(e.selectedId);
			trace('+' + e.selectedLabel);
			this.dibujarCategoria(e.selectedLabel);
			
		}*/
		
		private function dibujarCategoria(selectedLabel:String):void 
		{
			trace('StickersMenu.dibujarCategoria');
			
			//eliminar todos lso hijos del container de stickers
			for (var i:int = 0; i < this.stickers_container.numChildren; i++) {
				this.stickers_container.removeChildAt(i);
			}
			
			//lapiz temporal hasta que meta esto a un accordeon o algo mejor
			var lapiz:Point = new Point(0, 25);
			
			for each (var category:StickersMenuCategory in this.categories)
			{
				if (category.name == selectedLabel) {
					this.stickers_container.addChild(category);
					category.x = lapiz.x;
					category.y = lapiz.y;
					
					lapiz.y += category.height + 5;
				}
			}
		}
		
		private function dibujar():void
		{
			trace('StickersMenu.dibujar');
			this.addChild(this.stickers_container);
			//this.addChild(this.dropdown_menu);
			this.addChild(this.combo_box);
		}
		
		public function getStickersLoader():LoaderMax
		{
			return this.stickers_loader_max;
		}
	
	}

}