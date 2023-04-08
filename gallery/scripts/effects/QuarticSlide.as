package scripts.effects{
	import flash.events.*;
	import flash.display.MovieClip;
	import fl.motion.easing.*;
	//////
	//
	// QuarticSlide and class for MovieClips, Broadcasts Complete ie.
	// my_mc.addEventListener(IQEffects.QuarticSlide.SLIDE_COMPLETE,event_handler);
	// Slidespeed is equal to the number of frames it will take to complete the slide
	//
	//////
	//
	public class QuarticSlide {
		private static  var targetSet:Boolean=false;
		public static  var EFFECT_COMPLETE:String = "effectComplete";
		public function QuarticSlide() {
			//
		}
		public static function slideRight(target_f:MovieClip,slideSpeed_f:Number, slideDistance_f:Number) {
			var startX:Number=target_f.x;
			var distX:Number=slideDistance_f;
			var startY:Number = target_f.y;
			var distY:Number = 0;
			//
			setVars(target_f,slideSpeed_f,startX,distX,startY,distY);
		}
		public static function slideLeft(target_f:MovieClip,slideSpeed_f:Number, slideDistance_f:Number) {
			var startX:Number=target_f.x;
			var distX:Number=slideDistance_f*-1;
			var startY:Number = target_f.y;
			var distY:Number = 0;
			//
			setVars(target_f,slideSpeed_f,startX,distX,startY,distY);
		}
		public static function slideUp(target_f:MovieClip,slideSpeed_f:Number, slideDistance_f:Number) {
			var startX:Number=target_f.x;
			var distX:Number=0;
			var startY:Number = target_f.y;
			var distY:Number =slideDistance_f*-1;
			//
			setVars(target_f,slideSpeed_f,startX,distX,startY,distY);
		}
		public static function slideDown(target_f:MovieClip,slideSpeed_f:Number, slideDistance_f:Number) {
			var startX:Number=target_f.x;
			var distX:Number=0;
			var startY:Number = target_f.y;
			var distY:Number =slideDistance_f;
			//
			setVars(target_f,slideSpeed_f,startX,distX,startY,distY);
		}

		private static function setVars(target_f:MovieClip,slideSpeed_f:Number,startX_f:Number,distX_f:Number,startY_f:Number,distY_f:Number) {
			target_f.addEventListener(Event.ENTER_FRAME,slide_efh);
			target_f.QuarticSlide = new Object();
			target_f.QuarticSlide.slideSpeed = new Number();
			target_f.QuarticSlide.slideCount = new Number();
			target_f.QuarticSlide.slideStartX = new Number();
			target_f.QuarticSlide.slideX = new Number();
			target_f.QuarticSlide.slideStartY = new Number();
			target_f.QuarticSlide.slideY = new Number();
			target_f.QuarticSlide.slideStartX=startX_f;
			target_f.QuarticSlide.slideX=distX_f;
			target_f.QuarticSlide.slideStartY=startY_f;
			target_f.QuarticSlide.slideY=distY_f;
			target_f.QuarticSlide.slideCount = 0;
			target_f.QuarticSlide.slideSpeed=slideSpeed_f;
		}

		private static function slide_efh(event_f:Event) {
			var target = event_f.currentTarget;
			target.QuarticSlide.slideCount++;
			target.x =fl.motion.easing.Quartic.easeOut(target.QuarticSlide.slideCount,target.QuarticSlide.slideStartX,target.QuarticSlide.slideX,target.QuarticSlide.slideSpeed);
			target.y =fl.motion.easing.Quartic.easeOut(target.QuarticSlide.slideCount,target.QuarticSlide.slideStartY,target.QuarticSlide.slideY,target.QuarticSlide.slideSpeed);

			if (target.QuarticSlide.slideCount>target.QuarticSlide.slideSpeed) {
				target.x=target.QuarticSlide.slideStartX+target.QuarticSlide.slideX;
				target.y=target.QuarticSlide.slideStartY+target.QuarticSlide.slideY;
				//target.dispatchEvent(new Event("SlideComplete"));
				target.removeEventListener(Event.ENTER_FRAME, slide_efh);
				delete target.QuarticSlide.slideCount;
				delete target.QuarticSlide.slideSpeed;
				delete target.QuarticSlide.slideStartX;
				delete target.QuarticSlide.slideX;
				delete target.QuarticSlide.slideStartY;
				delete target.QuarticSlide.slideY;
				delete target.QuarticSlide;
				target.dispatchEvent(new Event("effectComplete"));
			}
		}
	}
}