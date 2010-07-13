package views.message.controls 
{
	import views.message.controls.AbstractControl;
	import flash.geom.ColorTransform;
	
	/**
	 * ...
	 * @author Kyle Buchanan
	 */
	public class DoneControl extends AbstractControl
	{
		
		public function DoneControl() 
		{
			super();
			this.mouseChildren = false;
			this.buttonMode = true;
			
			this.graphics.beginFill(0x82b713);
			this.graphics.drawRoundRect(0, 0, 100, CIRCLE_RADIUS * 2, 5, 5);
			this.graphics.endFill();
			
			var colorTransform:ColorTransform = new ColorTransform();
			colorTransform.color = 0xFFFFFF;
			
			var doneGraphic:DoneGraphic = new DoneGraphic();
			doneGraphic.transform.colorTransform = colorTransform;
			doneGraphic.scaleX = 0.4;
			doneGraphic.scaleY = 0.4;
			doneGraphic.x = this.width / 2;
			doneGraphic.y = this.height / 2;
			addChild(doneGraphic);
		}
		
	}

}