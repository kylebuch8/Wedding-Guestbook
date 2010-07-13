package views 
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import caurina.transitions.Tweener;
	
	/**
	 * ...
	 * @author Kyle Buchanan
	 */
	public class Wall extends Sprite
	{
		private var _centerPoint:Point;
		
		public function Wall(pCenterPoint:Point) 
		{
			_centerPoint = pCenterPoint;
			this.mouseChildren = false;
			this.doubleClickEnabled = true;
		}
		
		public function move(pPoint:Point):void
		{
			trace("Wall :: move()");
			if (!Tweener.isTweening(this))
			{
				Tweener.addTween(this, { x: this.x + pPoint.x, y: this.y + pPoint.y, time: 1, transition: "easeInOutCubic" } );
			}
		}
		
		// Getter and Setter Methods
		public function get centerPoint():Point { return _centerPoint; }
		public function set centerPoint(pPoint:Point):void { _centerPoint = pPoint; }
		
	}

}