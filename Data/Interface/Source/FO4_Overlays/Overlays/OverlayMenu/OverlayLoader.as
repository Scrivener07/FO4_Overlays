package
{
	import Components.LoaderType;
	import F4SE.Extensions;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import System.Diagnostics.Debug;
	import System.Diagnostics.Utility;
	import System.Display;
	import System.IO.File;
	import System.IO.FileSystem;
	import System.IO.Path;

	/**
	 * TODO: Check `Debug.WriteLine` for correct member names.
	 * TODO: See about `File.Exists` for other loadable file types.
	 */
	public dynamic class OverlayLoader extends LoaderType
	{
		private static const ImageMountID:String = "OverlayMenu_ImageMount";

		// Initialize
		//---------------------------------------------

		// Events
		//---------------------------------------------

		override protected function OnLoadComplete(e:Event):void
		{
			// Note: Scale to default height of 720 works for dds files. The stage height works for swf files.
			Display.ScaleToHeight(Content, Display.DefaultHeight);
			super.OnLoadComplete(e);
			Utility.TraceDisplayList(MovieClip(stage.getChildAt(0)));
			Debug.WriteLine("[OverlayLoader]", "(OnLoadComplete)", e.toString()+", "+toString());
		}


		override protected function OnLoadError(e:IOErrorEvent):void
		{
			var extension:String = Path.GetExtension(FilePath)

			if (extension == File.SWF)
			{
				var filepath = Path.ChangeExtension(FilePath, File.DDS);
				if (File.ExistsIn(XSE, FileSystem.Textures, filepath))
				{
					Unmount(FilePath);
					F4SE.Extensions.MountImage(XSE, OverlayMenu.Name, filepath, ImageMountID);
					Load(filepath, "img://"+ImageMountID);
					Debug.WriteLine("[OverlayLoader]", "(OnLoadError)", "No SWF file was found, converting file path from '"+FilePath+"' to '"+filepath+"'.");
				}
				else
				{
					Debug.WriteLine("[OverlayLoader]", "(OnLoadError)", "The file '"+filepath+"' does not exist.");
				}
			}
			else if (extension == File.DDS)
			{
				Debug.WriteLine("[OverlayLoader]", "(OnLoadError)", "No overlay file was found.", FilePath);
			}
			else
			{
				Debug.WriteLine("[OverlayLoader]", "(OnLoadError)", e.toString()+", The error was unhandled. "+toString());
			}

			this.dispatchEvent(new Event(LOAD_ERROR));
		}


		// Methods
		//---------------------------------------------

		// (?) Allow initial filepath to go through, then switch extensions in the Error event.
		override public function Load(filepath:String, mountID:String=null):Boolean
		{
			// Swap any NIF file path to SWF.
			var extension:String = Path.GetExtension(filepath);
			if (extension == File.NIF)
			{
				extension = File.SWF;
				filepath = Path.ChangeExtension(filepath, extension);
			}

			if (extension == File.SWF)
			{
				return super.Load(filepath);
			}
			else if (extension == File.DDS)
			{
				if (File.ExistsIn(XSE, FileSystem.Textures, filepath))
				{
					Debug.WriteLine("[OverlayLoader]", "(Load)", "DDS: '"+ImageMountID+"' as '"+filepath+"'.", "OLD:"+FilePath);
					Unmount(FilePath);
					F4SE.Extensions.MountImage(XSE, OverlayMenu.Name, filepath, ImageMountID);
					return super.Load(filepath, "img://"+ImageMountID);
				}
				else
				{
					Debug.WriteLine("[OverlayLoader]", "(Load)", "File does not exist. '"+filepath+"'.");
					return false;
				}
			}
			else
			{
				Debug.WriteLine("[OverlayLoader]", "(Load)", "Unhandled: '"+filepath+"' with extension '"+extension+"'.");
				return false;
			}
		}


		// override public function Unload():Boolean
		// {
		// 	return super.Unload();
		// }


		private function Unmount(filepath:String):Boolean
		{
			if (filepath != null)
			{
				if (Path.GetExtension(filepath) == File.DDS)
				{
					F4SE.Extensions.UnmountImage(XSE, OverlayMenu.Name, filepath);
					Debug.WriteLine("[OverlayLoader]", "(Unmount)", "Unmounted the texture '"+filepath+"' from "+OverlayMenu.Name+" with resource ID "+ImageMountID);
					return true;
				}
				else
				{
					Debug.WriteLine("[OverlayLoader]", "(Unmount)", "Only DDS texture files may be unmounted. '"+filepath+"'");
					return false;
				}
			}
			else
			{
				Debug.WriteLine("[OverlayLoader]", "(Unmount)", "Cannot unmount a null filepath.");
				return false;
			}
		}

		// Functions
		//---------------------------------------------

		// override public function toString():String
		// {
		// 	var sResolution = "Resolution: "+stage.width+"x"+stage.height;
		// 	var sPosition = " Position: "+this.x+"x"+this.y;
		// 	var sURI = "Uri: '"+Uri+"'";
		// 	var sLastFile = "Requested: '"+Requested+"'";
		// 	var sUrl = "Url: '"+Url+"'";
		// 	return sResolution+", "+sPosition+", "+sURI+", "+sLastFile+", "+sUrl;
		// }


	}
}
