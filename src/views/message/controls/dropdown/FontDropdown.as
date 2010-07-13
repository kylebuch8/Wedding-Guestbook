package views.message.controls.dropdown 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	import views.message.controls.dropdown.Dropdown;
	import AdobeGaramondPro;
	import AlpineScript;
	import MuseoSans;
	import Scriptonah;
	
	/**
	 * ...
	 * @author Kyle Buchanan
	 */
	public class FontDropdown extends Dropdown
	{
		/*[Embed(source = "Z:\\kylbucha\\Library\\Fonts\\AGaramondPro-Regular.otf", fontName = "Adobe Garamond Pro")]
		public static const ADOBE_GARAMOND_PRO:Class;
		
		[Embed(source = "Z:\\kylbucha\\Library\\Fonts\\Alpine Script.otf", fontName = "Alpine Script")]
		public static const ALPINE_SCRIPT:Class;
		
		[Embed(source = "Z:\\kylbucha\\Library\\Fonts\\Museo500-Regular.otf", fontName = "Museo Sans")]
		public static const MUSEO_SANS:Class;
		
		[Embed(source = "Z:\\kylbucha\\Library\\Fonts\\Scriptonah_Demibold.otf", fontName = "Scriptonah")]
		public static const SCRIPTONAH:Class;*/
		
		private static const FONT_COLOR:uint = 0x303030;
		private static const DROPDOWN_TYPE:String = "Font";
		
		private var adobeGaramondPro:AdobeGaramondPro = new AdobeGaramondPro();
		private var alpineScript:AlpineScript = new AlpineScript();
		private var museoSans:MuseoSans = new MuseoSans();
		private var scriptonah:Scriptonah = new Scriptonah();
		
		private var _fonts:Array = new Array("Serif", "Sans Serif", "Casual", "Formal")
		private var _dropdownItems:Array = new Array();
		
		public function FontDropdown() 
		{
			var counter:int = 0;
			for each (var font:String in _fonts)
			{
				counter++;
				
				var last:Boolean = false;
				if (counter == _fonts.length)
				{
					last = true;
				}
				
				var textFormat:TextFormat = new TextFormat();
				textFormat.color = FONT_COLOR;
				
				switch (counter)
				{
					case 1:
						//textFormat.font = "Adobe Garamond Pro";
						textFormat.font = adobeGaramondPro.fontName;
						textFormat.size = 18;
						break;
						
					case 2:
						//textFormat.font = "Museo Sans";
						textFormat.font = museoSans.fontName;
						textFormat.size = 18;
						break;
						
					case 3:
						//textFormat.font = "Scriptonah" ;
						textFormat.font = scriptonah.fontName;
						textFormat.size = 16;
						break;
						
					case 4:
						//textFormat.font = "Alpine Script";
						textFormat.font = alpineScript.fontName;
						textFormat.size = 22;
						break;
				}
				
				var textField:TextField = new TextField();
				textField.antiAliasType = AntiAliasType.NORMAL;
				textField.autoSize = TextFieldAutoSize.LEFT;
				textField.defaultTextFormat = textFormat;
				textField.embedFonts = true;
				textField.selectable = false;
				
				switch (counter)
				{
					case 1:
						textField.text = "Serif";
						break;
						
					case 2:
						textField.text = "Sans Serif";
						break;
						
					case 3:
						textField.text = "Casual";
						break;
						
					case 4:
						textField.text = "Formal";
						break;
				}
				
				var dropdownItem:DropdownItem = new DropdownItem(textField, last, DROPDOWN_TYPE, font);
				if (counter == 1)
				{
					dropdownItem.selected = true;
					_selectedItem = dropdownItem;
				}
				_dropdownItems.push(dropdownItem);
			}
			
			super("Font", _dropdownItems);
		}
		
	}

}