package
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import Shared.AS3.Debug;

	public class TextClip extends MovieClip
	{

		public var Label_tf:TextField;
		public function get Label():String { return Label_tf.text; }
		public function set Label(value:String):void { Label_tf.text = value; }


		public var Value_tf:TextField;
		public function get Value():String { return Value_tf.text; }
		public function set Value(value:String):void { Value_tf.text = value; }

		// Initialize
		//---------------------------------------------

		public function TextClip()
		{
			Debug.WriteLine("[TextClip]", "(ctor)", "Constructor Code");
			Label = "";
			Value = "";
		}

	}
}
