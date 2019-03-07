package
{
	import flash.display.MovieClip;
	import System.Diagnostics.Debug;

	public class OverlayMenu extends MovieClip
	{
		public var Overlay:OverlayLoader;
		private const Name:String = "OverlayMenu";
		private const MountID:String = "OverlayMenu_ImageMount";

		public function get Visible():Boolean { return this.visible; }
		public function set Visible(value:Boolean):void { this.visible = value; }

		public function get Alpha():Number { return this.alpha; }
		public function set Alpha(value:Number):void { this.alpha = value; }


		// Initialize
		//---------------------------------------------

		public function OverlayMenu()
		{
			System.Diagnostics.Debug.Prefix = "Overlay Framework";
			Overlay.MenuName = Name;
			Overlay.MountID = MountID;
			Debug.WriteLine("[OverlayMenu]", "(ctor)", "Constructor Code", this.loaderInfo.url);
		}


		// Methods
		//---------------------------------------------

		public function SetURI(filepath:String):void
		{
			Debug.WriteLine("[OverlayMenu]", "(SetURI)", "Setting the filepath to '"+filepath+"'");
			Overlay.Load(filepath);
		}


	}
}
