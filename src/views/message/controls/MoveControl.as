package views.message.controls 
{
	import views.message.controls.AbstractControl;
	import flash.geom.ColorTransform;
	
	/**
	 * ...
	 * @author Kyle Buchanan
	 */
	public class MoveControl extends AbstractControl
	{
		public function MoveControl() 
		{
			super();
			this.mouseChildren = false;
			this.buttonMode = true;
			
			this.graphics.beginFill(0x000000);
			this.graphics.drawCircle(0, 0, CIRCLE_RADIUS);
			this.graphics.endFill();
			
			var colorTransform:ColorTransform = new ColorTransform();
			colorTransform.color = 0xFFFFFF;
			
			var translateGraphic:TranslateGraphic = new TranslateGraphic();
			translateGraphic.transform.colorTransform = colorTransform;
			translateGraphic.scaleX = 0.4;
			translateGraphic.scaleY = 0.4;
			addChild(translateGraphic);
		}
		
	}

}