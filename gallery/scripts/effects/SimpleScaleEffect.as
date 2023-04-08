package scripts.effects{
	import flash.events.*;
	import flash.display.MovieClip;
	import fl.motion.easing.*;
	import fl.transitions.Tween
	import fl.transitions.TweenEvent
	import scripts.components.Share;

	//////
	//
	// Simple scale and class for MovieClips
	// my_mc.addEventListener(IQEffects.SimpleScaleEffect.FADE_COMPLETE,event_handler);
	// Currently scales in and out from 0 and 100 respectively, needs to adjust for current alpha level of target clip
	//
	//////

	public class SimpleScaleEffect {
		//private static var targetSet:Boolean=false;
		private var className:String="SimpleScaleEffect";
		public static var SCALE_COMPLETE:String="effectComplete";
		private static var scaleEffectType:String;
		public function SimpleScaleEffect() {
		}
		private static function scale(target_f:Object) {
			var target=target_f
			switch (scaleEffectType) {
				case "bounce" :
					target.SimpleScaleEffect.inTweenX=new Tween(target,"scaleX",Bounce.easeOut,target.scaleX,target.SimpleScaleEffect.scaleSize,target.SimpleScaleEffect.scaleSpeed);
					target.SimpleScaleEffect.inTweenY=new Tween(target,"scaleY",Bounce.easeOut,target.scaleY,target.SimpleScaleEffect.scaleSize,target.SimpleScaleEffect.scaleSpeed);
					target.SimpleScaleEffect.inTweenY.addEventListener(TweenEvent.MOTION_FINISH, killTween_eh)
					break;
				case "elastic" :
					target.SimpleScaleEffect.inTweenX=new Tween(target,"scaleX",Elastic.easeOut,target.scaleX,target.SimpleScaleEffect.scaleSize,target.SimpleScaleEffect.scaleSpeed);
					target.SimpleScaleEffect.inTweenY=new Tween(target,"scaleY",Elastic.easeOut,target.scaleY,target.SimpleScaleEffect.scaleSize,target.SimpleScaleEffect.scaleSpeed);
					target.SimpleScaleEffect.inTweenY.addEventListener(TweenEvent.MOTION_FINISH, killTween_eh)
					break;
			}

		}
		private static function killTween_eh(event_f:Event){
			var target = event_f.target.obj
			event_f.target.removeEventListener(TweenEvent.MOTION_FINISH, killTween_eh)
			try{
				delete target.SimpleScaleEffect.scaleSize
		 		delete target.SimpleScaleEffect.scaleSpeed
		 		delete target.SimpleScaleEffect
			}catch(e){
			}
		}
		public static function scaleEffect(target_f:MovieClip,scaleSpeed_f:Number,scaleSize:Number,scaleType:String) {
			if (target_f!=null) {
				scaleEffectType=scaleType;
				if (target_f.SimpleScaleEffect==null) {
					target_f.SimpleScaleEffect=new Object();
					target_f.SimpleScaleEffect.scaleSize=new Number();
					target_f.SimpleScaleEffect.scaleSpeed=new Number();
				}
				target_f.SimpleScaleEffect.scaleSize=scaleSize
				target_f.SimpleScaleEffect.scaleSpeed=scaleSpeed_f;
				scale(target_f);
			}
		}
	}
}