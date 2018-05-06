package
{
	import flash.display.MovieClip;

	public class Overlay extends MovieClip
	{
		public function get Visible():Boolean { return this.visible; }
		public function set Visible(argument:Boolean):void { this.visible = argument; }

		public function Overlay()
		{
			// constructor code
			trace("Halo Helmet");
		}


	}
}
