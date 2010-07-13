package views.message.controls.dropdown 
{
	import flash.display.Sprite;
	import views.message.controls.dropdown.Dropdown;
	
	/**
	 * ...
	 * @author Kyle Buchanan
	 */
	public class ColorDropdown extends Dropdown
	{
		private static const DROPDOWN_TYPE:String = "Color";
		
		private var _colors:Array = new Array(0x5d6246, 0xf07d38, 0x603913, 0xb50000);
		private var _dropdownItems:Array = new Array();
		
		public function ColorDropdown() 
		{
			var counter:int = 0;
			for each (var color:uint in _colors)
			{
				counter++;
				
				var sprite:Sprite = new Sprite();
				sprite.graphics.beginFill(color);
				sprite.graphics.drawRoundRect(0, 0, 85, 10, 10, 10);
				sprite.graphics.endFill();
				
				var last:Boolean = false;
				if (counter == _colors.length)
				{
					last = true;
				}
				
				var dropdownItem:DropdownItem = new DropdownItem(sprite, last, DROPDOWN_TYPE, color);
				if (counter == 1)
				{
					dropdownItem.selected = true;
					_selectedItem = dropdownItem;
				}
				_dropdownItems.push(dropdownItem);
			}
			
			super("Color", _dropdownItems);
		}
		
	}

}