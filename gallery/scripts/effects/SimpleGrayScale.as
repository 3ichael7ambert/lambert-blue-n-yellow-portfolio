package scripts.effects{
	import flash.events.*;
	import flash.display.MovieClip;
	import scripts.components.Share;
	import fl.motion.ColorMatrix;
	import flash.geom.ColorTransform;
	import flash.filters.ColorMatrixFilter;

	public class SimpleGrayScale {
		private var className:String="SimpleScale";
		public static var EFFECT_COMPLETE:String="effectComplete";
		public function SimpleGrayScale() {

		}
		public static function toGray(target_f:MovieClip,speed_f:Number) {
			if (target_f!=null) {
				if (target_f.SimpleGrayScale==null) {
					target_f.SimpleGrayScale=new Object();
					target_f.SimpleGrayScale.grayLevel=speed_f;
					target_f.SimpleGrayScale.transSpeed=.67/speed_f;
					target_f.SimpleGrayScale.colorMatrix=1;
					target_f.SimpleGrayScale.colorMatrix2=0;
					target_f.SimpleGrayScale.counter=0;
					target_f.addEventListener(Event.ENTER_FRAME,toGray_eh);
				} else {
					target_f.removeEventListener(Event.ENTER_FRAME,toColor_eh);
					target_f.removeEventListener(Event.ENTER_FRAME,toGray_eh);
					target_f.SimpleGrayScale.grayLevel=speed_f;
					target_f.SimpleGrayScale.transSpeed=(target_f.SimpleGrayScale.colorMatrix-.33)/speed_f;
					target_f.SimpleGrayScale.counter=0;
					target_f.addEventListener(Event.ENTER_FRAME,toGray_eh);
				}
			}
		}
		private static function toGray_eh(event_f:Event) {
			var target=event_f.currentTarget;
			var matrix:Array=new Array ();
			if (target.SimpleGrayScale.counter++>=target.SimpleGrayScale.grayLevel) {
				target.removeEventListener(Event.ENTER_FRAME,toGray_eh);
				delete target.SimpleGrayScale.grayLevel;
				delete target.SimpleGrayScale.transSpeed;
				delete target.SimpleGrayScale.colorMatrix;
				delete target.SimpleGrayScale.counter;
				delete target.SimpleGrayScale;
				target.dispatchEvent(new Event("effectComplete"));
			} else {
				matrix=matrix.concat([target.SimpleGrayScale.colorMatrix-target.SimpleGrayScale.transSpeed,target.SimpleGrayScale.colorMatrix2+(target.SimpleGrayScale.transSpeed)/2,target.SimpleGrayScale.colorMatrix2+(target.SimpleGrayScale.transSpeed)/2,0,0]);// red
				matrix=matrix.concat([target.SimpleGrayScale.colorMatrix2+(target.SimpleGrayScale.transSpeed)/2,target.SimpleGrayScale.colorMatrix-target.SimpleGrayScale.transSpeed,target.SimpleGrayScale.colorMatrix2+(target.SimpleGrayScale.transSpeed)/2,0,0]);// green
				matrix=matrix.concat([target.SimpleGrayScale.colorMatrix2+(target.SimpleGrayScale.transSpeed)/2,target.SimpleGrayScale.colorMatrix2+(target.SimpleGrayScale.transSpeed)/2,target.SimpleGrayScale.colorMatrix-target.SimpleGrayScale.transSpeed,0,0]);// blue
				matrix=matrix.concat([0,0,0,1,0]);// alpha
				target.SimpleGrayScale.colorMatrix=target.SimpleGrayScale.colorMatrix-target.SimpleGrayScale.transSpeed;
				target.SimpleGrayScale.colorMatrix2=target.SimpleGrayScale.colorMatrix2+(target.SimpleGrayScale.transSpeed)/2;
				var filter:ColorMatrixFilter=new ColorMatrixFilter(matrix);
				var mfilters:Array=new Array  ;
				mfilters.push(filter);
				target.filters=mfilters;
			}
		}
		public static function toColor(target_f:MovieClip,speed_f:Number) {
			if (target_f!=null) {
				if (target_f.SimpleGrayScale==null) {
					target_f.SimpleGrayScale=new Object();
					target_f.SimpleGrayScale.grayLevel=speed_f;
					target_f.SimpleGrayScale.transSpeed=(.67/speed_f);
					target_f.SimpleGrayScale.colorMatrix=.33;
					target_f.SimpleGrayScale.colorMatrix2=.33;
					target_f.SimpleGrayScale.counter=0;
					target_f.addEventListener(Event.ENTER_FRAME,toColor_eh);
				} else {
					target_f.removeEventListener(Event.ENTER_FRAME,toColor_eh);
					target_f.removeEventListener(Event.ENTER_FRAME,toGray_eh);
					target_f.SimpleGrayScale.grayLevel=speed_f;
					target_f.SimpleGrayScale.transSpeed=(1-target_f.SimpleGrayScale.colorMatrix)/speed_f;
					target_f.SimpleGrayScale.counter=0;
					target_f.addEventListener(Event.ENTER_FRAME,toColor_eh);
				}
			}
		}
		public static function toColor_eh(event_f:Event) {
			var target=event_f.currentTarget;
			var matrix:Array=new Array ();

			if (target.SimpleGrayScale.counter++>=target.SimpleGrayScale.grayLevel) {
				target.removeEventListener(Event.ENTER_FRAME,toColor_eh);
				delete target.SimpleGrayScale.grayLevel;
				delete target.SimpleGrayScale.transSpeed;
				delete target.SimpleGrayScale.colorMatrix;
				delete target.SimpleGrayScale.counter;
				delete target.SimpleGrayScale;
				target.dispatchEvent(new Event("effectComplete"));
			} else {
				matrix=matrix.concat([target.SimpleGrayScale.colorMatrix+target.SimpleGrayScale.transSpeed,target.SimpleGrayScale.colorMatrix2-(target.SimpleGrayScale.transSpeed)/2,target.SimpleGrayScale.colorMatrix2-(target.SimpleGrayScale.transSpeed)/2,0,0]);// red
				matrix=matrix.concat([target.SimpleGrayScale.colorMatrix2-(target.SimpleGrayScale.transSpeed)/2,target.SimpleGrayScale.colorMatrix+target.SimpleGrayScale.transSpeed,target.SimpleGrayScale.colorMatrix2-(target.SimpleGrayScale.transSpeed)/2,0,0]);// green
				matrix=matrix.concat([target.SimpleGrayScale.colorMatrix2-(target.SimpleGrayScale.transSpeed)/2,target.SimpleGrayScale.colorMatrix2-(target.SimpleGrayScale.transSpeed)/2,target.SimpleGrayScale.colorMatrix+target.SimpleGrayScale.transSpeed,0,0]);// blue
				matrix=matrix.concat([0,0,0,1,0]);// alpha
				target.SimpleGrayScale.colorMatrix=target.SimpleGrayScale.colorMatrix+target.SimpleGrayScale.transSpeed;
				target.SimpleGrayScale.colorMatrix2=target.SimpleGrayScale.colorMatrix2-(target.SimpleGrayScale.transSpeed/2);
				var filter:ColorMatrixFilter=new ColorMatrixFilter(matrix);
				var mfilters:Array=new Array  ;
				mfilters.push(filter);
				target.filters=mfilters;
			}
		}
	}
}