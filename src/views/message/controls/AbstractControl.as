package views.message.controls 
{
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import views.message.MessageInput;
	
	/**
	 * ...
	 * @author Kyle Buchanan
	 */
	public class AbstractControl extends Sprite
	{
		public static const CIRCLE_RADIUS:Number = 10;
		private var _view:MessageInput;
		private var _dropShadow:DropShadowFilter;
		
		public function AbstractControl() 
		{
			_dropShadow = new DropShadowFilter(1, 120, 0, 75, 5, 5);
			this.filters = [_dropShadow];
		}
		
		// Getter and Setter Methods
		public function get view():MessageInput { return _view; }
		public function set view(pView:MessageInput):void { _view = pView; }
	}

}