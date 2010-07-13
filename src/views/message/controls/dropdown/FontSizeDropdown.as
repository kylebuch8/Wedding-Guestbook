package views.message.controls.dropdown 
{
	import flash.display.Sprite;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import views.message.controls.dropdown.Dropdown;
	
	/**
	 * ...
	 * @author Kyle Buchanan
	 */
	public class FontSizeDropdown extends Dropdown
	{
		[Embed(source = "Z:\\kylbucha\\Library\\Fonts\\Museo500-Regular.otf", fontName = "Museo Sans")]
		public static const MUSEO_SANS:Class;
		
		private static const DROPDOWN_TYPE:String = "Size";
		private static const FONT_SIZE:Number = 12;
		private static const FONT_COLOR:uint = 0x303030;
		
		private var _sizes:Array = new Array("X-Small", "Small", "Medium", "Large", "X-Large");
		private var _dropdownItems:Array = new Array();
		
		public function FontSizeDropdown() 
		{
			var textFormat:TextFormat = new TextFormat();
			textFormat.font = "Museo Sans";
			textFormat.color = FONT_COLOR;
			textFormat.size = FONT_SIZE;
			
			var counter:int = 0;
			for each (var size:String in _sizes)
			{
				counter++;
				
				var last:Boolean = false;
				if (counter == _sizes.length)
				{
					last = true;
				}
				
				var textField:TextField = new TextField();
				textField.antiAliasType = AntiAliasType.NORMAL;
				textField.autoSize = TextFieldAutoSize.LEFT;
				textField.defaultTextFormat = textFormat;
				textField.embedFonts = true;
				textField.selectable = false;
				textField.text = size;
				
				var dropdownItem:DropdownItem = new DropdownItem(textField, last, DROPDOWN_TYPE, size);
				if (counter == 2)
				{
					dropdownItem.selected = true;
					_selectedItem = dropdownItem;
				}
				_dropdownItems.push(dropdownItem);
			}
			
			super("Size", _dropdownItems);
		}
		
	}

}