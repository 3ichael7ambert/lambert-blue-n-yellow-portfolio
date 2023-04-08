package scripts.components{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import fl.controls.ComboBox;
	import fl.controls.TextInput;
	import fl.controls.ColorPicker;
	import fl.controls.Slider;
	import fl.controls.SliderDirection;
	import fl.controls.NumericStepper;

	public class XMLLine extends MovieClip {
		private var varTitle:TextField;
		private var varInput:TextInput;
		private var varStepper:NumericStepper;
		private var varBoolean:ComboBox;
		private var varOption:ComboBox;
		private var fieldName:String;
		private var fieldValue:String;
		private var valueType:String;
		private var options:Array;
		private var varSlider:Slider;
		private var varColor:ColorPicker;
		private var fieldObject:Object;
		private var step:Number;
		private var min:Number;
		private var max:Number;
		public var tf_Name:TextField;
		public function XMLLine() {
			options=new Array  ;
			fieldObject = new Object();
		}
		public function setVars(node_f:XML){
			fieldName = String(node_f.@name);
			valueType = String(node_f.@value);
			fieldValue = String(node_f);
			step = String(node_f.@step)!="" ? Number(node_f.@step) : 1; 
			min = String(node_f.@min)!="" ? Number(node_f.@min) : -9999; 
			max = String(node_f.@max)!="" ? Number(node_f.@max) : 9999; 			
			options= new Array();
			if(String(node_f.@option1)!=""){
				options.push(String(node_f.@option1));
			}
			if(String(node_f.@option2)!=""){
				options.push(String(node_f.@option2));
			}
			if(String(node_f.@option3)!=""){
				options.push(String(node_f.@option3));
			}
			if(String(node_f.@option4)!=""){
				options.push(String(node_f.@option4));
			}
			if(String(node_f.@option5)!=""){
				options.push(String(node_f.@option5));
			}
			if(String(node_f.@option6)!=""){
				options.push(String(node_f.@option6));
			}
		}
		public function getValue():String {
			var currentValue:String;
			if (varInput!=null) {
				currentValue=varInput.textField.text;
			}
			if (varBoolean!=null) {
				currentValue=varBoolean.textField.text;
			}
			if (varOption!=null) {
				currentValue=varOption.textField.text;
			}
			if (varColor!=null) {
				currentValue=String(varColor.selectedColor);
			}
			if (varSlider!=null){
				currentValue=String(varSlider.value);				
			}
			if (varStepper!=null){
				currentValue=String(varStepper.value);				
			}

			return currentValue;
		}
		public function init() {
			tf_name.text = fieldName;
			//varTitle=new TextField();
			//varTitle.textColor=0xFFFFFF;
			//varTitle.multiline=false;
			//varTitle.selectable=false;
			//varTitle.height=25;
			//varTitle.x=5;
			//varTitle.y=4;
			//varTitle.border=false;
			//varTitle.selectable=false;
			//varTitle.text=fieldName;
			//addChild(varTitle);

			switch (valueType) {
				case "stepper" :
					varStepper = new NumericStepper();
					varStepper.maximum =max;
					varStepper.minimum = min;
					varStepper.stepSize=step;
					
					varStepper.value = Number(fieldValue);					
					varStepper.setSize(80,23);
					varStepper.x=144;
					varStepper.y=-2;
					addChild(varStepper);
					break;
					
				case "number": 
					varInput=new TextInput  ;
					varInput.textField.height=25;
					varInput.textField.maxChars=4;
					varInput.restrict="0-9-.";
					varInput.x=144;
					varInput.y=-2;
					varInput.width=58;
					varInput.text=fieldValue;
					addChild(varInput);
					
				break;
				
				case "uint" :
					varColor=new ColorPicker();
					varColor.x=144;
					varColor.y=-2;
					varColor.selectedColor = uint(fieldValue);
					addChild(varColor);
					break;

				case "boolean" :
					varBoolean=new ComboBox  ;
					varBoolean.dropdownWidth=80;
					varBoolean.width=80;
					varBoolean.height=23;
					varBoolean.addItem({label:"true"});
					varBoolean.addItem({label:"false"});
					varBoolean.selectedIndex=findItemIndex(varBoolean,fieldValue);
					varBoolean.x=144;
					varBoolean.y=-2;
					addChild(varBoolean);

					break;
					
				case "slider":
				
					varSlider= new Slider();
					varSlider.x=144;
					varSlider.y=5;
					varSlider.maximum=max;
					varSlider.minimum=min;
					varSlider.snapInterval= step
					varSlider.value = Number(fieldValue);
					addChild(varSlider);
					
				break;
				case "option" :
					varOption=new ComboBox();
					varOption.dropdownWidth=80;
					for (var i:Number=0; i<options.length; i++) {
						varOption.addItem({label:String(options[i])});
					}

					varOption.selectedIndex=findItemIndex(varOption,fieldValue);
					varOption.x=144;
					varOption.y=-2;
					varOption.setSize(80,23);
					addChild(varOption);
					//
					break;
			}
		}
		private function findItemIndex(element:ComboBox,dataString:String):int {
			var index:int=0;
			for (var i:Number=0; i<element.length; i++) {
				var obj=element.getItemAt(i);
				if (obj.label==dataString) {
					index=i;
					break;
				} else {
				}
			}
			return index;
		}
	}
}