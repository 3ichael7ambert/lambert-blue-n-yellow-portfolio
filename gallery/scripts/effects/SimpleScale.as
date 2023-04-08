package scripts.effects{
	import flash.events.*;
	import flash.display.MovieClip;
	import scripts.components.Share;

	//////
	//
	// Simple scale and class for MovieClips
	// my_mc.addEventListener(IQEffects.SimpleScale.FADE_COMPLETE,event_handler);
	// Currently scales in and out from 0 and 100 respectively, needs to adjust for current alpha level of target clip
	//
	//////
	public class SimpleScale {
		//private static var targetSet:Boolean=false;
		private var className:String="SimpleScale";
		public static var SCALE_COMPLETE:String="effectComplete";
		public function SimpleScale() {
		}
		public static function scaleWidth(target_f:MovieClip, scaleSpeed_f:Number, scaleSize:Number) {
			if (target_f!=null) {
				var scaleSpeed:Number=scaleSize-1==0?(1-target_f.scaleX)/scaleSpeed_f:(scaleSize-target_f.scaleX)/scaleSpeed_f;
				if (target_f.SimpleScaleW==null) {
					target_f.addEventListener(Event.ENTER_FRAME,scaleWidth_efh);
					target_f.SimpleScaleW = new Object();
					target_f.SimpleScaleW.scaleSpeed = new Number();
					target_f.SimpleScaleW.scaleExpire = new Number();
					target_f.SimpleScaleW.scaleCount = new Number();
				}
				target_f.SimpleScaleW.scaleCount=0;
				target_f.SimpleScaleW.scaleExpire=scaleSpeed_f-1;
				target_f.SimpleScaleW.scaleSpeed=scaleSpeed;
			}
		}
		private static function scaleWidth_efh(event_f:Event) {
			var target=event_f.currentTarget;
			target.scaleX+=target.SimpleScaleW.scaleSpeed;
			if (target.SimpleScaleW.scaleCount++>=target.SimpleScaleW.scaleExpire) {
				delete target.SimpleScaleW.scaleExpire;
				delete target.SimpleScaleW.scaleCount;
				delete target.SimpleScaleW.scaleSpeed;
				delete target.SimpleScaleW;
				target.removeEventListener(Event.ENTER_FRAME,scaleWidth_efh);
				target.dispatchEvent(new Event("effectComplete"));
			}
		}
		public static function scaleHeight(target_f:MovieClip, scaleSpeed_f:Number, scaleSize:Number) {
			if (target_f!=null) {
				var scaleSpeed:Number=scaleSize-1==0?(1-target_f.scaleY)/scaleSpeed_f:(scaleSize-target_f.scaleY)/scaleSpeed_f;
				if (target_f.SimpleScaleH==null) {
					target_f.addEventListener(Event.ENTER_FRAME,scaleHeight_efh);
					target_f.SimpleScaleH = new Object();
					target_f.SimpleScaleH.scaleSpeed = new Number();
					target_f.SimpleScaleH.scaleExpire = new Number();
					target_f.SimpleScaleH.scaleCount = new Number();
				}
				target_f.SimpleScaleH.scaleCount=0;
				target_f.SimpleScaleH.scaleExpire=scaleSpeed_f-1;
				target_f.SimpleScaleH.scaleSpeed=scaleSpeed;
			}
		}
		private static function scaleHeight_efh(event_f:Event) {
			var target=event_f.currentTarget;
			target.scaleY+=target.SimpleScaleH.scaleSpeed;
			if (target.SimpleScaleH.scaleCount++>=target.SimpleScaleH.scaleExpire) {
				delete target.SimpleScaleH.scaleExpire;
				delete target.SimpleScaleH.scaleCount;
				delete target.SimpleScaleH.scaleSpeed;
				delete target.SimpleScaleH;
				target.removeEventListener(Event.ENTER_FRAME,scaleHeight_efh);
				target.dispatchEvent(new Event("effectComplete"));
			}
		}
		public static function scaleDown(target_f:MovieClip,scaleSpeed_f:Number,scaleSize:Number) {
			if (target_f!=null) {
				var scaleSpeed:Number;
				scaleSpeed=scaleSize-1==0?(target_f.scaleX-1)/scaleSpeed_f:(-(target_f.scaleX-(scaleSize))/scaleSpeed_f);
				scaleSpeed=scaleSpeed*-1;
				if (target_f.SimpleScale==null) {
					target_f.addEventListener(Event.ENTER_FRAME,scale_efh);
					target_f.SimpleScale = new Object();
					target_f.SimpleScale.scaleSize = new Number();
					target_f.SimpleScale.scaleSpeed = new Number();
					target_f.SimpleScale.scaleExpire = new Number();
					target_f.SimpleScale.scaleCount = new Number();
				}
				target_f.SimpleScale.scaleSize=scaleSize-1==0?1:scaleSize;
				target_f.SimpleScale.scaleCount=0;
				target_f.SimpleScale.scaleExpire=scaleSpeed_f-1;
				target_f.SimpleScale.scaleSpeed=scaleSpeed;
			}
		}
		private static function scale_efh(event_f:Event) {
			var target=event_f.currentTarget;
			target.scaleX+=target.SimpleScale.scaleSpeed;
			target.scaleX=target.scaleX<0?0:target.scaleX;
			target.scaleY+=target.SimpleScale.scaleSpeed;
			if (target.SimpleScale.scaleCount++>=target.SimpleScale.scaleExpire) {
				target.scaleX=target.SimpleScale.scaleSize;
				target.scaleY=target.SimpleScale.scaleSize;
				delete target.SimpleScale.scaleExpire;
				delete target.SimpleScale.scaleCount;
				delete target.SimpleScale.scaleSpeed;
				delete target.SimpleScale;
				target.removeEventListener(Event.ENTER_FRAME,scale_efh);
				target.dispatchEvent(new Event("effectComplete"));
			}
		}
		public static function scaleUp(target_f:MovieClip,scaleSpeed_f:Number,scaleSize:Number) {
			if (target_f!=null) {
				var scaleSpeed:Number=scaleSize-1==0?1:(scaleSize-1)/scaleSpeed_f;
				if (target_f.SimpleScale==null) {
					target_f.addEventListener(Event.ENTER_FRAME,scale_efh);
					target_f.SimpleScale = new Object();
					target_f.SimpleScale.scaleSize = new Number();
					target_f.SimpleScale.scaleSpeed = new Number();
					target_f.SimpleScale.scaleExpire = new Number();
					target_f.SimpleScale.scaleCount = new Number();
				}
				target_f.SimpleScale.scaleSize=scaleSize;
				target_f.SimpleScale.scaleCount=0;
				target_f.SimpleScale.scaleExpire=scaleSpeed_f-1;
				target_f.SimpleScale.scaleSpeed=scaleSpeed;
			}
		}
	}
}