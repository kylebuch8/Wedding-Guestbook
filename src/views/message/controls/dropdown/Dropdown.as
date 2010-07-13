package views.message.controls.dropdown 
{
	import controllers.MessageInputController;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.display.GradientType;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.display.SpreadMethod;
	import flash.text.TextField;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import MuseoSans;
	
	import caurina.transitions.Tweener;
	
	/**
	 * ...
	 * @author Kyle Buchanan
	 */
	public class Dropdown extends Sprite
	{
		/*[Embed(source = "Z:\\kylbucha\\Library\\Fonts\\Museo500-Regular.otf", fontName = "Museo Sans")]
		public static const MUSEO_SANS:Class;*/
		
		private static const TOP_BOX_WIDTH:Number = 135;
		private static const TOP_BOX_HEIGHT:Number = 40;
		private static const FONT_SIZE:Number = 15;
		private static const FONT_COLOR:uint = 0x303030;
		
		private var museoSans:MuseoSans = new MuseoSans();
		protected var _controller:MessageInputController;
		protected var _title:String;
		protected var _dropdownItemsContainer:Sprite;
		protected var _dropdownMask:Sprite;
		private var _dropdownItems:Array;
		protected var _topBox:Sprite;
		protected var _dropShadow:DropShadowFilter = new DropShadowFilter(0, 90, 0, 0.5, 8, 8);
		
		protected var _opened:Boolean = false;
		protected var _selectedItem:DropdownItem = null;
		
		public function Dropdown(pTitle:String, pDropdownItems:Array) 
		{
			_title = pTitle;
			_dropdownItems = pDropdownItems;
			
			this.buttonMode = true;
			this.mouseChildren = false;
			
			buildDropdownItems();
			buildTopBox();
		}
		
		protected function buildTopBox():void
		{
			_topBox = new Sprite();
			_topBox.filters = [_dropShadow];
			
			var topBoxMask:Sprite = new Sprite();
			topBoxMask.graphics.beginFill(0x000000);
			topBoxMask.graphics.drawRoundRect(0, 0, TOP_BOX_WIDTH, TOP_BOX_HEIGHT, 10, 10);
			topBoxMask.graphics.endFill();
			
			var type:String = GradientType.LINEAR
			var colors:Array = [0xd1d1d1, 0xe1e1e1, 0xd7d7d7, 0xcbcbcb, 0xe7e7e7, 0x8c8c8c];
			var alphas:Array = [1, 1, 1, 1, 1, 1];
			var ratios:Array = [0, 5, 127, 128, 250, 255];
			var matr:Matrix = new Matrix();
			matr.createGradientBox(TOP_BOX_WIDTH, TOP_BOX_HEIGHT, Math.PI / 2);
			var spreadMethod:String = SpreadMethod.PAD;
			
			var textContainer:Sprite = new Sprite();
			textContainer.graphics.beginGradientFill(type, colors, alphas, ratios, matr, spreadMethod);
			textContainer.graphics.drawRect(0, 0, 110, TOP_BOX_HEIGHT);
			textContainer.graphics.endFill();
			_topBox.addChild(textContainer);
			
			var textFormat:TextFormat = new TextFormat();
			//textFormat.font = "Museo Sans";
			textFormat.font = museoSans.fontName;
			textFormat.color = FONT_COLOR;
			textFormat.size = FONT_SIZE;
			
			var textField:TextField = new TextField();
			textField.antiAliasType = AntiAliasType.ADVANCED;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.defaultTextFormat = textFormat;
			textField.embedFonts = true;
			textField.selectable = false;
			textField.text = _title;
			textField.x = 16;
			textField.y = (textContainer.height / 2) - (textField.height / 2);
			textContainer.addChild(textField);
			
			var arrowContainer:Sprite = new Sprite();
			arrowContainer.graphics.beginFill(0xf07d38);
			arrowContainer.graphics.drawRect(0, 0, 25, TOP_BOX_HEIGHT);
			arrowContainer.graphics.endFill();
			arrowContainer.x = textContainer.width;
			_topBox.addChild(arrowContainer);
			
			var triangle:Sprite = new Sprite();
			triangle.graphics.beginFill(0xffd0b4);
			triangle.graphics.lineTo(8, 0);
			triangle.graphics.lineTo(4, 8);
			triangle.graphics.lineTo(0, 0);
			triangle.graphics.endFill();
			triangle.x = (arrowContainer.width / 2) - (triangle.width / 2);
			triangle.y = (arrowContainer.height / 2) - (triangle.height / 2);
			arrowContainer.addChild(triangle);
			
			addChild(_topBox);
			addChild(topBoxMask);
			
			_topBox.mask = topBoxMask;
		}
		
		protected function buildDropdownItems():void
		{
			_dropdownItemsContainer = new Sprite();
			
			for (var i:int = 0; i < _dropdownItems.length; i++)
			{
				_dropdownItems[i].y = i * _dropdownItems[i].height;
				_dropdownItems[i].addEventListener(MouseEvent.MOUSE_UP, dropdownItem_mouseUpHandler, false, 0, true);
				_dropdownItemsContainer.addChild(_dropdownItems[i]);
			}
			
			_dropdownMask = new Sprite();
			_dropdownMask.graphics.beginFill(0x000000);
			_dropdownMask.graphics.drawRect(0, 8, _dropdownItemsContainer.width, TOP_BOX_HEIGHT);
			_dropdownMask.graphics.endFill();
			
			addChild(_dropdownItemsContainer);
			addChild(_dropdownMask);
			
			_dropdownItemsContainer.mask = _dropdownMask;
			
			_dropdownItemsContainer.x = 5;
			_dropdownItemsContainer.y = -_dropdownItemsContainer.height + TOP_BOX_HEIGHT;
			_dropdownItemsContainer.visible = false;
			
			_dropdownMask.x = 5;
		}
		
		protected function dropdownItem_mouseUpHandler(pEvent:MouseEvent):void
		{
			if (_selectedItem)
			{
				_selectedItem.selected = false;
			}
			
			pEvent.target.selected = true;
			_selectedItem = pEvent.target as DropdownItem;
			_controller.updateStyle(pEvent.target.dropdown, pEvent.target.value);
		}
		
		public function open():void
		{
			this.mouseChildren = true;
			_opened = true;
			
			_dropdownItemsContainer.visible = true;
			_dropdownItemsContainer.filters = [_dropShadow];
			
			_dropdownMask.height = _dropdownItemsContainer.height + TOP_BOX_HEIGHT;
			Tweener.addTween(_dropdownItemsContainer, { y: TOP_BOX_HEIGHT, time: 1 } );
		}
		
		public function close(pImmediate:Boolean, pDelay:Number = 0):void
		{
			this.mouseChildren = false;
			_opened = false;
			
			if (!pImmediate)
			{
				Tweener.addTween(_dropdownItemsContainer, { y: -_dropdownItemsContainer.height + TOP_BOX_HEIGHT, time: 0.65, delay: pDelay, transition: "easeInCubic", onComplete:function():void
				{
					_dropdownItemsContainer.visible = false;
					_dropdownItemsContainer.filters = [];
					_dropdownMask.height = TOP_BOX_HEIGHT - 8;
				} } );
				}
			else
			{
				_dropdownItemsContainer.y = -_dropdownItemsContainer.height + TOP_BOX_HEIGHT;
				_dropdownItemsContainer.visible = false;
				_dropdownItemsContainer.filters = [];
				_dropdownMask.height = TOP_BOX_HEIGHT - 8;
			}
		}
		
		// Getter and Setter Methods
		public function get opened():Boolean { return _opened; }
		public function get topBoxHeight():Number { return TOP_BOX_HEIGHT; }
		public function get controller():MessageInputController { return _controller; }
		public function set controller(pController:MessageInputController):void { _controller = pController; }
		
	}

}