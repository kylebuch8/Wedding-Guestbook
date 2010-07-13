package views.message 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import AdobeGaramondPro;
	import AlpineScript;
	import MuseoSans;
	import Scriptonah;
	
	/**
	 * ...
	 * @author Kyle Buchanan
	 */
	public class Message extends Sprite
	{
		/*[Embed(source = "Z:\\kylbucha\\Library\\Fonts\\AGaramondPro-Regular.otf", fontName = "Adobe Garamond Pro")]
		public static const ADOBE_GARAMOND_PRO:Class;
		
		[Embed(source = "Z:\\kylbucha\\Library\\Fonts\\Alpine Script.otf", fontName = "Alpine Script")]
		public static const ALPINE_SCRIPT:Class;
		
		[Embed(source = "Z:\\kylbucha\\Library\\Fonts\\MuseoSans_500.otf", fontName = "Museo Sans")]
		public static const MUSEO_SANS:Class;
		
		[Embed(source = "Z:\\kylbucha\\Library\\Fonts\\Scriptonah_Demibold.otf", fontName = "Scriptonah")]
		public static const SCRIPTONAH:Class;*/
		
		private var adobeGaramondPro:AdobeGaramondPro = new AdobeGaramondPro();
		private var alpineScript:AlpineScript = new AlpineScript();
		private var museoSans:MuseoSans = new MuseoSans();
		private var scriptonah:Scriptonah = new Scriptonah();
		
		private var _textField:TextField;
		private var _textFormat:TextFormat;
		
		public function Message(pText:String, pWidth:Number, pHeight:Number, pFont:String, pSize:Number, pColor:uint) 
		{
			_textFormat = new TextFormat();
			_textFormat.font = getFont(pFont);
			_textFormat.size = pSize;
			_textFormat.color = pColor;
			
			_textField = new TextField();
			_textField.defaultTextFormat = _textFormat;
			_textField.embedFonts = true;
			_textField.multiline = true;
			_textField.selectable = false;
			_textField.wordWrap = true;
			_textField.width = pWidth;
			_textField.height = pHeight + 10;
			_textField.text = pText;
			addChild(_textField);
		}
		
		private function getFont(pString:String):String
		{
			var font:String;
			
			switch (pString)
			{
				case "Adobe Garamond Pro":
					font = adobeGaramondPro.fontName;
					break;
					
				case "Museo Sans":
					font = museoSans.fontName;
					break;
					
				case "Alpine Script":
					font = alpineScript.fontName;
					break;
					
				case "Scriptonah":
					font = scriptonah.fontName;
					break;
			}
			
			return font;
		}
		
	}

}