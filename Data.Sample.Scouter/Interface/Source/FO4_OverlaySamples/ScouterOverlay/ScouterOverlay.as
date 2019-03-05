package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import System.Diagnostics.Debug;
	import System.Display;

	public class ScouterOverlay extends MovieClip
	{
		public var TextBox1:TextClip;
		public var TextBox2:TextClip;
		public var TextBox3:TextClip;
		public var TextBox4:TextClip;
		public var TextBox5:TextClip;


		// Initialize
		//---------------------------------------------

		public function ScouterOverlay()
		{
			Debug.WriteLine("[ScouterOverlay]", "(ctor)", "Constructor Code");
			if (stage)
			{
				OnAddedToStage(null);
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, OnAddedToStage)
			}
		}


		private function OnAddedToStage(e:Event):void
		{
			Debug.WriteLine("[ScouterOverlay]", "(OnAddedToStage)");
			removeEventListener(Event.ADDED_TO_STAGE, OnAddedToStage);

			var rootMenu:MovieClip = MovieClip(stage.getChildAt(0));

			TextBox1.Label = "File";
			TextBox1.Value = rootMenu.loaderInfo.url;

			TextBox2.Label = "Instance";
			TextBox2.Value = Display.GetInstanceFrom(this, rootMenu);

			TextBox3.Label = "Test Test";
			TextBox3.Value = "Hello World!";

			TextBox4.Label = "Papyrus";
			TextBox4.Value = "Try setting this text field from papyrus!";

			TextBox5.Label = "Papyrus";
			TextBox5.Value = "Try setting this text field from papyrus!";
		}


	}
}
