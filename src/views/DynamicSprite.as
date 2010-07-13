package views
{
	import flash.display.Sprite;
	import flash.geom.Point;

	/**
	 * Extends MovieClip adding a dynamic registration point
	 *
	 * Based on AS2 work by Darron Schall (www.darronschall.com)
	 * Original AS1 code by Robert Penner (www.robertpenner.com)
	 *
	 * @author Oscar Trelles
	 * @version 1.0
	 * @created 12-Mar-2007 11:53:50 AM
	 */
	public class DynamicSprite extends Sprite
	{
		public var rp:Point;

		function DynamicSprite():void
		{
			setRegistration();
		}

		public function setRegistration(x:Number=0, y:Number=0):void
		{
			rp = new Point(x, y);
		}

		public function get x2():Number
		{
			var p:Point = this.parent.globalToLocal(this.localToGlobal(rp));
			return p.x;
		}

		public function set x2(value:Number):void
		{
			var p:Point = this.parent.globalToLocal(this.localToGlobal(rp));
			this.x += value - p.x;
		}

		public function get y2():Number
		{
			var p:Point = this.parent.globalToLocal(this.localToGlobal(rp));
			return p.y;
		}

		public function set y2(value:Number):void
		{
			var p:Point = this.parent.globalToLocal(this.localToGlobal(rp));
			this.y += value - p.y;
		}

		public function get scaleX2():Number
		{
			return this.scaleX;
		}

		public function set scaleX2(value:Number):void
		{
			this.setProperty2("scaleX", value);
		}

		public function get scaleY2():Number
		{
			return this.scaleY;
		}

		public function set scaleY2(value:Number):void
		{
			this.setProperty2("scaleY", value);
		}

		public function get rotation2():Number
		{
			return this.rotation;
		}

		public function set rotation2(value:Number):void
		{
			this.setProperty2("rotation", value);
		}

		public function get mouseX2():Number
		{
			return Math.round(this.mouseX - rp.x);
		}

		public function get mouseY2():Number
		{
			return Math.round(this.mouseY - rp.y);
		}

		public function setProperty2(prop:String, n:Number):void
		{
			var a:Point = this.parent.globalToLocal(this.localToGlobal(rp));

			this[prop] = n;

			var b:Point = this.parent.globalToLocal(this.localToGlobal(rp));

			this.x -= b.x - a.x;
			this.y -= b.y - a.y;
		}
	}
}