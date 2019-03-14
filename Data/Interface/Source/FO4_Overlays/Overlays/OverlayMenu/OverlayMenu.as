package
{
	import com.greensock.*;
	import com.greensock.easing.*;
	import F4SE.ICodeObject;
	import flash.display.MovieClip;
	import System.Diagnostics.Debug;

	// TODO: Expose the "Client" string variable path to papyrus.

	public class OverlayMenu extends MovieClip implements F4SE.ICodeObject
	{
		// Stage
		public var Controller:MovieClip;

		// Loader
		private var Overlay:OverlayLoader;
		private const Name:String = "OverlayMenu";
		private const MountID:String = "OverlayMenu_ImageMount";

		// Properties
		public function get Visible():Boolean { return this.visible; }
		public function set Visible(value:Boolean):void { this.visible = value; }

		public function get Alpha():Number { return this.alpha; }
		public function set Alpha(value:Number):void { this.alpha = value; }


		// Initialize
		//---------------------------------------------

		public function OverlayMenu()
		{
			System.Diagnostics.Debug.Prefix = "Overlay Framework";
			Overlay = new OverlayLoader(Name, MountID);
			Controller.addChild(Overlay);
			Debug.WriteLine("[OverlayMenu]", "(ctor)", "Constructor Code", this.loaderInfo.url);
		}


		// @F4SE.ICodeObject
		public function onF4SEObjCreated(codeObject:*):void
		{
			Overlay.onF4SEObjCreated(codeObject);
		}


		// Methods
		//---------------------------------------------

		public function Load(filepath:String):void
		{
			Debug.WriteLine("[OverlayMenu]", "(Load)", "Setting the filepath to '"+filepath+"'.");
			Overlay.Load(filepath);
		}


		public function AlphaTo(value:Number, duration:Number):void
		{
			Debug.WriteLine("[OverlayMenu]", "(AlphaTo)", "Alpha is tweening from "+alpha+" to "+value+" over "+duration+" seconds.");
			TweenMax.to(Controller, duration, {alpha:value});
		}


	}
}
