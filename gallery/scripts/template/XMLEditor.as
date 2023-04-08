package scripts.template{
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.display.Shape
	import scripts.utilities.XMLLoader;
	import scripts.components.XMLLine;
	import scripts.components.Share;
	import fl.controls.Button;
	
	public class XMLEditor extends MovieClip {
		private var CL:XMLLoader;
		private var line:XMLLine;
		private var Parent:Object
		private var lineCount:Number=0;
		private var lineBoundX:Number=940;
		private var lineBoundY:Number = 460;
		private var lineHolder:MovieClip;
		private var linePadX:Number=15;
		private var linePadY:Number=32;
		public var editorWindow:MovieClip;
		
		
		public function XMLEditor() {
			init();
		}
		private function init() {
			lineHolder=new MovieClip();
			CL = new XMLLoader();
			CL.setFileName("content.xml");
			CL.init();
			CL.addEventListener(XMLLoader.XML_LOADED, contentLoaded_eh);
			addChild(lineHolder);
			editorWindow.visible=false;
			lineHolder.visible=false;
		}
		public function setParent(parent_f:Object){
			Parent = parent_f
		}
		private function contentLoaded_eh(event_f:Event):void {
			var contentXML:XML=event_f.currentTarget.getDataXML();
			var col:Number=0;
			var row:Number=0;
			for each (var node:XML in contentXML.config.*) {
				if (node.@name!="") {
					var line:XMLLine = new XMLLine();
					line.setVars(node);
					line.init()
					line.num=lineCount;
					line.name=String(node.localName());
					
					line.y=linePadY+(25*row);
					line.x = linePadX+(225 * col);
					row++;
					if(line.y+linePadY>lineBoundY){
						col++
						row=0;
						line.y=linePadY+(25*row);
						line.x=linePadX+(225 * col);
						row++;
					}
					lineHolder.addChild(line);
					
					lineCount++;
					
				}
			}
			x=(stage.stageWidth-lineBoundX)/2;
			y=(stage.stageHeight-lineBoundY)/2;
			btn_show.y = 0-((stage.stageHeight-lineBoundY)/2);
			btn_show.x = 0-((stage.stageWidth-lineBoundX)/2)+((stage.stageWidth-btn_show.width)/2);
			editorWindow.btn_apply.addEventListener(MouseEvent.CLICK, reloadGal_eh)
			btn_show.addEventListener(MouseEvent.CLICK,showOptions_eh);
		}
		private function showOptions_eh(event_f:Event){
			editorWindow.visible=true;
			lineHolder.visible=true;
			btn_show.visible=false;
		}
		private function reloadGal_eh(event_f:Event){
			for(var i:Number = 0;i<lineCount;i++){
				var lineItem = lineHolder.getChildAt(i);
				var currentValue:String = lineItem.getValue()
				if(Share[lineItem.name] is String){
					   Share[lineItem.name]=currentValue;
				}
				if(Share[lineItem.name] is Boolean){
					   Share[lineItem.name]=currentValue=="true"?true:false;
				}
				if(Share[lineItem.name] is Number){
					   Share[lineItem.name]=Number(currentValue);
				}
				if(Share[lineItem.name] is uint){
					   Share[lineItem.name]=uint(String(currentValue));
				}
			}
			editorWindow.visible=false;
			lineHolder.visible=false;
			btn_show.visible=true;
			Parent.reloadGallery()
		}
	}
}