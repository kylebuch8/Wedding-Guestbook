package views.message 
{
	import controllers.MessageInputController;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import models.GuestbookModel;
	import flash.utils.ByteArray;
	import views.message.controls.CloseControl;
	import views.message.controls.DoneControl;
	import views.message.controls.MoveControl;
	import views.message.controls.ResizeControl;
	import views.message.controls.RotateControl;
	import views.Wall;
	import views.DynamicSprite;
	import flash.filters.DropShadowFilter;
	
	import caurina.transitions.Tweener;
	
	/**
	 * ...
	 * @author Kyle Buchanan
	 */
	public class MessageInput extends DynamicSprite
	{
		[Embed(source = "Z:\\kylbucha\\Library\\Fonts\\AGaramondPro-Regular.otf", fontName = "Adobe Garamond Pro")]
		public static const ADOBE_GARAMOND_PRO:Class;
		
		[Embed(source = "Z:\\kylbucha\\Library\\Fonts\\Alpine Script.otf", fontName = "Alpine Script")]
		public static const ALPINE_SCRIPT:Class;
		
		[Embed(source = "Z:\\kylbucha\\Library\\Fonts\\MuseoSans_500.otf", fontName = "Museo Sans")]
		public static const MUSEO_SANS:Class;
		
		[Embed(source = "Z:\\kylbucha\\Library\\Fonts\\Scriptonah_Demibold.otf", fontName = "Scriptonah")]
		public static const SCRIPTONAH:Class;
		
		private var _model:GuestbookModel;
		private var _controller:MessageInputController;
		private var _wall:Wall;
		
		private var _container:Sprite;
		private var _initialWidth:Number = 250;
		private var _initialHeight:Number = 150;
		private var _padding:Number = 20;
		
		private var _moveControl:MoveControl;
		private var _rotateControl:RotateControl;
		private var _resizeControl:ResizeControl;
		private var _closeControl:CloseControl;
		private var _doneControl:DoneControl;
		
		private var _background:Sprite;
		private var _textField:TextField;
		private var _textFormat:TextFormat;
		
		private var _previousRadians:Number;
		
		public function MessageInput() 
		{
			_container = new Sprite();
			
			createTextFormats();
			createTextField();		
			buildControls();
			
			addChild(_container);
			
			setRegistration(_container.width / 2, _container.height / 2);
			addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, true);
		}
		
		private function createTextFormats():void
		{
			_textFormat = new TextFormat();
			_textFormat.font = "Adobe Garamond Pro";
			_textFormat.size = 20;
			_textFormat.color = 0xb50000;
		}
		
		private function createTextField():void
		{
			_background = new Sprite();
			_background.graphics.beginFill(0xFFFFFF);
			_background.graphics.drawRect(0, 0, _initialWidth, _initialHeight);
			_background.graphics.endFill();
			_background.alpha = 0.6;
			_background.filters = [new DropShadowFilter(0, 90, 0, 1, 4, 4)];
			_container.addChild(_background);
			
			_textField = new TextField();
			_textField.defaultTextFormat = _textFormat;
			_textField.embedFonts = true;
			_textField.multiline = true;
			_textField.type = TextFieldType.INPUT;
			_textField.wordWrap = true;
			_textField.width = _initialWidth - _padding;
			_textField.height = _initialHeight - _padding;
			_textField.x = _padding / 2;
			_textField.y = _padding / 2;
			_textField.addEventListener(TextEvent.TEXT_INPUT, textField_textInputHandler, false, 0, true);
			_container.addChild(_textField);
		}
		
		private function textField_textInputHandler(pEvent:TextEvent):void
		{
			_textField.autoSize = TextFieldAutoSize.LEFT;
		}
		
		private function enterFrameHandler(pEvent:Event):void
		{
			checkTextFieldSize();
		}
		
		private function checkTextFieldSize():void
		{
			if (_textField.height + _padding > _background.height)
			{	
				trace("checking text field size");
				trace("TextField Height + Padding: " + (_textField.height + _padding));
				trace("Background Height: " + _background.height);
				_background.height = _textField.height + _padding;
				_rotateControl.y = _background.height;
				_doneControl.y = _background.height - (_doneControl.height / 2);
				_resizeControl.y = _background.height;
				
				checkBounds();
			}
		}
		
		private function buildControls():void
		{
			_moveControl = new MoveControl();
			_moveControl.addEventListener(MouseEvent.MOUSE_DOWN, moveControl_mouseDownHandler, false, 0, true);
			_moveControl.addEventListener(MouseEvent.MOUSE_UP, moveControl_mouseUpHandler, false, 0, true);
			_container.addChild(_moveControl);
			
			_rotateControl = new RotateControl();
			_rotateControl.y = _background.height;
			_rotateControl.addEventListener(MouseEvent.MOUSE_DOWN, rotateControl_mouseDownHandler, false, 0, true);
			_rotateControl.addEventListener(MouseEvent.MOUSE_UP, rotateControl_mouseUpHandler, false, 0, true);
			_container.addChild(_rotateControl);
			
			_resizeControl = new ResizeControl();
			_resizeControl.x = _background.width;
			_resizeControl.y = _background.height;
			_resizeControl.addEventListener(MouseEvent.MOUSE_DOWN, resizeControl_mouseDownHandler, false, 0, true);
			_container.addChild(_resizeControl);
			
			_closeControl = new CloseControl();
			_closeControl.x = _background.width;
			_closeControl.addEventListener(MouseEvent.MOUSE_UP, closeControl_mouseUpHandler, false, 0, true);
			_container.addChild(_closeControl);
			
			_doneControl = new DoneControl();
			_doneControl.x = (_background.width / 2) - (_doneControl.width / 2);
			_doneControl.y = _background.height - (_doneControl.height / 2);
			_doneControl.addEventListener(MouseEvent.MOUSE_UP, doneControl_mouseUpHandler, false, 0, true);
			_container.addChild(_doneControl);
		}
		
		private function moveControl_mouseDownHandler(pEvent:MouseEvent):void
		{
			this.stage.addEventListener(MouseEvent.MOUSE_UP, moveControl_mouseUpHandler, false, 0, true);
			this.startDrag();
		}
		
		private function moveControl_mouseUpHandler(pEvent:MouseEvent):void
		{
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, moveControl_mouseUpHandler);
			this.stopDrag();
			
			checkBounds();
		}
		
		private function rotateControl_mouseDownHandler(pEvent:MouseEvent):void
		{
			_previousRadians = Math.atan2(mouseY2, mouseX2) * (180 / Math.PI);
			addEventListener(Event.ENTER_FRAME, rotateControl_enterFrameHandler, false, 0, true);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, rotateControl_mouseUpHandler, false, 0, true);
		}
		
		private function rotateControl_mouseUpHandler(pEvent:MouseEvent):void
		{
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, rotateControl_mouseUpHandler);
			removeEventListener(Event.ENTER_FRAME, rotateControl_enterFrameHandler);
			
			checkBounds();
		}
		
		private function rotateControl_enterFrameHandler(pEvent:Event):void
		{
			this.rotation2 += (Math.atan2(mouseY2, mouseX2) * (180 / Math.PI)) - _previousRadians;
		}
		
		private function resizeControl_mouseDownHandler(pEvent:MouseEvent):void
		{
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			
			_textField.autoSize = TextFieldAutoSize.NONE;
			_resizeControl.startDrag(false, new Rectangle(_rotateControl.x + _doneControl.width + 40, _resizeControl.y - _background.height + 40, stage.width, stage.height));
			addEventListener(Event.ENTER_FRAME, resizeControl_enterFrameHandler, false, 0, true);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, resizeControl_mouseUpHandler, false, 0, true);
		}
		
		private function resizeControl_mouseUpHandler(pEvent:MouseEvent):void
		{
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			
			trace("resizeControl_mouseUpHandler()");
			_resizeControl.stopDrag();
			removeEventListener(Event.ENTER_FRAME, resizeControl_enterFrameHandler);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, resizeControl_mouseUpHandler);
			
			checkBounds();
			this.setRegistration(_container.width / 2, _container.height / 2);
		}
		
		private function resizeControl_enterFrameHandler(pEvent:Event):void
		{
			_background.width = _resizeControl.x;
			_background.height = _resizeControl.y;
			
			_textField.width = _background.width - _padding;
			_textField.height = _background.height - _padding;
			
			_closeControl.x = _background.width;
			_rotateControl.y = _background.height;
			
			_doneControl.x = (_background.width / 2) - (_doneControl.width / 2);
			_doneControl.y = _background.height - (_doneControl.height / 2);
		}
		
		private function closeControl_mouseUpHandler(pEvent:MouseEvent):void
		{
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			_controller.closeInput();
		}
		
		private function doneControl_mouseUpHandler(pEvent:MouseEvent):void
		{
			if (_textField.text != '')
			{
				var point:Point = localToGlobal(new Point(_container.x + _textField.x, _container.y + _textField.y));
				var xDistance:Number = point.x - _wall.x;
				var yDistance:Number = point.y - _wall.y;
				
				removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
				_controller.saveMessage(_textField.text, xDistance, yDistance, _textField.width, _textField.height, this.rotation, _textFormat.font, _textFormat.size as Number, _textFormat.color as uint);
			}
			else
			{
				trace("Error: Need to enter text");
			}
		}
		
		public function updateStyle(pDropdown:String, pValue:*):void
		{
			switch (pDropdown)
			{
				case "Font":
					updateFont(pValue);
					break;
					
				case "Size":
					updateSize(pValue);
					break;
					
				case "Color":
					updateColor(pValue);
					break;
			}
		}
		
		private function updateFont(pFont:String):void
		{
			switch (pFont)
			{
				case "Serif":
					_textFormat.font = "Adobe Garamond Pro";
					break;
					
				case "Sans Serif":
					_textFormat.font = "Museo Sans";
					break;
					
				case "Casual":
					_textFormat.font = "Scriptonah";
					break;
					
				case "Formal":
					_textFormat.font = "Alpine Script";
					break;
			}
			
			updateTextFieldFormat();
		}
		
		private function updateSize(pSize:String):void
		{
			switch (pSize)
			{
				case "X-Small":
					_textFormat.size = 12;
					break;
					
				case "Small":
					_textFormat.size = 16;
					break;
					
				case "Medium":
					_textFormat.size = 20;
					break;
					
				case "Large":
					_textFormat.size = 24;
					break;
					
				case "X-Large":
					_textFormat.size = 28;
					break;
			}
			
			updateTextFieldFormat();
		}
		
		private function updateColor(pColor:uint):void
		{
			_textFormat.color = pColor;
			updateTextFieldFormat();
		}
		
		private function updateTextFieldFormat():void
		{
			if (_textField.text.length == 0)
			{
				_textField.defaultTextFormat = _textFormat;
			}
			else
			{
				_textField.setTextFormat(_textFormat);
			}
		}
		
		public function removeControls():void
		{
			var copiedTextField:TextField = _textField;
			copiedTextField.border = false;
			copiedTextField.selectable = false;
			copiedTextField.type = TextFieldType.DYNAMIC;
			copiedTextField.x = _container.x + (_padding / 2);
			copiedTextField.y = _container.y + (_padding / 2);
			addChild(copiedTextField);
			
			dispatchEvent(new Event(Event.COMPLETE));
			
			Tweener.addTween(_container, { alpha: 0, time: 1, onComplete: function():void
			{
				this.parent.removeChild(this);
			} } );
		}
		
		public function checkBounds():void
		{
			trace("MessageInput :: checkBounds()");
			var bounds:Rectangle = getBounds(this);
			var corners:Array = [localToGlobal(new Point(bounds.left, bounds.top)), localToGlobal(new Point(bounds.left, bounds.bottom)), localToGlobal(new Point(bounds.right, bounds.top)), localToGlobal(new Point(bounds.right, bounds.bottom))];
			
			var xPos:Number = 0;
			var yPos:Number = 0;
			var move:Boolean = false;
			
			for each (var point:Point in corners)
			{
				if (point.x < 0 || point.x > stage.stageWidth)
				{
					move = true;
					if (point.x < 0)
					{
						if (point.x < xPos)
						{
							xPos = point.x;
						}
					}
					
					if (point.x > stage.stageWidth)
					{
						if (point.x > xPos)
						{
							xPos = point.x;
						}
					}
				}
				
				if (point.y < 0 || point.y > stage.stageHeight)
				{
					move = true;
					if (point.y < 0)
					{
						if (point.y < yPos)
						{
							yPos = point.y;
						}
					}
					
					if (point.y > stage.stageHeight)
					{
						if (point.y > yPos)
						{
							yPos = point.y;
						}
					}
				}
			}
			
			if (move)
			{
				if (yPos < 0)
				{
					yPos = yPos * -1 + 20;
				}
				
				if (yPos > stage.stageHeight)
				{
					yPos = stage.stageHeight - yPos - 20;
				}
				
				if (xPos < 0)
				{
					xPos = xPos * -1 + 20;
				}
				
				if (xPos > stage.stageWidth)
				{
					xPos = stage.stageWidth - xPos  - 20;
				}
				
				_wall.move(new Point(xPos, yPos));
			}
		}
		
		public function setFocus():void
		{
			this.stage.focus = _textField;
		}
		
		// Getter and Setter Methods
		public function set controller(pController:MessageInputController):void { _controller = pController; }
		public function get controller():MessageInputController { return _controller; }
		public function set model(pModel:GuestbookModel):void { _model = pModel; }
		public function get model():GuestbookModel { return _model; }
		public function get wall():Wall { return _wall; }
		public function set wall(pWall:Wall):void { _wall = pWall; }
		
	}

}