package scripts.misc{

	import flash.display.MovieClip;
	import flash.text.*;
	import flash.events.*;
	import flash.filters.GlowFilter;
	import flash.filters.DropShadowFilter;


	public class DynamicHTMLText extends MovieClip {
		private var tfCounter:Number;
		//
		private var htmlString:String;
		//
		private var tfX:Number=0;
		private var tfY:Number=0;
		private var tfW:Number=100;
		private var tfH:Number=100;
		//
		private var fadeOutSpeed:Number;
		private var fadeInSpeed:Number;
		private var fadeInDelay:Number;
		private var glowColor:uint= 0x000000;
		private var glowStrength:Number=.7;
		private var glowSize:Number=1.5;
		private var glowAlpha:Number=.8;
		private var filter:String="softglow";
		private var nl:Number=0;
		private var vCenter:Boolean=true;
		public function DynamicHTMLText() {
			tfCounter= 0;
			fadeOutSpeed=.12;
			fadeInSpeed=.10;
			fadeInDelay=30;
			createHTMLText("");
		}
		public function init() {
		}
		///////////////////////
		//
		//  KILL FUNCTION 
		//
		////////////////////////
		public function kill() {
			var tfc = getChildByName("tf"+tfCounter) as MovieClip;
			tfc.removeEventListener(Event.ENTER_FRAME, fadeIn);
			tfc.removeEventListener(Event.ENTER_FRAME, fadeOut);
			removeChild(tfc);
			delete this;
		}
		/////////////////////////
		//
		// END KILL FUNCTION 
		//
		/////////////////////////
		////////
		//
		//
		//PUBLIC FUNCTIONS
		//
		//
		///////
		public function setGlow(color_f:uint,strength_f:Number, size_f:Number, alpha_f:Number) {
			glowColor=color_f;
			glowStrength=strength_f;
			glowSize=size_f;
			glowAlpha=alpha_f;
		}
		public function setFadeInSpeed(fadeInSpeed_f:Number) {
			fadeInSpeed = fadeInSpeed_f;
		}
		public function vCenterOn() {
			vCenter=true;
		}
		public function vCenterOff() {
			vCenter=false;
		}
		public function setFilter(filter_f:String) {
			filter=filter_f;
		}
		public function setHTMLText(htmlString_f:String) {
			if (htmlString_f!=htmlString) {
				var tfc = getChildByName("tf"+tfCounter) as MovieClip;
				tfc.addEventListener(Event.ENTER_FRAME,fadeOut);
				createHTMLText(htmlString_f);
			}
		}
		public function getNumLines():Number {
			return nl;
		}
		public function setFadeInDelay(fadeInDelay_f:Number) {
			fadeInDelay=fadeInDelay_f;
		}
		/////////////////////////
		//
		// Set XY Placement
		//
		////////////////////////
		public function setXY(x_f:Number,y_f:Number) {
			tfX=x_f;
			tfY=y_f;
		}
		////////////////////////
		//
		//  END Set XY Placement
		//
		////////////////////////
		public function setBounds(h_f:Number, w_f:Number) {
			tfH = h_f;
			tfW = w_f;
		}
		///////////////////////
		//
		// ENTER FRAME FUNCTIONS
		//
		////////////////////////
		private function fadeOut(event_f:Event) {
			event_f.currentTarget.alpha-=fadeOutSpeed;
			if (event_f.currentTarget.alpha<=0) {
				event_f.currentTarget.removeEventListener(Event.ENTER_FRAME, fadeOut);
				event_f.currentTarget.alpha=1;
				delete this;
				var fomc:MovieClip = getChildByName(event_f.currentTarget.name) as MovieClip;
				removeChild(fomc);
			}
		}
		private function fadeIn(event_f:Event) {
			if ((event_f.currentTarget.fdelay-=1)<=0) {
				event_f.currentTarget.alpha+=fadeInSpeed;
				if (event_f.currentTarget.alpha>=1) {
					event_f.currentTarget.removeEventListener(Event.ENTER_FRAME, fadeIn);
				}
			}
		}
		///////////////////////
		//
		// END ENTER FRAME FUNCTIONS
		//
		/////////////////////////
		private function textFilter1():Array {
			var returnVar:Array = new Array;
			var glow:GlowFilter = new GlowFilter();
			glow.quality = 2;
			glow.color = glowColor;
			glow.inner = false;
			glow.alpha = glowAlpha;
			glow.blurX = glowSize;
			glow.blurY = glowSize;
			glow.strength = glowStrength;
			glow.knockout = false;
			returnVar.push(glow);
			return returnVar;
		}
		private function textFilter2():Array {
			var returnVar:Array = new Array;
			var dsf:DropShadowFilter = new DropShadowFilter();
			dsf.quality = 2;
			dsf.color = 0x000000;
			dsf.inner = false;
			dsf.alpha = .3;
			dsf.blurX = 5;
			dsf.blurY = 5;
			dsf.strength = 1;
			dsf.knockout = false;
			dsf.angle = 125;
			returnVar.push(dsf);
			return returnVar;
		}
		///////
		//
		//TEXT FIELD FUNCTIONS
		//
		///////
		public function createHTMLText(htmlString_f:String) {
			var htmlString:String;
			htmlString=htmlString_f;
			var tf_htmlString:TextField= new TextField( );
			tf_htmlString.x=tfX;
			tf_htmlString.y=tfY;
			tf_htmlString.width=tfW;
			tf_htmlString.background = false;
			tf_htmlString.border = false;
			tf_htmlString.selectable=false;
			tf_htmlString.wordWrap=true;
			tf_htmlString.multiline=true;
			tf_htmlString.autoSize = TextFieldAutoSize.LEFT;
			tf_htmlString.embedFonts=true;
			//var defaultText:String = "<p align='center'><FONT FACE='TradeGothic Light' size='38' color='#ffffff'>" + "ActionScript is fun!<br><b>ActionScript is fun!</b></FONT></p>";
			htmlString = htmlString_f;
			tf_htmlString.htmlText= htmlString;
			if (vCenter) {
				tf_htmlString.y=(tfY+(tfH/2))-(tf_htmlString.height/2);
			}
			switch (filter) {
				case "softglow" :
					tf_htmlString.filters = textFilter1();
					break;
				case "none" :
					tf_htmlString.filters = [];
					break;
				case "shadow145" :
					tf_htmlString.filters = textFilter2();
					break;
				default :
					tf_htmlString.filters = textFilter1();
					break;

			}
			//
			//
			var tfc:MovieClip = new MovieClip();
			tfCounter++;
			tfc.fdelay=fadeInDelay;
			tfc.name = "tf"+ tfCounter;
			/*
			tfc.graphics.beginFill(0xFF0000,.5);
			tfc.graphics.drawRect(0,0,tfW,tfH);
			tfc.graphics.endFill();
			*/
			tfc.addChild(tf_htmlString);
			addChild(tfc);
			nl=tf_htmlString.numLines;
			tfc.alpha=0;
			tfc.addEventListener(Event.ENTER_FRAME,fadeIn);
		}

	}
}