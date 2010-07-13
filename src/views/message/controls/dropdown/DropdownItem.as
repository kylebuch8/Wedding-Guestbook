package views.message.controls.dropdown 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import caurina.transitions.Tweener;
	
	/**
	 * ...
	 * @author Kyle Buchanan
	 */
	public class DropdownItem extends Sprite
	{
		private static const WIDTH:Number = 125;
		private static const HEIGHT:Number = 30;
		
		private var _background:Sprite;
		private var _selected:Boolean = false;
		private var _dropdown:*;
		private var _value:*;
		
		public function DropdownItem(pSprite:*, pLast:Boolean, pDropdown:*, pValue:*) 
		{
			_dropdown = pDropdown;
			_value = pValue;
			
			this.buttonMode = true;
			this.mouseChildren = false;
			
			this.graphics.beginFill(0xFFFFFF);
			if (pLast)
			{
				this.graphics.drawRoundRectComplex(0, 0, WIDTH, HEIGHT, 0, 0, 5, 5);
			}
			else
			{
				this.graphics.drawRect(0, 0, WIDTH, HEIGHT);
			}
			this.graphics.endFill();
			
			_background = new Sprite();
			_background.graphics.beginFill(0x1E90FF);
			if (pLast)
			{
				_background.graphics.drawRoundRectComplex(0, 0, WIDTH, HEIGHT, 0, 0, 5, 5);
			}
			else
			{
				_background.graphics.drawRect(0, 0, WIDTH, HEIGHT);
			}
			_background.graphics.endFill();
			_background.alpha = 0;
			addChild(_background);
			
			pSprite.x = (this.width / 2) - (pSprite.width / 2);
			pSprite.y = (this.height / 2) - (pSprite.height / 2);
			addChild(pSprite);
			
			addListeners();
		}
		
		private function addListeners():void
		{
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler, false, 0, true);
		}
		
		private function removeListeners():void
		{
			removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
		}
		
		private function mouseOverHandler(pEvent:MouseEvent):void
		{
			select();
		}
		
		private function mouseOutHandler(pEvent:MouseEvent):void
		{
			deselect();
		}
		
		public function select():void
		{
			Tweener.addTween(_background, { alpha: 1, time: 0.5 } );
		}
		
		public function deselect():void
		{
			Tweener.addTween(_background, { alpha: 0, time: 0.5 } );
		}
		
		private function setSelect():void
		{
			if (_selected)
			{
				select();
				removeListeners();
			}
			else
			{
				deselect();
				addListeners();
			}
		}
		
		// Getter and Setter Methods
		public function get selected():Boolean { return _selected; }
		public function set selected(pBoolean:Boolean):void { _selected = pBoolean; setSelect(); }
		public function get dropdown():* { return _dropdown; }
		public function set dropdown(pDropdown:*):void { _dropdown = pDropdown; }
		public function get value():* { return _value; }
		public function set value(pValue:*):void { _value = pValue; }
		
	}

}