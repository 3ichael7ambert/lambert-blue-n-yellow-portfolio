package scripts.template{
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.display.StageScaleMode;
	import flash.display.Shape;
	import flash.display.BlendMode;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.events.IOErrorEvent;
	import scripts.utilities.XMLLoader;
	import scripts.components.*;

	public class Gallery extends MovieClip {
		private var loader:Loader;
		private var PC:PageController;
		private var BG:MovieClip;
		private var CL:XMLLoader;
		private var imageCount:Number=0;
		private var imageCounter:Number=0;
		private var xmlEdit:XMLEditor;

		public function Gallery() {
			//stage.scaleMode=StageScaleMode.NO_SCALE;
			loadXML();
		}
		private function loadXML() {
			CL = new XMLLoader();
			CL.setFileName("content.xml");
			CL.init();
			CL.addEventListener(XMLLoader.XML_LOADED, contentLoaded);
		}
		private function contentLoaded(event_f:Event) {
			event_f.target.removeEventListener(XMLLoader.XML_LOADED, contentLoaded);
			Share.contentXML=CL.getDataXML();
			Share.startX=Share.contentXML.config.startX;
			Share.startY=Share.contentXML.config.startY;
			
			Share.bgVisible=String(Share.contentXML.config.bgVisible)=="true"?true:false
			Share.bgColor=uint(String(Share.contentXML.config.bgColor));

			Share.gridXMax=Share.contentXML.config.gridXMax;
			Share.gridYMax=Share.contentXML.config.gridYMax;
			Share.gridSpacing=Number(Share.contentXML.config.gridSpacing);
			Share.gridAlign=Share.contentXML.config.gridAlign;

			Share.insideSWF=String(Share.contentXML.config.insideSWF)=="true"?true:false;

			Share.thumbBg=String(Share.contentXML.config.thumbBg)=="true"?true:false;
			Share.thumbBgColor=uint(String(Share.contentXML.config.thumbBgColor));
			Share.thumbBgSize=Number(Share.contentXML.config.thumbBgSize);
			Share.thumbBgAlpha = Number(Share.contentXML.config.thumbBgAlpha)
			;
			Share.thumbHeight=Share.contentXML.config.thumbHeight;
			Share.thumbWidth=Share.contentXML.config.thumbWidth;
			Share.thumbSource=Share.contentXML.config.thumbSource;

			Share.thumbStretch=Share.contentXML.config.thumbStretch;
			Share.thumbScale=String(Share.contentXML.config.thumbScale)=="true"?true:false;
			Share.thumbScaleSize=Number(Share.contentXML.config.thumbScaleSize);
			Share.thumbScaleEffect=String(Share.contentXML.config.thumbScaleEffect);
			Share.thumbScaleEffectSpeed=Number(Share.contentXML.config.thumbScaleEffectSpeed);
			
			Share.thumbClickable=String(Share.contentXML.config.thumbClickable)=="true"?true:false;
			Share.thumbClickAction = Share.contentXML.config.thumbClickAction
			;
			Share.thumbCover=String(Share.contentXML.config.thumbCover)=="true"?true:false;
			Share.thumbCoverColor=uint(String(Share.contentXML.config.thumbCoverColor));
			Share.thumbCoverAlpha=Number(Share.contentXML.config.thumbCoverAlpha);
			Share.thumbCoverFadeSpeed=Number(Share.contentXML.config.thumbCoverFadeSpeed)
			;
			Share.thumbReflection=String(Share.contentXML.config.thumbReflection)=="true"?true:false;

			Share.thumbGray=String(Share.contentXML.config.thumbGray)=="true"?true:false;
			Share.thumbGraySpeed=Number(Share.contentXML.config.thumbGraySpeed);

			Share.imageBgColor=uint(String(Share.contentXML.config.imageBgColor));
			Share.imageBgSize=Number(Share.contentXML.config.imageBgSize);
			Share.imageBgAlpha = Number(Share.contentXML.config.imageBgAlpha)
			;
			Share.imageFadeSpeed=Number(Share.contentXML.config.imageFadeSpeed);
			Share.imageMaxHeight=Share.contentXML.config.imageMaxHeight;
			Share.imageMaxWidth=Share.contentXML.config.imageMaxWidth;

			Share.paginate=String(Share.contentXML.config.paginate)=="true"?true:false;
			Share.paginateScrollType=Share.contentXML.config.paginateScrollType;
			Share.paginateScrollFade=Share.contentXML.config.paginateScrollFade;

			Share.mouseScrollFactor=Number(Share.contentXML.config.mouseScrollFactor);
			Share.mouseScrollMaxSpeed=Number(Share.contentXML.config.mouseScrollMaxSpeed)
			;
			Share.imageTitle=String(Share.contentXML.config.imageTitle)=="true"?true:false;
			Share.imageTitleHeight=Number(Share.contentXML.config.imageTitleHeight);
			Share.imageTitleFont=Share.contentXML.config.imageTitleFont;
			Share.imageTitleSize=Share.contentXML.config.imageTitleSize;
			Share.imageTitleAlign=Share.contentXML.config.imageTitleAlign;
			Share.imageTitleColor =uint(String(Share.contentXML.config.imageTitleColor))
			;
			Share.bgFade=String(Share.contentXML.config.bgFade)=="true"?true:false;
			Share.bgFadeColor=uint(String(Share.contentXML.config.bgFadeColor));
			Share.bgFadeAlpha = Number(Share.contentXML.config.bgFadeAlpha)
			;
			loadImages();
		}
		public function reloadGallery(){
			removeChild(PC)
			try{
				var back= getChildAt(getChildIndex(BG))
				back.removeChildAt(0)
				removeChild(BG)
			}catch(e){
			}
			PC.kill()
			init()
		}
		private function loadImages() {
			for each (var node:XML in Share.contentXML.config.images.*) {
				var test:XML = XML(('<![CDATA['+node.imgTitle.*+']]>').toString())
				Share.imageArray.push([node.imageURL,node.imgTitle,node.clickLinkURL, node.thumbURL]);
			}
			init()
		}
		private function loadComplete_eh(event_f:Event) {
		}
		private function IOError_eh(event_f:Event) {
			event_f.target.removeEventListener(IOErrorEvent.IO_ERROR, IOError_eh);
			trace("Error loading image url");
		}
		private function init() {
			var stageBg:Shape = new Shape();
			BG = new MovieClip()
			if (Share.bgVisible) {
				if (Share.insideSWF!="true") {
					stageBg.graphics.beginFill(Share.bgColor,1);
					stageBg.graphics.drawRect(0,0,stage.stageWidth, stage.stageHeight);
					stageBg.graphics.endFill();
					BG.addChildAt(stageBg,0);
				} else {
					var point:Point=new Point(0,0);
					var refPoint:Point=localToGlobal(point);
					var trueX0:Number=0-refPoint.x;
					var trueY0:Number=0-refPoint.y;
					stageBg.graphics.beginFill(Share.bgColor,1);
					stageBg.graphics.drawRect(trueX0,trueY0,stage.stageWidth, stage.stageHeight);
					stageBg.graphics.endFill();
					BG.addChildAt(stageBg,0);
				}
			}
			PC = new PageController();
			PC.setStageSize(stage.stageWidth, stage.stageHeight)
			PC.init();
			addChild(BG)
			addChild(PC);
			if(xmlEdit==null){
				if (Share.contentXML.config.XMLEditor=="true") {
					xmlEdit = new XMLEditor();
					xmlEdit.setParent(this)
					addChild(xmlEdit);
				}
			}else{
				var num= numChildren
				setChildIndex(xmlEdit, numChildren-1)
			}
		}
	}
}