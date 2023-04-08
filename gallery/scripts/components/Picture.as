package scripts.components{
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.GradientType;
	import flash.display.BlendMode;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.filters.ColorMatrixFilter;
	import scripts.effects.SimpleGrayScale;
	import scripts.misc.*;
	import scripts.effects.SimpleFade;
	public class Picture extends MovieClip {
		public var holder:MovieClip;
		public var mOver:Boolean;
		private var picHolder:MovieClip;
		private var bg:Shape;
		private var gray:Boolean=false;
		private var reflect:Boolean=false;
		private var loader:Loader;
		private var initComplete:Boolean=false;
		private var loading:Loading;
		
		public function Picture() {
			holder = new MovieClip();
			addChild(holder);
			var bgWidth:Number=Share.thumbWidth+Share.thumbBgSize;
			var bgHeight:Number=Share.thumbHeight+Share.thumbBgSize;
			if (Share.thumbBg==true) {
				bg = new Shape();
				bg.graphics.beginFill(Share.thumbBgColor,Share.thumbBgAlpha);
				bg.graphics.moveTo(-(bgWidth/2),-(bgHeight/2));
				bg.graphics.lineTo(bgWidth/2, -(bgHeight/2));
				bg.graphics.lineTo(bgWidth/2, bgHeight/2);
				bg.graphics.lineTo(-(bgWidth/2),bgHeight/2);
				bg.graphics.lineTo(-(bgWidth/2),-(bgHeight/2));
				bg.graphics.endFill();
				holder.addChild(bg);
			} else {
				bg = new Shape();
				bg.graphics.beginFill(0x222222,Share.thumbBgAlpha);
				bg.graphics.moveTo(-(Share.thumbWidth/2),-(Share.thumbHeight/2));
				bg.graphics.lineTo(Share.thumbWidth/2, -(Share.thumbHeight/2));
				bg.graphics.lineTo(Share.thumbWidth/2, Share.thumbHeight/2);
				bg.graphics.lineTo(-(Share.thumbWidth/2),Share.thumbHeight/2);
				bg.graphics.lineTo(-(Share.thumbWidth/2),-(Share.thumbHeight/2));
				bg.graphics.endFill();
				holder.addChild(bg);
			}
			picHolder = new MovieClip();
		}
		public function setImage(image_f:Array, reflect_f:String) {
			var bgWidth:Number=Share.thumbWidth;
			var bgHeight:Number=Share.thumbHeight;

			loading = new Loading();
			loading.width=Share.thumbWidth/2;
			loading.height=Share.thumbHeight/2;
			loading.x=-(loading.width/2);
			loading.y=-(loading.height/2);
			holder.addChild(loading);
			reflect_f=="reflection"?reflect=true:reflect=false
			;
			if (reflect) {
				holder.scaleY=-1;
			}
			if (reflect) {
				var matr:Matrix = new Matrix();
				var imageGradient1:Shape = new Shape();
				matr.createGradientBox(Share.thumbWidth, Share.thumbHeight, -Math.PI/2, 0,-Share.thumbHeight/2);
				if (Share.thumbBg) {
					imageGradient1.graphics.beginGradientFill("linear", [0x000000, 0x000000], [.6, 1], [0x00, 0xFF],matr,"pad");
					imageGradient1.graphics.drawRect(-((bgWidth/2)+Share.thumbBgSize/2),-((bgHeight/2)+Share.thumbBgSize/2),bgWidth+Share.thumbBgSize, bgHeight+Share.thumbBgSize);
					imageGradient1.graphics.endFill();
				} else {
					imageGradient1.graphics.beginGradientFill("linear", [0x000000, 0x000000], [.6, 1], [0x00, 0xFF],matr,"pad");
					imageGradient1.graphics.drawRect(-((bgWidth/2)),-((bgHeight/2)),bgWidth, bgHeight);
					imageGradient1.graphics.endFill();
				}
				this.blendMode=BlendMode.LAYER;

				if (Share.thumbCover!=false) {
					bg = new Shape();
					bg.graphics.beginFill(Share.thumbCoverColor,Share.thumbCoverAlpha);
					bg.graphics.moveTo(-(bgWidth/2),-(bgHeight/2));
					bg.graphics.lineTo(bgWidth/2, -(bgHeight/2));
					bg.graphics.lineTo(bgWidth/2, bgHeight/2);
					bg.graphics.lineTo(-(bgWidth/2),bgHeight/2);
					bg.graphics.lineTo(-(bgWidth/2),-(bgHeight/2));
					bg.graphics.endFill();
					var cover:MovieClip = new MovieClip();
					cover.addChild(bg);
					cover.name="thumbCover";
					holder.addChild(cover);
				}

				imageGradient1.blendMode=BlendMode.ERASE;
				holder.addChild(imageGradient1);
			} else {
				if (Share.thumbCover!=false) {
					bg = new Shape();
					bg.graphics.beginFill(Share.thumbCoverColor,Share.thumbCoverAlpha);
					bg.graphics.moveTo(-(bgWidth/2),-(bgHeight/2));
					bg.graphics.lineTo(bgWidth/2, -(bgHeight/2));
					bg.graphics.lineTo(bgWidth/2, bgHeight/2);
					bg.graphics.lineTo(-(bgWidth/2),bgHeight/2);
					bg.graphics.lineTo(-(bgWidth/2),-(bgHeight/2));
					bg.graphics.endFill();
					var cover2:MovieClip = new MovieClip();
					cover2.addChild(bg);
					cover2.name="thumbCover";
					holder.addChild(cover2);
				}

			}
			loader = new Loader();
			var url:URLRequest;
			if (Share.thumbSource=="full") {
				url=new URLRequest(image_f[0]);
			} else {
				url=new URLRequest(image_f[3]);
			}
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, init);
			loader.load(url);
			picHolder.addChild(loader);
			picHolder.alpha=0;
			picHolder.visible = false
			;
		}
		private function init(event_f:Event) {
			event_f.target.removeEventListener(Event.COMPLETE, init);
			holder.removeChild(loading);
			loading.kill();
			var bgWidth:Number=Share.thumbWidth;
			var bgHeight:Number=Share.thumbHeight;

			if (Share.thumbGray!=false) {
				var matrix:Array = new Array();
				matrix=matrix.concat([.33,.33,.33,0,0]);// red
				matrix=matrix.concat([.33,.33,.33,0,0]);// green
				matrix=matrix.concat([.33,.33,.33,0,0]);// blue
				matrix=matrix.concat([0,0,0,1,0]);
				var filter:ColorMatrixFilter=new ColorMatrixFilter(matrix);
				var mfilters:Array=new Array  ;
				mfilters.push(filter);
				picHolder.filters=mfilters;
				gray=true;
			}
			if (Share.thumbStretch=="stretch") {
				picHolder.width=Share.thumbWidth;
				picHolder.height=Share.thumbHeight;
			}
			if (Share.thumbStretch=="full") {
				if (picHolder.height>picHolder.width) {
					if (Share.thumbHeight<=Share.thumbWidth) {
						picHolder.width = picHolder.width*(Share.thumbHeight/picHolder.height);
						picHolder.height=Share.thumbHeight;
					} else {
						picHolder.height = picHolder.height*(Share.thumbWidth/picHolder.width);
						picHolder.width=Share.thumbWidth;
					}
				} else {
					if (Share.thumbHeight>=Share.thumbWidth) {
						picHolder.height = picHolder.height*(Share.thumbWidth/picHolder.width);
						picHolder.width=Share.thumbWidth;
					} else {
						picHolder.width = picHolder.width*(Share.thumbHeight/picHolder.height);
						picHolder.height=Share.thumbHeight;
					}
				}
			}
			if (Share.thumbStretch=="crop") {
				bg = new Shape();
				bg.graphics.beginFill(Share.thumbCoverColor,0);
				bg.graphics.moveTo(-(bgWidth/2),-(bgHeight/2));
				bg.graphics.lineTo(bgWidth/2, -(bgHeight/2));
				bg.graphics.lineTo(bgWidth/2, bgHeight/2);
				bg.graphics.lineTo(-(bgWidth/2),bgHeight/2);
				bg.graphics.lineTo(-(bgWidth/2),-(bgHeight/2));
				bg.graphics.endFill();
				holder.addChild(bg);
				picHolder.mask=bg;

				if (picHolder.height>picHolder.width) {
					if (Share.thumbHeight<=Share.thumbWidth) {
						picHolder.height = picHolder.height*(Share.thumbWidth/picHolder.width);
						picHolder.width=Share.thumbWidth;
					} else {
						picHolder.width = picHolder.width*(Share.thumbHeight/picHolder.height);
						picHolder.height=Share.thumbHeight;
					}
				} else {
					if (Share.thumbHeight>=Share.thumbWidth) {
						picHolder.width = picHolder.width*(Share.thumbHeight/picHolder.height);
						picHolder.height=Share.thumbHeight;
					} else {
						picHolder.height = picHolder.height*(Share.thumbWidth/picHolder.width);
						picHolder.width=Share.thumbWidth;
					}
				}
			}

			picHolder.x = -(picHolder.width/2);
			picHolder.y = -(picHolder.height/2);

			holder.addChildAt(picHolder,1);
			SimpleFade.fadeIn(picHolder,10);
			initComplete=true;
		}
		public function fadeGray(speed_f:Number) {
			if (initComplete) {
				if (gray) {
					if(mOver){
						SimpleGrayScale.toColor(picHolder, speed_f);
						gray=false;
					}
				} else {
					if(!mOver){
						SimpleGrayScale.toGray(picHolder, speed_f);
						gray=true;
					}
				}
			}
		}
		public function kill() {
			var holdNum=holder.numChildren;
			var picNum=picHolder.numChildren;
			var thisNum=numChildren;
			for (var i:Number = 0; i<holdNum; i++) {
				try {
					var mc=holder.getChildAt(0);
					holder.removeChildAt(0);
					mc.kill();
				} catch (e) {
				}
			}
			for (var j:Number = 0; j<picNum; j++) {
				try {
					var mc1=picHolder.getChildAt(0);
					picHolder.removeChildAt(0);
					mc1.kill();
				} catch (e) {
				}
			}
			for (var k:Number = 0; k<thisNum; k++) {
				try {
					var mc2=getChildAt(0);
					removeChildAt(0);
					mc2.kill();
				} catch (e) {
				}
			}
			delete this;
		}
	}
}