package
{
	import com.greensock.*;
	import com.greensock.easing.*;
	import Components.AssetLoader;
	import F4SE.Extensions;
	import F4SE.ICodeObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import System.Diagnostics.Debug;
	import System.Diagnostics.Utility;

	public class OverlayMenu extends MovieClip implements F4SE.ICodeObject
	{
		// Stage
		public var Controller:MovieClip;

		// Loader
		private var Overlay:OverlayLoader;
		private const Name:String = "OverlayMenu";
		private const MountID:String = "OverlayMenu_ImageMount";

		// Client
		private const ClientLoadedCallback:String = "OverlayMenu_ClientLoadedCallback";

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
			this.addEventListener(Event.ADDED_TO_STAGE, this.OnAddedToStage);
			Debug.WriteLine("[OverlayMenu]", "(ctor)", "Constructor Code", this.loaderInfo.url);
		}


		private function OnAddedToStage(e:Event):void
		{
			Overlay = new OverlayLoader(Name, MountID);
			Overlay.addEventListener(AssetLoader.LOAD_COMPLETE, this.OnLoadComplete);
			Overlay.addEventListener(AssetLoader.LOAD_ERROR, this.OnLoadError);
			Controller.addChild(Overlay);
			Debug.WriteLine("[OverlayMenu]", "(OnAddedToStage)");
		}


		// @F4SE.ICodeObject
		public function onF4SEObjCreated(codeObject:*):void
		{
			F4SE.Extensions.API = codeObject;
			Debug.WriteLine("[OverlayMenu]", "(onF4SEObjCreated)");
		}

		// Events
		//---------------------------------------------

		private function OnLoadComplete(e:Event):void
		{
			var client:String = GetClient();
			Extensions.SendExternalEvent(ClientLoadedCallback, true, client);
			Debug.WriteLine("[OverlayMenu]", "(OnLoadComplete)", "Overlay found at '"+Overlay.FilePath+"' with client instance of '"+client+"'.");
		}


		private function OnLoadError(e:IOErrorEvent):void
		{
			Extensions.SendExternalEvent(ClientLoadedCallback, false, null);
			Debug.WriteLine("[OverlayMenu]", "(OnLoadError)", "No overlay found at '"+Overlay.FilePath+"'.");
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


		/**
		 * Gets the instance variable to the loaded client overlay.
		 */
		public function GetClient():String
		{
			return Overlay.GetInstance();
		}


	}
}
