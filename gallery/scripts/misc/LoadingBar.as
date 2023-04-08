package scripts.misc{
	import flash.display.MovieClip;
	import flash.events.Event;
	public class LoadingBar extends MovieClip {
		private var active:Boolean;
		private var fadeIn:Boolean;
		public function LoadingBar() {
			this.alpha=0;
			fadeIn = true;
		}
		public function init() {
			addEventListener(Event.ENTER_FRAME, fadeInOut);
			this.alpha=0;
		}
		public function fadeInOut(event_f:Event) {
			if (fadeIn) {
				this.alpha+=.03;
				if(this.alpha>=1){
					fadeIn=false;
				}
			} else {
				this.alpha-=.006;
				if(this.alpha<=0){
					fadeIn = true;
					removeEventListener(Event.ENTER_FRAME,fadeInOut)
				}
			}
		}
	}
}