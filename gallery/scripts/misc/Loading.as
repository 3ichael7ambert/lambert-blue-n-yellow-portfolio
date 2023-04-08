package scripts.misc{
	import flash.display.MovieClip;
	import flash.events.Event;
	public class Loading extends MovieClip {
		private var active:Boolean;
		public var bar1:LoadingBar;
		public var bar2:LoadingBar;
		public var bar3:LoadingBar;
		public var bar4:LoadingBar;
		public var bar5:LoadingBar;
		public var bar6:LoadingBar;
		public var bar7:LoadingBar;
		public var bar8:LoadingBar;
		private var speed:Number;
		private var counter:Number;
		private var currentBar:Number;
		private var bars:Number = 8;
		public function Loading() {
			currentBar = new Number;
			currentBar =1;
			speed = new Number();
			speed = 20;
			counter = new Number();
			counter =20;

			addEventListener(Event.ENTER_FRAME, loaderCoordinator);
		}
		private function loaderCoordinator(event:Event) {
			if (counter++>speed) {
				switch (currentBar) {
					case 1 :
						bar1.init();
						break;
					case 2 :
						bar2.init();
						break;
					case 3 :
						bar3.init();
						break;
					case 4 :
						bar4.init();
						break;
					case 5 :
						bar5.init();
						break;
					case 6 :
						bar6.init();
						break;
					case 7 :
						bar7.init();
						break;
					case 8 :
						bar8.init();
						break;

				}
				//bar1.addEventListener(Event.ENTER_FRAME, fadeInOut);
				currentBar++;
				if (currentBar>bars) {
					currentBar=1;
					//removeEventListener(Event.ENTER_FRAME, loaderCoordinator);
				}
				counter = 0;
			}
		}
		public function kill() {
			removeEventListener(Event.ENTER_FRAME, loaderCoordinator);
			delete this;
		}

	}
}