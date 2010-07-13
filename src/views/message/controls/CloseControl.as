package views.message.controls 
{
	import views.message.controls.AbstractControl;
	import flash.geom.ColorTransform;
	
	/**
	 * ...
	 * @author Kyle Buchanan
	 */
	public class CloseControl extends AbstractControl
	{
		
		public function CloseControl() 
		{
			super();
			this.mouseChildren = false;
			this.buttonMode = true;
			
			this.graphics.beginFill(0xb50000);
			this.graphics.drawCircle(0, 0, CIRCLE_RADIUS);
			this.graphics.endFill();
			
			var colorTransform:ColorTransform = new ColorTransform();
			colorTransform.color = 0xFFFFFF;
			
			var closeGraphic:CloseGraphic = new CloseGraphic();
			closeGraphic.transform.colorTransform = colorTransform;
			closeGraphic.scaleX = 0.3;
			closeGraphic.scaleY = 0.3;
			addChild(closeGraphic);
		}
		
	}

}