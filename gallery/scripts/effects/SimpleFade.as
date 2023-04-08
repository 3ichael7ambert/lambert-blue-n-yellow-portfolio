package scripts.effects{
	import flash.events.*;
	import flash.display.MovieClip;
	import scripts.components.Share;

	//////
	//
	// Simple fade and class for MovieClips
	// my_mc.addEventListener(IQEffects.SimpleFade.FADE_COMPLETE,event_handler);
	// Currently fades in and out from 0 and 100 respectively, needs to adjust for current alpha level of target clip
	//
	//////
	public class SimpleFade {
		//private static var targetSet:Boolean=false;
		private var className:String ="SimpleFade";
		public static  var FADE_COMPLETE:String = "effectComplete";
		public function SimpleFade() {
		}
		public static function fadeOut(target_f:MovieClip,fadeSpeed_f:Number) {
			var fadeSpeed:Number=(100/fadeSpeed_f)*.01;
			fadeSpeed=fadeSpeed*-1;
			if (target_f.SimpleFade==null) {
				target_f.addEventListener(Event.ENTER_FRAME,fade_efh);
				target_f.SimpleFade = new Object();
				target_f.SimpleFade.fadeSpeed = new Number();
				target_f.SimpleFade.fadeExpire = new Number();
				target_f.SimpleFade.fadeCount = new Number();
			}
			target_f.SimpleFade.fadeCount = 0;
			target_f.SimpleFade.fadeExpire = fadeSpeed_f;
			target_f.SimpleFade.fadeSpeed=fadeSpeed;

		}
		private static function fade_efh(event_f:Event) {
			var target = event_f.currentTarget;
			target.alpha+=target.SimpleFade.fadeSpeed;
			if (target.SimpleFade.fadeCount++>=target.SimpleFade.fadeExpire) {
				target.alpha = target.SimpleFade.fadeSpeed<0 ? 0 : 1;
				target.visible=target.alpha==0 ? false: true;
				delete target.SimpleFade.fadeExpire;
				delete target.SimpleFade.fadeCount;
				delete target.SimpleFade.fadeSpeed;
				delete target.SimpleFade;
				target.removeEventListener(Event.ENTER_FRAME,fade_efh);
				target.dispatchEvent(new Event("effectComplete"));
			}
		}
		public static function fadeIn(target_f:MovieClip,fadeSpeed_f:Number) {
			
			var fadeSpeed:Number=(100/fadeSpeed_f)*.01;
			if (target_f.SimpleFade==null) {
				target_f.visible=true;
				target_f.addEventListener(Event.ENTER_FRAME,fade_efh);
				target_f.SimpleFade = new Object();
				target_f.SimpleFade.fadeSpeed = new Number();
				target_f.SimpleFade.fadeExpire = new Number();
				target_f.SimpleFade.fadeCount = new Number();
			}
			target_f.SimpleFade.fadeCount = 0;
			target_f.SimpleFade.fadeExpire = fadeSpeed_f;
			target_f.SimpleFade.fadeSpeed=fadeSpeed;
		}
	}
}