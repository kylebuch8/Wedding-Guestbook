package views.message.controls 
{
	import views.message.controls.AbstractControl;
	import flash.geom.ColorTransform;
	
	/**
	 * ...
	 * @author Kyle Buchanan
	 */
	public class RotateControl extends AbstractControl
	{
		
		public function RotateControl() 
		{
			super();
			this.mouseChildren = false;
			this.buttonMode = true;
			
			this.graphics.beginFill(0x000000);
			this.graphics.drawCircle(0, 0, CIRCLE_RADIUS);
			this.graphics.endFill();
			
			var colorTransform:ColorTransform = new ColorTransform();
			colorTransform.color = 0xFFFFFF;
			
			var rotateGraphic:RotateGraphic = new RotateGraphic();
			rotateGraphic.transform.colorTransform = colorTransform;
			rotateGraphic.scaleX = 0.4;
			rotateGraphic.scaleY = 0.4;
			addChild(rotateGraphic);
		}
		
	}

}