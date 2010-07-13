package views.message.controls 
{
	import views.message.controls.AbstractControl;
	import flash.geom.ColorTransform;
	
	/**
	 * ...
	 * @author Kyle Buchanan
	 */
	public class ResizeControl extends AbstractControl
	{
		
		public function ResizeControl() 
		{
			super();
			this.mouseChildren = false;
			this.buttonMode = true;
			
			this.graphics.beginFill(0x000000);
			this.graphics.drawCircle(0, 0, CIRCLE_RADIUS);
			this.graphics.endFill();
			
			var colorTransform:ColorTransform = new ColorTransform();
			colorTransform.color = 0xFFFFFF;
			
			var resizeGraphic:ResizeGraphic = new ResizeGraphic();
			resizeGraphic.transform.colorTransform = colorTransform;
			resizeGraphic.scaleX = 0.35;
			resizeGraphic.scaleY = 0.35;
			addChild(resizeGraphic);
		}
		
	}

}