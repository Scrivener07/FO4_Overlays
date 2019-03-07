package
{
	import Components.LoaderType;
	import F4SE.Extensions;
	import flash.display.MovieClip;
	import flash.events.Event;
	import System.Diagnostics.Debug;
	import System.Diagnostics.Utility;
	import System.Display;
	import System.IO.File;
	import System.IO.FileSystem;
	import System.IO.Path;

	/**
	 * This still wont switch from one overlay to another.
	 * Unloading the entire menu makes it work. (unequipping)
	 */
	public dynamic class OverlayLoader extends LoaderType
	{

		// Initialize
		//---------------------------------------------

		public function OverlayLoader(menuName:String, mountID:String)
		{
			super(menuName, mountID);
		}


		// Events
		//---------------------------------------------

		override protected function OnLoadComplete(e:Event):void
		{
			Display.ScaleToHeight(Content, Display.DefaultHeight);
			super.OnLoadComplete(e);
			Utility.TraceDisplayList(MovieClip(stage.getChildAt(0)));
			Debug.WriteLine("[OverlayLoader]", "(OnLoadComplete)", e.toString()+", "+toString());
		}


		// Methods
		//---------------------------------------------

		override public function Load(filepath:String):Boolean
		{
			var extension:String = Path.GetExtension(filepath);
			var path:String = filepath;

			if (extension == File.NIF)
			{
				extension = File.SWF;
				path = Path.ChangeExtension(filepath, extension);
			}

			if (extension == File.SWF && File.ExistsIn(XSE, FileSystem.Interface, path))
			{
				Debug.WriteLine("[OverlayLoader]", "Found SWF:", "path:"+path);
				return super.Load(path);
			}
			else
			{
				extension = File.DDS;
				path = Path.ChangeExtension(filepath, extension);
			}

			if (extension == File.DDS && File.ExistsIn(XSE, FileSystem.Textures, path))
			{
				Debug.WriteLine("[OverlayLoader]", "Found DDS:", "path:"+path);
				return super.Load(path);
			}
			else
			{
				Debug.WriteLine("[OverlayLoader]", "No overlay file was found.");
				Unload();
				return false;
			}
		}


	}
}
