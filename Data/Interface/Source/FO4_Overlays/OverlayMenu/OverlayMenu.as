package
{
	import flash.display.MovieClip;

	public class OverlayMenu extends MovieClip
	{
		public function get Visible():Boolean { return this.visible; }
		public function set Visible(argument:Boolean):void { this.visible = argument; }

		public function OverlayMenu()
		{
			// constructor code
			trace("helmet overlays, derp derp");
		}

	}
}
