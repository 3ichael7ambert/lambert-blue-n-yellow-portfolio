package scripts.components{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.geom.Rectangle
	import flash.display.Sprite
	import flash.display.Loader;
	import flash.display.GradientType;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.geom.Point;
	import flash.display.BlendMode;
	import flash.geom.Matrix;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	import scripts.components.Share;
	import scripts.components.Picture;
	import scripts.effects.*;
	import scripts.misc.DynamicHTMLText;


	public class PageController extends MovieClip {
		private var pic:Picture;
		private var imageHolder:MovieClip;
		private var bgHolder:MovieClip;
		private var maskHolder:MovieClip;
		private var currentImage:Number;
		private var pageBg:Shape;
		private var pagePos:Number=0;
		private var pageMaxPos:Number=0;
		private var buttonLeft:ScrollButton;
		private var buttonRight:ScrollButton;
		private var trueX0:Number
		private var trueY0:Number
		private var pageOver:Boolean=false;
		private var sWidth:Number
		private var sHeight:Number
		private var image:MovieClip
		public var inMotion:Boolean=false;
		//
		public function PageController() {
			pageMaxPos = Math.ceil(Share.imageArray.length/(Share.gridXMax*Share.gridYMax)-1);
			
			var point=new Point(0,0);
			trueX0 = 0-(localToGlobal(point).x);
			trueY0= 0-(localToGlobal(point).y);
			
			
			imageHolder = new MovieClip();
			imageHolder.addEventListener(QuarticSlide.EFFECT_COMPLETE, slideComplete_eh);
			
			maskHolder = new MovieClip();
			
			addChild(imageHolder);
			addChild(maskHolder);
			
			bgHolder = new MovieClip();
			
			addChild(bgHolder);
			
			if (Share.paginate) {
				if (pageMaxPos>=1) {
					if (Share.paginateScrollType!="mouse") {
						if (Share.gridAlign!="vertical") {
							buttonLeft = new ScrollButton();
							buttonRight = new ScrollButton();
							buttonRight.rotation = 180;
							
							buttonLeft.x=Share.startX-(buttonLeft.width+Share.gridSpacing);
							buttonLeft.y=Share.startY+(((Share.thumbHeight+Share.gridSpacing)*Share.gridYMax)/2);
					
							buttonRight.x=Share.startX+((Share.thumbWidth+Share.gridSpacing)*Share.gridXMax)+(buttonRight.width);
							buttonRight.y=Share.startY+(((Share.thumbHeight+Share.gridSpacing)*Share.gridYMax)/2);
						} else {
							buttonLeft = new ScrollButton();
							buttonLeft.rotation=90;
							buttonRight = new ScrollButton();
							buttonRight.rotation = 270
							
							buttonLeft.x=Share.startX+(((Share.thumbWidth+Share.gridSpacing)*Share.gridXMax)/2);
							buttonLeft.y=Share.startY-(buttonLeft.height+Share.gridSpacing);
							
							buttonRight.x=Share.startX+(((Share.thumbWidth+Share.gridSpacing)*Share.gridXMax)/2);
							buttonRight.y=Share.startY+((Share.thumbHeight+Share.gridSpacing)*Share.gridYMax)+(buttonRight.height);
						}
						buttonLeft.alpha = 0
						;
						maskHolder.addChild(buttonLeft);
						maskHolder.addChild(buttonRight);
					}
				}
			}
		}
		public function setStageSize(sWidth_f:Number, sHeight_f:Number){
			sWidth = sWidth_f
			sHeight = sHeight_f
		}
		public function init() {
			buildPage();
			if (buttonLeft!=null) {
				buttonLeft.addEventListener(MouseEvent.CLICK,buttonLeft_eh);
				buttonRight.addEventListener(MouseEvent.CLICK,buttonRight_eh);
			}
		}
		private function buttonLeft_eh(event_f:MouseEvent) {
			slideRight();
		}
		private function buttonRight_eh(event_f:MouseEvent) {
			slideLeft();
		}
		private function slideComplete_eh(event_f:Event) {
			inMotion=false;
		}
		private function buildPage() {
			var yRows:Number=Math.ceil(Share.imageArray.length/Share.gridXMax);
			var imageCounter:Number=0;
			if (Share.gridAlign!="vertical") {
				for (var i:Number =0; i<(Share.imageArray.length/Share.gridYMax); i++) {
					for (var j:Number = 0; j<Share.gridYMax; j++) {
						if (Share.imageArray[imageCounter]!=null) {
							pic = new Picture();
							pic.name=String("pic"+i+"-"+j);
							pic.num=imageCounter;
							pic.setImage(Share.imageArray[imageCounter],"standard");
							pic.x = Share.startX+i*(Share.thumbWidth+Share.gridSpacing)+Share.thumbWidth/2;
							pic.y = Share.startY+j*(Share.thumbHeight+Share.gridSpacing)+Share.thumbHeight/2;
							
							if (Share.thumbClickable!=false) {
								pic.addEventListener(MouseEvent.CLICK, click_eh);
							}
							pic.addEventListener(MouseEvent.ROLL_OVER, rollOver_eh);
							
							imageHolder.addChild(pic);
							if (Share.paginate&&i>=Share.gridXMax) {
								if (Share.paginateScrollType!="mouse") {
									pic.visible=false;
									pic.alpha=0;
								}
							}else if(i>=Share.gridXMax){
								pic.visible=false;
								pic.alpha=0;
							}
							if(Share.thumbReflection==true){
								if(Share.paginate){
									if(Share.paginateScrollType!="mouse"){
										if (j==Share.gridYMax-1 && i<Share.gridXMax) {
											pic = new Picture();
											pic.name=String("pic"+i+"-"+j+"ref");
											pic.num=imageCounter;
											pic.setImage(Share.imageArray[imageCounter],"reflection");
											pic.x = Share.startX+i*(Share.thumbWidth+Share.gridSpacing)+Share.thumbWidth/2;
											pic.y = Share.thumbHeight+Share.thumbBgSize+Share.startY+j*(Share.thumbHeight+Share.gridSpacing)+Share.thumbHeight/2;
											
											imageHolder.addChild(pic);
											
										}else if(j==Share.gridYMax-1){
											pic = new Picture();
											pic.name=String("pic"+i+"-"+j+"ref");
											pic.num=imageCounter;
											pic.setImage(Share.imageArray[imageCounter],"reflection");
											pic.x = Share.startX+i*(Share.thumbWidth+Share.gridSpacing)+Share.thumbWidth/2;
											pic.y = Share.thumbHeight+Share.thumbBgSize+Share.startY+j*(Share.thumbHeight+Share.gridSpacing)+Share.thumbHeight/2;
											imageHolder.addChild(pic);
											pic.visible =false
											pic.alpha =0
										}
									}else{
										if (j==Share.gridYMax-1) {
											pic = new Picture();
											pic.name=String("pic"+i+"-"+j+"ref");
											pic.num=imageCounter;
											pic.setImage(Share.imageArray[imageCounter],"reflection");
											pic.x = Share.startX+i*(Share.thumbWidth+Share.gridSpacing)+Share.thumbWidth/2;
											pic.y = Share.thumbHeight+Share.thumbBgSize+Share.startY+j*(Share.thumbHeight+Share.gridSpacing)+Share.thumbHeight/2;
											
											imageHolder.addChild(pic);
										}
									}
								}else{
									if (i<Share.gridXMax && j==Share.gridYMax-1) {
										pic = new Picture();
										pic.name=String("pic"+i+"-"+j+"ref");
										pic.num=imageCounter;
										pic.setImage(Share.imageArray[imageCounter],"reflection");
										pic.x = Share.startX+i*(Share.thumbWidth+Share.gridSpacing)+Share.thumbWidth/2;
										pic.y = Share.thumbHeight+Share.thumbBgSize+Share.startY+j*(Share.thumbHeight+Share.gridSpacing)+Share.thumbHeight/2;
										imageHolder.addChild(pic);
									}
								}
							}
							imageCounter++;
						}
					}
				}
			} else {
				for (var k:Number=0; k<Share.imageArray.length/Share.gridXMax; k++) {
					for (var l:Number=0; l<Share.gridXMax; l++) {
						if (Share.imageArray[imageCounter]!=null) {
							pic = new Picture();
							pic.name=String("pic"+k+"-"+l);
							pic.num=imageCounter;
							pic.setImage(Share.imageArray[imageCounter],"standard");
							pic.y = Share.startY+k*(Share.thumbWidth+Share.gridSpacing)+Share.thumbWidth/2;
							pic.x = Share.startX+l*(Share.thumbHeight+Share.gridSpacing)+Share.thumbHeight/2;
							pic.addEventListener(MouseEvent.ROLL_OVER, rollOver_eh);
							if (Share.thumbClickable!=false) {
								pic.addEventListener(MouseEvent.CLICK, click_eh);
							}
							imageHolder.addChild(pic);
							imageCounter++;
							if (Share.paginate&&k>=Share.gridYMax) {
								if (Share.paginateScrollType!="mouse") {
									pic.visible=false;
									pic.alpha=0;
								}
							}else if(k>=Share.gridYMax){
								pic.visible=false;
								pic.alpha=0;
							}
						}
					}
				}
			}
			if (Share.paginate!=false) {
				if (Share.paginateScrollType=="mouse") {
					if(Share.imageArray.length>Share.gridXMax*Share.gridYMax){
						addEventListener(Event.ENTER_FRAME, mouseScroller_eh);
						var maskX:Number;
						var maskY:Number;
						var maskX2:Number;
						var maskY2:Number;
						if (Share.gridAlign!="vertical") {
							if(Share.thumbReflection!=true){
								maskX=Number((Share.startX-Share.thumbBgSize*2)-Share.thumbWidth/2);
								maskY=Number(Share.startY-Share.thumbBgSize*2-((Share.thumbHeight*Share.thumbScaleSize)/2)+Share.thumbHeight/2);
								maskX2 =Number(Share.thumbBgSize*2+(Share.gridXMax-1)*(Share.thumbWidth+Share.gridSpacing)+(Share.thumbWidth*Share.thumbScaleSize)/2+Share.thumbWidth);
								maskY2 =Number(Share.thumbBgSize*2+Share.gridYMax*(Share.thumbHeight+Share.gridSpacing)+Share.thumbHeight*Share.thumbScaleSize/2);
							}else{
								maskX=Number((Share.startX-Share.thumbBgSize*2)-((Share.thumbWidth*Share.thumbScaleSize)/2)+(Share.thumbWidth/2));
								maskY=Number((Share.startY-Share.thumbBgSize*2)-(Share.thumbHeight*Share.thumbScaleSize)/2+(Share.thumbWidth/2));
								maskX2 =Number(Share.thumbBgSize*2+(Share.gridXMax-1)*(Share.thumbWidth+Share.gridSpacing)+((Share.thumbWidth*Share.thumbScaleSize)/2)+(Share.thumbWidth/2));
								maskY2 =Number(Share.thumbBgSize*2+(Share.gridYMax*(Share.thumbHeight+Share.gridSpacing))+((Share.thumbHeight*Share.thumbScaleSize)/2)+(Share.thumbHeight*Share.thumbScaleSize));
							}
						} else {
							maskX=Number(Share.startX-Share.thumbBgSize*2)-((Share.thumbWidth*Share.thumbScaleSize)/2)+Share.thumbWidth/2;
							maskY=Number((Share.startY-Share.thumbBgSize*2)-Share.thumbHeight/2);
							maskX2 =Number(Share.thumbBgSize*2+Share.gridXMax*(Share.thumbWidth+Share.gridSpacing)+Share.thumbWidth/2);
							maskY2 =Number((Share.thumbBgSize*2+(Share.gridYMax-1)*(Share.thumbHeight+Share.gridSpacing)+(Share.thumbHeight*Share.thumbScaleSize)/2)+Share.thumbHeight);
						}
					
						var imageGradient1:Shape = new Shape();
						var imageGradient2:Shape = new Shape();
					
						var matr:Matrix = new Matrix();
						var matr2:Matrix = new Matrix();
					
						var holder:MovieClip = new MovieClip()
						var holder2:MovieClip = new MovieClip()
						var holder3:MovieClip = new MovieClip()
					
						if (Share.gridAlign!="vertical") {
							matr.createGradientBox(20, 20, 0, maskX, maskX);
							matr2.createGradientBox(20, 20, 0,maskX+maskX2-20,maskX+maskX2-20);
						
							imageGradient1.graphics.beginGradientFill("linear", [Share.bgColor,Share.bgColor], [1, 0], [0x00, 0xFF],matr,"pad");
							imageGradient1.graphics.drawRect(maskX, maskY, 20, maskY2);
							imageGradient1.graphics.endFill();
	
							blendMode = BlendMode.LAYER
							imageGradient1.blendMode = BlendMode.ERASE
						
							holder.addChild(imageGradient1)
							maskHolder.addChild(holder)
						
							imageGradient2.graphics.beginGradientFill("linear", [Share.bgColor,Share.bgColor], [0, 1], [0x00, 0xFF],matr2,"pad");
							imageGradient2.graphics.drawRect(maskX+maskX2-20, maskY, 20, maskY2);
							imageGradient2.graphics.endFill();
						
							blendMode = BlendMode.LAYER
							imageGradient2.blendMode = BlendMode.ERASE
						
							holder2.addChild(imageGradient2)
							maskHolder.addChild(holder2)
							
						} else {
							matr.createGradientBox(20, 20, Math.PI/2, maskY, maskY);
							matr2.createGradientBox(20, 20, Math.PI/2,  maskY+maskY2-20,maskY+maskY2-20);

							imageGradient1.graphics.beginGradientFill("linear", [Share.bgColor,Share.bgColor], [1, 0], [0x00, 0xFF],matr,"pad");
							imageGradient1.graphics.drawRect(maskX, maskY, maskX2,20);
							imageGradient1.graphics.endFill();
						
							blendMode = BlendMode.LAYER
							imageGradient1.blendMode = BlendMode.ERASE
							holder.addChild(imageGradient1)
							maskHolder.addChild(holder)
						
							imageGradient2.graphics.beginGradientFill("linear", [Share.bgColor,Share.bgColor], [0, 1], [0x00, 0xFF],matr2,"pad");
							imageGradient2.graphics.drawRect(maskX, maskY+maskY2-20, maskX2, 20);
							imageGradient2.graphics.endFill();
						
							blendMode = BlendMode.LAYER
							imageGradient2.blendMode = BlendMode.ERASE
						
							holder2.addChild(imageGradient2)
							maskHolder.addChild(holder2)
						}
						var imageHolderMask:Shape = new Shape();
						imageHolderMask.graphics.beginFill(Share.bgColor,.5);
						imageHolderMask.graphics.drawRect(maskX, maskY, maskX2, maskY2);
						imageHolderMask.graphics.endFill();
					
						holder3.addChild(imageHolderMask)
					
						imageHolder.mask=holder3;
					}
				}
			}
		}
		private function slideRight() {
			if (pagePos>0&&! inMotion) {
				pagePos--;
				var pic:Picture;
				if (pagePos<pageMaxPos) {
					if (buttonRight.alpha<1) {
						SimpleFade.fadeIn(buttonRight,10);
					}
				}
				if (pagePos==0) {
					if (buttonLeft.alpha>0) {
						SimpleFade.fadeOut(buttonLeft,10);
					}
				}
				inMotion=true;
				if (Share.gridAlign!="vertical") {
					QuarticSlide.slideRight(imageHolder,20,Share.thumbWidth+Share.gridSpacing);
				} else {
					QuarticSlide.slideDown(imageHolder,20,Share.thumbWidth+Share.gridSpacing);
				}
				if (Share.gridAlign!="vertical") {
					for (var i:Number =0; i<Math.ceil(Share.imageArray.length/Share.gridYMax); i++) {
						for (var j:Number = 0; j<Share.gridYMax; j++) {
							pic=imageHolder.getChildByName("pic"+String(i)+"-"+String(j)) as Picture;
							if (pic!=null) {
								if ((i>=Share.gridXMax+pagePos) || i < pagePos) {
									if (pic.visible) {
										SimpleFade.fadeOut(pic,10);
									}
								} else {
									if (! pic.visible) {
										SimpleFade.fadeIn(pic,10);
									}
								}
								if(Share.thumbReflection){
									try{
									pic=imageHolder.getChildByName("pic"+String(i)+"-"+String(j)+"ref") as Picture;
										if (pic!=null) {
											if ((i>=Share.gridXMax+pagePos) || i < pagePos) {
												if (pic.visible) {
												SimpleFade.fadeOut(pic,10);
												}
											} else {
												if (! pic.visible) {
													SimpleFade.fadeIn(pic,10);
												}
											}
										}
									}catch(e){
									}
								}
							}
						}
					}
				} else {
					for (var k:Number =0; k<Math.ceil(Share.imageArray.length/Share.gridXMax); k++) {
						for (var l:Number = 0; l<Share.gridXMax; l++) {
							pic=imageHolder.getChildByName("pic"+String(k)+"-"+String(l)) as Picture;
							if (pic!=null) {
								if ((k>=Share.gridYMax+pagePos) ||k < pagePos) {
									if (pic.visible) {
										SimpleFade.fadeOut(pic,10);
									}
								} else {
									if (! pic.visible) {
										SimpleFade.fadeIn(pic,10);
									}
								}
							}
						}
					}
				}
			}
		}
		private function slideLeft() {
			if (pagePos<pageMaxPos&&! inMotion) {
				pagePos++;
				var pic:Picture;
				if (pagePos==pageMaxPos) {
					SimpleFade.fadeOut(buttonRight,10);
				}
				if (pagePos!=0) {
					if (buttonLeft.alpha<1) {
						SimpleFade.fadeIn(buttonLeft,10);
					}
				}
				inMotion=true;
				if (Share.gridAlign!="vertical") {
					QuarticSlide.slideLeft(imageHolder,20,Share.thumbWidth+Share.gridSpacing);
				} else {
					QuarticSlide.slideUp(imageHolder,20,Share.thumbWidth+Share.gridSpacing);
				}
				if (Share.gridAlign!="vertical") {
					for (var i:Number =0; i<Math.ceil(Share.imageArray.length/Share.gridYMax); i++) {
						for (var j:Number = 0; j<Share.gridYMax; j++) {
							pic=imageHolder.getChildByName("pic"+String(i)+"-"+String(j)) as Picture;
							if (pic!=null) {
								if ((i>=Share.gridXMax+pagePos) || i < pagePos) {
									if (pic.visible) {
										SimpleFade.fadeOut(pic,10);
									}
								} else {
									if (! pic.visible) {
										SimpleFade.fadeIn(pic,10);
									}
								}
								if(Share.thumbReflection){
									try{
										pic=imageHolder.getChildByName("pic"+String(i)+"-"+String(j)+"ref") as Picture;
										if ((i>=Share.gridXMax+pagePos) || i < pagePos) {
											if (pic.visible) {
												SimpleFade.fadeOut(pic,10);
											}
										} else {
											if (! pic.visible) {
												SimpleFade.fadeIn(pic,10);
											}
										}
									}catch(e){
									}
								}
							}
						}
					}
				} else {
					for (var k:Number =0; k<Math.ceil(Share.imageArray.length/Share.gridXMax); k++) {
						for (var l:Number = 0; l<Share.gridXMax; l++) {
							pic=imageHolder.getChildByName("pic"+String(k)+"-"+String(l)) as Picture;
							if (pic!=null) {
								if ((k>=Share.gridYMax+pagePos) || k < pagePos) {
									if (pic.visible) {
										SimpleFade.fadeOut(pic,10);
									}
								} else {
									if (! pic.visible) {
										SimpleFade.fadeIn(pic,10);
									}
								}
							}
						}
					}
				}
			}
		}
		private function mouseScroller_eh(event_f:Event) {
			if (! pageOver) {
				var pic:Picture;
				var refPic:Picture;
				var starting:Number = Share.startX+(Share.thumbWidth/2);
				var moveCalc:Number;
				var pos:Number;
				var moveFactor:Number;
				if (Share.gridAlign!="vertical") {
					var mousePos:Number =(mouseX-Share.startX)/((Share.thumbWidth+Share.gridSpacing)*(Share.gridXMax-1)/2)-1;
					moveCalc=Math.abs((mouseX-((((Share.thumbWidth+Share.gridSpacing)*(Share.gridXMax-1))/2)+Share.startX)))>((Share.gridXMax*Share.thumbWidth)/2.5)?Share.mouseScrollFactor*(mouseX-((((Share.thumbWidth+Share.gridSpacing)*(Share.gridXMax-1))/2)+Share.startX)):0
					pos=moveCalc<0?-1:1;
					moveFactor=Math.abs(Share.mouseScrollFactor*moveCalc)>Share.mouseScrollMaxSpeed?Share.mouseScrollMaxSpeed*pos:moveCalc*Share.mouseScrollFactor;
					if (imageHolder.x-moveFactor<=0 && imageHolder.x-moveFactor>=0-((Share.thumbWidth+Share.gridSpacing)*(Math.ceil(Share.imageArray.length/Share.gridYMax))-Share.thumbHeight*(Share.gridXMax-.5))) {
						imageHolder.x-=moveFactor;
					} else {
						if (imageHolder.x-moveFactor>=0) {
							imageHolder.x=0;
						} else {
							imageHolder.x=0-((Share.thumbWidth+Share.gridSpacing)*(Math.ceil(Share.imageArray.length/Share.gridYMax))-Share.thumbHeight*(Share.gridXMax-.5));
						}
					}
					for (var i:Number =0; i<(Share.imageArray.length/Share.gridYMax); i++) {
						for (var j:Number = 0; j<Share.gridYMax; j++) {
							var image:Picture = imageHolder.getChildByName("pic"+i+"-"+j) as Picture;
							var image2:Picture =imageHolder.getChildByName("pic"+i+"-"+j+"ref") as Picture;
							if (image!=null){
								if((imageHolder.x+image.x<Share.startX-Share.thumbWidth) ){
									if(image.alpha>0){
										SimpleFade.fadeOut(image,1);
									}
									if(image2!=null){
										if(image2.alpha>0){
											SimpleFade.fadeOut(image2,1);
										}
									}
								} else if(imageHolder.x+image.x>Share.startX+((Share.thumbWidth+Share.gridSpacing)*(Share.gridXMax))+Share.thumbWidth) {
									if(image.alpha>0){
										SimpleFade.fadeOut(image,1);	 
									}
									if(image2!=null){
										if(image2.alpha>0){
											SimpleFade.fadeOut(image2,1);
										}
									}						
								} else {
									if(image.alpha<1){
										SimpleFade.fadeIn(image,1);	 
									}
									if(image2!=null){
										if(image2.alpha<1){
											SimpleFade.fadeIn(image2,1)
										}
									}
								}
							}
						}
					}
				} else {
					var mousePosY:Number =(mouseY-Share.startY)/((Share.thumbWidth+Share.gridSpacing)*(Share.gridYMax-1)/2)-1;
					moveCalc=Math.abs((mouseY-((((Share.thumbWidth+Share.gridSpacing)*(Share.gridYMax-1))/2)+Share.startY)))>((Share.gridYMax*Share.thumbHeight)/2.5)?Share.mouseScrollFactor*(mouseY-((((Share.thumbHeight+Share.gridSpacing)*(Share.gridYMax-1))/2)+Share.startY)):0
					pos=moveCalc<0?-1:1;
					moveFactor=Math.abs(Share.mouseScrollFactor*moveCalc)>Share.mouseScrollMaxSpeed?Share.mouseScrollMaxSpeed*pos:moveCalc*Share.mouseScrollFactor;
					if (imageHolder.y-moveFactor<=0 && (imageHolder.y-moveFactor)>=0-((Share.thumbHeight+Share.gridSpacing)*(Math.ceil(Share.imageArray.length/Share.gridXMax))-Share.thumbHeight*(Share.gridYMax-.5))) {
						imageHolder.y-=moveFactor;
					} else {
						if (imageHolder.y-moveFactor>=0) {
							imageHolder.y=0;
						} else {
							imageHolder.y=0-((Share.thumbHeight+Share.gridSpacing)*(Math.ceil(Share.imageArray.length/Share.gridXMax))-Share.thumbHeight*(Share.gridYMax-.5));
						}
					}
					for (var k:Number =0; k<(Share.imageArray.length/Share.gridXMax); k++) {
						for (var l:Number = 0; l<Share.gridXMax; l++) {
							var image3:Picture = imageHolder.getChildByName("pic"+k+"-"+l) as Picture;
							var image4:Picture =imageHolder.getChildByName("pic"+k+"-"+l+"ref") as Picture;
							if(image3!=null){
								if((imageHolder.y+image3.y<Share.startY-Share.thumbHeight) ){
									if(image3.alpha>0){
										SimpleFade.fadeOut(image3,1);
									}
									if(image4!=null){
										if(image4.alpha>0){
											SimpleFade.fadeOut(image4,1);
										}
									}
								} else if(imageHolder.y+image3.y>Share.startY+((Share.thumbHeight+Share.gridSpacing)*(Share.gridYMax))+Share.thumbHeight) {
									if(image3.alpha>0){
										SimpleFade.fadeOut(image3,1);	 
									}
									if(image4!=null){
										if(image4.alpha>0){
											SimpleFade.fadeOut(image4,1);
										}
									}						
								} else {
									if(image3.alpha<1){
										SimpleFade.fadeIn(image3,1);	 
									}
									if(image4!=null){
										if(image2.alpha<1){
											SimpleFade.fadeIn(image4,1)
										}
									}
								}
							}
						}
					}
				}
			}
		}
		private function rollOver_eh(event_f:Event) {
			if (inMotion) {
			} else {
				event_f.target.removeEventListener(MouseEvent.ROLL_OVER, rollOver_eh);
				var image=event_f.target;
				image.mOver = true
				if(Share.thumbReflection==true){
					try{
						var image2=imageHolder.getChildByName(String(event_f.target.name+"ref"))
						if (Share.thumbCover!=false) {
							var cover2=image2.holder.getChildByName("thumbCover");
							SimpleFade.fadeOut(cover2,Share.thumbCoverFadeSpeed);
						}
						if (Share.thumbScale) {
							var num2=imageHolder.numChildren;
							imageHolder.setChildIndex(image2, num2-1);
							
							switch(Share.thumbScaleEffect){
								case ("elastic"):
									SimpleScaleEffect.scaleEffect(image2,(25-Share.thumbScaleEffectSpeed+5),Share.thumbScaleSize,"elastic");
									SimpleSlide.slideUp(image2,(25-Share.thumbScaleEffectSpeed+5)*.25,((image2.y-(Share.thumbWidth+Share.thumbBgSize)-image.y)+(Share.thumbHeight-(Share.thumbHeight*Share.thumbScaleSize))))
								break;
								case ("bounce"):
									SimpleScaleEffect.scaleEffect(image2,(25-Share.thumbScaleEffectSpeed+5),Share.thumbScaleSize, "bounce");
									SimpleSlide.slideUp(image2,(25-Share.thumbScaleEffectSpeed+5)*.25,((image2.y-(Share.thumbWidth+Share.thumbBgSize)-image.y)+(Share.thumbHeight-(Share.thumbHeight*Share.thumbScaleSize))))
								break;
								
								default:
									SimpleScale.scaleUp(image2,(25-Share.thumbScaleEffectSpeed+5),Share.thumbScaleSize);
									SimpleSlide.slideUp(image2,(25-Share.thumbScaleEffectSpeed+5),((image2.y-(Share.thumbWidth+Share.thumbBgSize)-image.y)+(Share.thumbHeight-(Share.thumbHeight*Share.thumbScaleSize))))
								break;
							}
						}
						if (Share.thumbGray!=false) {
							image2.fadeGray(Share.thumbGraySpeed);
						}
					}catch(e){
						
					}
				}
				if (Share.thumbCover!=false) {
					var cover=image.holder.getChildByName("thumbCover");
					SimpleFade.fadeOut(cover,Share.thumbCoverFadeSpeed);
				}
				if (Share.thumbScale!=false) {
					var num=imageHolder.numChildren;
					imageHolder.setChildIndex(image, num-1);
							var inTweenY:Tween;
							var inTweenX:Tween;
							var inTweenZ:Tween;
							switch(Share.thumbScaleEffect){
								case ("elastic"):
									SimpleScaleEffect.scaleEffect(image,(25-Share.thumbScaleEffectSpeed+5),Share.thumbScaleSize,"elastic");
								break;
								case ("bounce"):
									SimpleScaleEffect.scaleEffect(image,(25-Share.thumbScaleEffectSpeed+5),Share.thumbScaleSize, "bounce");
								break;
								
								default:
									SimpleScale.scaleUp(image,(25-Share.thumbScaleEffectSpeed+5),Share.thumbScaleSize);
								break;
								
							}
				}
				if (Share.thumbGray!=false) {
					image.fadeGray(Share.thumbGraySpeed);
				}
				event_f.target.addEventListener(MouseEvent.ROLL_OUT, rollOut_eh);				
			}
		}
		private function rollOut_eh(event_f:Event) {
			if (inMotion) {
			} else {
				event_f.target.removeEventListener(MouseEvent.ROLL_OUT, rollOut_eh);
				var imageName:String =  "pic"+String(event_f.target.name).substr(3,event_f.target.name.length);
				var image=imageHolder.getChildByName(imageName);
				image.mOver = false
				if(Share.thumbReflection==true){
					try{
						var image2=imageHolder.getChildByName(String(event_f.target.name+"ref"))
						if (Share.thumbCover!=false) {
							var cover2=image2.holder.getChildByName("thumbCover");
							cover2.alpha=0;
							SimpleFade.fadeIn(cover2,Share.thumbCoverFadeSpeed);
						}
						if (Share.thumbScale!=false) {
							var inTweenX2:Tween;
							var inTweenY2:Tween;
							var inTweenZ2:Tween;
							switch(Share.thumbScaleEffect){
								case ("elastic"):
									SimpleScaleEffect.scaleEffect(image2,(25-Share.thumbScaleEffectSpeed+5),1, "elastic");
									SimpleSlide.slideDown(image2,(25-Share.thumbScaleEffectSpeed+5)*.25,((image.y+(Share.thumbWidth+Share.thumbBgSize)))-image2.y)
								break;
								case ("bounce"):
									SimpleScaleEffect.scaleEffect(image2,(25-Share.thumbScaleEffectSpeed+5),1, "bounce");
									SimpleSlide.slideDown(image2,(25-Share.thumbScaleEffectSpeed+5)*.7,((image.y+(Share.thumbWidth+Share.thumbBgSize)))-image2.y)
								break;
								
								default:
									SimpleScale.scaleDown(image2,(25-Share.thumbScaleEffectSpeed+5),1);
									SimpleSlide.slideDown(image2,(25-Share.thumbScaleEffectSpeed+5),((image.y+(Share.thumbWidth+Share.thumbBgSize)))-image2.y)
								break;
							}
						}
						if (Share.thumbGray!=false) {
							image2.fadeGray(Share.thumbGraySpeed);
						}
					}catch(e){
					}
				}
				if (Share.thumbCover!=false) {
					var cover=image.holder.getChildByName("thumbCover");
					cover.alpha=0;
					SimpleFade.fadeIn(cover,Share.thumbCoverFadeSpeed);
				}
				if (Share.thumbScale!=false) {
							var inTweenX:Tween;
							var inTweenY:Tween;
							var inTweenZ:Tween;							
							switch(Share.thumbScaleEffect){
								case ("elastic"):
									SimpleScaleEffect.scaleEffect(image,(25-Share.thumbScaleEffectSpeed+5),1,"elastic");
								break;
								case ("bounce"):
									SimpleScaleEffect.scaleEffect(image,(25-Share.thumbScaleEffectSpeed+5),1,"bounce");
								break;
								
								default:
									SimpleScale.scaleDown(image,(25-Share.thumbScaleEffectSpeed+5),1);
								break;
							}
							
					
				}
				if (Share.thumbGray!=false) {
					image.fadeGray(Share.thumbGraySpeed);
				}
				event_f.target.addEventListener(MouseEvent.ROLL_OVER, rollOver_eh);
			}
		}
		private function click_eh(event_f:Event) {
			if(Share.thumbClickAction!="url"){
				currentImage=event_f.currentTarget.num;
				pageOver=true;
				var loader:Loader = new Loader()
				var url:URLRequest = new URLRequest(Share.imageArray[currentImage][0])
				loader.load(url)
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, stretch_eh)
				image = new MovieClip()
				image.addChild(loader)
			}else {
				currentImage=event_f.currentTarget.num;
				var url2:URLRequest=new URLRequest(Share.imageArray[currentImage][2]);
				navigateToURL(url2,"_blank");
			}
		}
		private function stretch_eh(event_f:Event){
				event_f.target.removeEventListener(Event.COMPLETE, stretch_eh)
				var bg:Shape = new Shape();
				pageBg = new Shape();

				if (Share.bgFade!=true) {
					pageBg.graphics.beginFill(Share.bgFadeColor,0);
				} else {
					pageBg.graphics.beginFill(Share.bgFadeColor, Share.bgFadeAlpha);
				}
				if (Share.insideSWF!=true) {
					pageBg.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
				} else {
					pageBg.graphics.drawRect(trueX0,trueY0, stage.stageWidth,stage.stageHeight);
				}

				var pageBgMC:MovieClip = new MovieClip();
				pageBgMC.addChild(pageBg);
				pageBgMC.alpha=0;
				SimpleFade.fadeIn(pageBgMC, 8);

				bg.graphics.beginFill(Share.imageBgColor,Share.imageBgAlpha);
				bg.graphics.drawRect(0,0, Share.thumbWidth, Share.thumbHeight);
				bg.graphics.endFill();
				bg.x=-(Share.thumbWidth/2);
				bg.y=-(Share.thumbHeight/2);

				var bgMC:MovieClip = new MovieClip();
				bgMC.addChild(bg);

				if (Share.insideSWF!=true) {
					bgMC.x = bgMC.width/2+(stage.stageWidth-bgMC.width)/2;
					bgMC.y = bgMC.height/2+(stage.stageHeight-bgMC.height)/2;
				} else {
					bgMC.x = trueX0+(bgMC.width/2+(stage.stageWidth-bgMC.width)/2);
					bgMC.y = trueY0+(bgMC.height/2+(stage.stageHeight-bgMC.height)/2);
				}

				bgHolder.addChild(pageBgMC);
				bgHolder.addChild(bgMC);
				stretchWide(bgMC);
		}
		private function stretchWide(imgBg:MovieClip) {
			var imgWidth:Number;
			if (image.width>image.height) {
				imgWidth=image.width>Share.imageMaxWidth?Share.imageMaxWidth:image.width;
				SimpleScale.scaleWidth(imgBg, 7,Number((imgWidth+Share.imageBgSize)/Share.thumbWidth));
				imgBg.addEventListener(SimpleScale.SCALE_COMPLETE, stretchHigh);
			} else {
				imgWidth=image.width>Share.imageMaxWidth?image.width*(Share.imageMaxHeight/image.height):image.width;
				SimpleScale.scaleWidth(imgBg, 7,Number((imgWidth+Share.imageBgSize)/Share.thumbWidth));
				imgBg.addEventListener(SimpleScale.SCALE_COMPLETE, stretchHigh);
			}
		}
		private function stretchHigh(event_f:Event) {
			event_f.target.removeEventListener(SimpleScale.SCALE_COMPLETE, stretchHigh);
			var imgBg=event_f.target;
			var imgHeight:Number;
			if (image.height>image.width) {
				imgHeight=image.height>Share.imageMaxHeight?Share.imageMaxHeight:image.height;
				if (Share.imageTitle!=true) {
					SimpleScale.scaleHeight(imgBg, 7,Number((imgHeight+Share.imageBgSize)/Share.thumbHeight));
				} else {
					SimpleScale.scaleHeight(imgBg, 7,Number((imgHeight+Share.imageBgSize+Share.imageTitleHeight)/Share.thumbHeight));
					QuarticSlide.slideDown(imgBg,7, Share.imageTitleHeight/2);
				}
				imgBg.addEventListener(SimpleScale.SCALE_COMPLETE, fadeInPicture);
			} else {
				imgHeight=image.height>Share.imageMaxHeight?image.height*(Share.imageMaxWidth/image.width):image.height;
				if (Share.imageTitle!=true) {
					SimpleScale.scaleHeight(imgBg, 7,Number((imgHeight+Share.imageBgSize)/Share.thumbHeight));
				} else {
					SimpleScale.scaleHeight(imgBg, 7,Number((imgHeight+Share.imageBgSize+Share.imageTitleHeight)/Share.thumbHeight));
					QuarticSlide.slideDown(imgBg,7, Share.imageTitleHeight/2);
				}
				imgBg.addEventListener(SimpleScale.SCALE_COMPLETE, fadeInPicture);
			}
		}
		private function fadeInPicture(event_f:Event) {
			event_f.target.removeEventListener(SimpleScale.SCALE_COMPLETE, fadeInPicture);
			var imgBg=event_f.target;
			
			if (image.width>image.height) {
				image.height=image.height>Share.imageMaxHeight?image.height*(Share.imageMaxWidth/image.width):image.height;
				image.width=image.width>Share.imageMaxWidth?Share.imageMaxWidth:image.width;
			} else {
				image.width=image.width>Share.imageMaxWidth ? image.width*(Share.imageMaxHeight/image.height) : image.width;
				image.height=image.height>Share.imageMaxHeight?Share.imageMaxHeight:image.height;
			}
			if (Share.insideSWF!=true) {
				image.x = (stage.stageWidth-image.width)/2;
				image.y = (stage.stageHeight-image.height)/2;
				image.alpha=0;
			} else {
				image.x = trueX0+((stage.stageWidth-image.width)/2);
				image.y = trueY0+((stage.stageHeight-image.height)/2);
				image.alpha=0;
			}
			SimpleFade.fadeIn(image,Share.imageFadeSpeed);
			if (Share.imageTitle!=false) {
				var imageTitle:DynamicHTMLText = new DynamicHTMLText();
				imageTitle.mouseEnabled=false;
				imageTitle.setBounds(Share.imageTitleHeight,image.width);
				imageTitle.setFadeInDelay(0);
				imageTitle.setFadeInSpeed(1);
				imageTitle.setHTMLText("<p align='"+Share.imageTitleAlign+"'><FONT FACE='"+Share.imageTitleFont+"' size='"+Share.imageTitleSize+"' color='#"+Share.imageTitleColor.toString(16)+"'>"+Share.imageArray[currentImage][1]+"</FONT></p>");
				imageTitle.x=imgBg.x-(imgBg.width/2)+Share.imageBgSize;
				imageTitle.y=imgBg.y+(imgBg.height/2)-Share.imageTitleHeight-(Share.imageBgSize/2);
				bgHolder.addChild(imageTitle);
			}
			bgHolder.addChild(image);
			bgHolder.addEventListener(MouseEvent.CLICK, closePic_eh);
		}
		private function closePic_eh(event_f:Event) {
			var num=bgHolder.numChildren;
			bgHolder.removeEventListener(MouseEvent.CLICK, closePic_eh);
			for (var i:Number = 0; i<num; i++) {
				var mc=bgHolder.getChildAt(0);
				bgHolder.removeChildAt(0);
				try {
					mc.kill();
				} catch (e) {
				}
			}
			pageOver=false;
		}
		public function kill(){
			var bgNum= bgHolder.numChildren
			var ihNum = imageHolder.numChildren
			var thisNum = numChildren
			
			for(var i:Number=0;i<bgNum;i++){
				var mc = bgHolder.getChildAt(0)
				try{
					mc.removeEventListener(MouseEvent.CLICK, closePic_eh);
					mc.removeEventListener(SimpleScale.SCALE_COMPLETE, fadeInPicture);
					mc.removeEventListener(SimpleScale.SCALE_COMPLETE, stretchHigh);
					bgHolder.removeChildAt(0)
					mc.kill()
				}catch(e){
				}
			}
			
			for(var j:Number=0;j<ihNum;j++){
				var mc1 = imageHolder.getChildAt(0)
				try{
					mc1.removeEventListener(MouseEvent.ROLL_OVER, rollOver_eh);
					mc1.removeEventListener(MouseEvent.CLICK, click_eh);
					mc1.removeEventListener(MouseEvent.ROLL_OUT, rollOut_eh);				
					imageHolder.removeChildAt(0)
					mc1.kill()
				}catch(e){
				}
			}
			
			for(var k:Number=0;k<thisNum;k++){
				var mc2 = getChildAt(0)
				try{
					mc2.removeEventListener(QuarticSlide.EFFECT_COMPLETE, slideComplete_eh);
					mc2.removeEventListener(MouseEvent.CLICK,buttonLeft_eh);
					mc2.removeEventListener(MouseEvent.CLICK,buttonRight_eh);
					removeChildAt(0)
					mc2.kill()
				}catch(e){
				}
			}
			removeEventListener(Event.ENTER_FRAME, mouseScroller_eh);
					
			delete this
			
		}
	}
}
