package scripts.utilities{
	import flash.net.URLLoader;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	//import scripts.Components.Share;

	//
	/////////////////////////
	//
	//
	//  Modified for Display Collection 1.5 from the common code library
	//
	//
	////////////////////////
	//
	//
	//
	public class XMLLoader extends EventDispatcher {
		private var vtrace:Function = new Function();
		private var loaded:Boolean=false;
		private var reload:Boolean=false;
		private var reloadTimer:Timer;
		private var reloadDelay:Number= 60000*15;
		private var urlLoader:URLLoader;
		public var dataList:XMLList= new XMLList();
		public var dataXML:XML = new XML();
		public var configXML:XMLList;
		public var fileName:String="";
		public var localString:String="";
		public static  const XML_LOADED:String="XMLLoaded";
		private var enableDebugMode:Boolean=false;
		private var enableErrorLog:Boolean=false;
		private var className:String ="XMLLoader";
		public function XMLLoader() {
			//vtrace = Share.vtrace;
		}
		////////////////////////
		//
		//  KILL FUNCTION
		//
		///////////////////////
		public function kill() {
			vtrace = new Function();
			reloadTimer.stop();
			reloadTimer.removeEventListener(TimerEvent.TIMER,timerHandler);
			try {
				urlLoader.removeEventListener(Event.COMPLETE,content_Loaded);
				urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			} catch (e:Error) {
			}
			try {
				urlLoader.close();
			} catch (e:Error) {
			}
			delete this;
		}
		public function setLocalString(localString_f:String) {
			localString=localString_f;
		}
		////////////////////////
		//
		//  END KILL FUNCTION
		//
		///////////////////////
		public function setReloadDelay(reloadDelay_f:Number) {
			vtrace("Reload enabled and set for "+reloadDelay_f+"ms for "+fileName,7,className);
			reloadDelay=reloadDelay_f;
			reload=true;
		}
		public function setFileName(fileName_f:String) {
			vtrace("Filename set to " +fileName_f,7,className);
			fileName=fileName_f;
		}
		public function getDataXML():XML {
			if (!loaded) {
				vtrace("Data requested using getDataXML function but xml has not yet been loaded for "+fileName,4,className);
			}
			return dataXML;
		}
		public function getDataList():XMLList {
			if (!loaded) {
				vtrace("Data requested using getDataList function but xml has not yet been loaded for "+fileName,4,className);
			}
			return dataList;
		}
		public function init() {
			loadContent();
			reloadTimer=new Timer(reloadDelay,0);
			reloadTimer.addEventListener(TimerEvent.TIMER,timerHandler);
			reloadTimer.start();
		}
		public function ioErrorHandler(event_f:IOErrorEvent) {
			vtrace("IO Error caught:"+event_f,3,className);
			//
			//
		}
		public function isLoaded():Boolean {
			return loaded;

		}
		private function loadContent() {
			loaded=false;
			var urlRequest:URLRequest=new URLRequest(String(localString+fileName));
			urlLoader=new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE,content_Loaded);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			urlLoader.load(urlRequest);
			vtrace("Initalizing load of "+fileName,5,className);
		}
		public function timerHandler(event:TimerEvent):void {
			vtrace("ReloadTimer triggered for " +fileName,5,className);
			loadContent();
		}
		private function content_Loaded(event_f:Event) {
			var contentFileXML:XML;
			var success:Boolean = true;
			var tempXMLList:XMLList = new XMLList();

			try {
				contentFileXML=new XML(urlLoader.data);
				tempXMLList=contentFileXML.*;
			} catch (e:Error) {
				success = false;
				vtrace("Error in loaded file "+fileName+" while retriving xml data, error is: "+e.message,3,className);
				//Write to error log here.
			} finally {
				if (success) {
					loaded=true;
					dataList=new XMLList();
					dataList=tempXMLList;
					dataXML = new XML();
					dataXML = contentFileXML;
					vtrace("Sucessfully loaded "+fileName,5,className);
					dispatchEvent(new Event(XML_LOADED));
				}
				urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				urlLoader.removeEventListener(Event.COMPLETE,content_Loaded);
			}
		}
	}
}