package views 
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Kyle Buchanan
	 */
	public class Loading extends Sprite
	{
		private static const NUM_BARS:int = 12;
		private static const BAR_WIDTH:Number = 20;
		private static const BAR_HEIGHT:Number = 75;
		private static const DISTANCE_FROM_CENTER:Number = 45;
		
		private var bars:Array = new Array();
		private var skipFrame:Boolean = true;
		
		public function Loading() 
		{
			for (var i:int = 0; i < NUM_BARS; i++)
			{
				var bar:Sprite = new Sprite();
				bar.graphics.beginFill(0x000000);
				bar.graphics.drawRoundRect(-BAR_WIDTH / 2, -(BAR_HEIGHT + DISTANCE_FROM_CENTER), BAR_WIDTH, BAR_HEIGHT, BAR_WIDTH, BAR_WIDTH);
				bar.graphics.endFill();
				bar.rotation = i * (360 / NUM_BARS);
				bar.alpha = i * (1 / NUM_BARS);
				bars.push(bar);
				
				addChild(bar);
			}
			
			this.rotation = 360 / NUM_BARS;
			addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, true);
		}
		
		private function enterFrameHandler(pEvent:Event):void
		{
			if (skipFrame)
			{
				skipFrame = false;
			}
			else
			{
				for each (var bar:Sprite in bars)
				{
					bar.alpha -= 1 / NUM_BARS;
					
					if (bar.alpha < 0)
					{
						bar.alpha = 1;
					}
				}
				skipFrame = true;
			}
		}
		
	}

}