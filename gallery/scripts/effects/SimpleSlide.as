package scripts.effects{
	import flash.events.*;
	import flash.display.MovieClip;
	import fl.motion.easing.*;
	//////
	//
	// SimpleSlide and class for MovieClips, Broadcasts Complete ie.
	// my_mc.addEventListener(IQEffects.SimpleSlide.SLIDE_COMPLETE,event_handler);
	// Slidespeed is equal to the number of frames it will take to complete the slide
	//
	//////
	//
	public class SimpleSlide {
		private static var targetSet:Boolean=false;
		public static var EFFECT_COMPLETE:String="effectComplete";
		public function SimpleSlide() {
			//
		}
		public static function slideRight(target_f:MovieClip,slideSpeed_f:Number,slideDistance_f:Number) {
			var startX:Number=target_f.x;
			var distX:Number=slideDistance_f;
			var startY:Number=target_f.y;
			var distY:Number=0;
			//
			setVars(target_f,slideSpeed_f,startX,distX,startY,distY);
		}
		public static function slideLeft(target_f:MovieClip,slideSpeed_f:Number,slideDistance_f:Number) {
			var startX:Number=target_f.x;
			var distX:Number=slideDistance_f*-1;
			var startY:Number=target_f.y;
			var distY:Number=0;
			//
			setVars(target_f,slideSpeed_f,startX,distX,startY,distY);
		}
		public static function slideUp(target_f:MovieClip,slideSpeed_f:Number,slideDistance_f:Number) {
			var startX:Number=target_f.x;
			var distX:Number=0;
			var startY:Number=target_f.y;
			var distY:Number=slideDistance_f*-1;
			//
			setVars(target_f,slideSpeed_f,startX,distX,startY,distY);
		}
		public static function slideDown(target_f:MovieClip,slideSpeed_f:Number,slideDistance_f:Number) {
			var startX:Number=target_f.x;
			var distX:Number=0;
			var startY:Number=target_f.y;
			var distY:Number=slideDistance_f;
			//
			setVars(target_f,slideSpeed_f,startX,distX,startY,distY);
		}

		private static function setVars(target_f:MovieClip,slideSpeed_f:Number,startX_f:Number,distX_f:Number,startY_f:Number,distY_f:Number) {
			if (target_f.SimpleSlide==null) {
				target_f.addEventListener(Event.ENTER_FRAME,slide_efh);
				target_f.SimpleSlide=new Object  ;
				target_f.SimpleSlide.slideSpeed=new Number();
				target_f.SimpleSlide.slideCount=new Number();
				target_f.SimpleSlide.slideStartX=new Number();
				target_f.SimpleSlide.slideX=new Number();
				target_f.SimpleSlide.slideStartY=new Number();
				target_f.SimpleSlide.slideY=new Number();
				target_f.SimpleSlide.slideStartX=startX_f;
				target_f.SimpleSlide.slideX=distX_f;
				target_f.SimpleSlide.slideStartY=startY_f;
				target_f.SimpleSlide.slideY=distY_f;
				target_f.SimpleSlide.slideCount=0;
				target_f.SimpleSlide.slideSpeed=slideSpeed_f;
			} else {
				target_f.removeEventListener(Event.ENTER_FRAME,slide_efh);
				target_f.addEventListener(Event.ENTER_FRAME,slide_efh);
				target_f.SimpleSlide=new Object  ;
				target_f.SimpleSlide.slideSpeed=new Number();
				target_f.SimpleSlide.slideCount=new Number();
				target_f.SimpleSlide.slideStartX=new Number();
				target_f.SimpleSlide.slideX=new Number();
				target_f.SimpleSlide.slideStartY=new Number();
				target_f.SimpleSlide.slideY=new Number();
				target_f.SimpleSlide.slideStartX=startX_f;
				target_f.SimpleSlide.slideX=distX_f;
				target_f.SimpleSlide.slideStartY=startY_f;
				target_f.SimpleSlide.slideY=distY_f;
				target_f.SimpleSlide.slideCount=0;
				target_f.SimpleSlide.slideSpeed=slideSpeed_f;
			}
		}
		private static function slide_efh(event_f:Event) {
			var target=event_f.currentTarget;
			target.SimpleSlide.slideCount++;
			target.x=fl.motion.easing.Linear.easeOut(target.SimpleSlide.slideCount,target.SimpleSlide.slideStartX,target.SimpleSlide.slideX,target.SimpleSlide.slideSpeed);
			target.y=fl.motion.easing.Linear.easeOut(target.SimpleSlide.slideCount,target.SimpleSlide.slideStartY,target.SimpleSlide.slideY,target.SimpleSlide.slideSpeed);
			if (target.SimpleSlide.slideCount>target.SimpleSlide.slideSpeed) {
				target.x=target.SimpleSlide.slideStartX+target.SimpleSlide.slideX;
				target.y=target.SimpleSlide.slideStartY+target.SimpleSlide.slideY;
				//target.dispatchEvent(new Event("SlideComplete"));
				target.removeEventListener(Event.ENTER_FRAME,slide_efh);
				delete target.SimpleSlide.slideCount;
				delete target.SimpleSlide.slideSpeed;
				delete target.SimpleSlide.slideStartX;
				delete target.SimpleSlide.slideX;
				delete target.SimpleSlide.slideStartY;
				delete target.SimpleSlide.slideY;
				delete target.SimpleSlide;
				target.dispatchEvent(new Event("effectComplete"));
			}
		}
	}
}