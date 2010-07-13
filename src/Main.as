package 
{
	import controllers.MessageInputController;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import models.GuestbookModel;
	import views.Wall;
	import views.Loading;
	import views.message.controls.dropdown.ColorDropdown;
	import views.message.controls.dropdown.Dropdown;
	import views.message.controls.dropdown.FontDropdown;
	import views.message.controls.dropdown.FontSizeDropdown;
	import views.message.Message;
	import views.message.MessageInput;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.CurveModifiers;
	
	/**
	 * ...
	 * @author Kyle Buchanan
	 */
	public class Main extends Sprite 
	{
		private var _guestbookModel:GuestbookModel;
		private var _messageInputController:MessageInputController;
		private var _messageInput:MessageInput;
		private var _wall:Wall;
		private var _loading:Loading;
		private var _dropdownContainer:Sprite;
		private var _dropdowns:Array = new Array();
		private var _openDropdown:* = null;
		private var _zoomIn:Sprite;
		private var _zoomOut:Sprite;
		
		public function Main():void 
		{
			CurveModifiers.init();
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			setUpApplication();
		}
		
		private function setUpApplication():void
		{
			trace("Guestbook v1.0");
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			_loading = new Loading();
			_loading.scaleX = 0.25;
			_loading.scaleY = 0.25;
			_loading.x = stage.stageWidth / 2;
			_loading.y = stage.stageHeight / 2;
			addChild(_loading);
			
			_guestbookModel = new GuestbookModel();
			getMessages();
			
			_wall = new Wall(new Point(stage.stageWidth / 2, stage.stageHeight / 2));
			_wall.x = stage.stageWidth / 2;
			_wall.y = stage.stageHeight / 2;
			_wall.alpha = 0;
			_wall.addEventListener(MouseEvent.MOUSE_DOWN, wall_mouseDownHandler, false, 0, true);
			_wall.addEventListener(MouseEvent.MOUSE_UP, wall_mouseUpHandler, false, 0, true);
			addChild(_wall);
			
			_messageInputController = new MessageInputController();
			buildDropdowns();
			
			_zoomOut = new Sprite();
			_zoomOut.graphics.beginFill(0x000000, 0.75);
			_zoomOut.graphics.drawRoundRect(0, 0, 20, 20, 5, 5);
			_zoomOut.graphics.endFill();
			_zoomOut.x = 10;
			_zoomOut.y = 10;
			_zoomOut.addEventListener(MouseEvent.MOUSE_UP, zoomOut_mouseUpHandler);
			addChild(_zoomOut);
			
			_zoomIn = new Sprite();
			_zoomIn.graphics.beginFill(0x000000, 0.75);
			_zoomIn.graphics.drawRoundRect(0, 0, 20, 20, 5, 5);
			_zoomIn.graphics.endFill();
			_zoomIn.x = 10;
			_zoomIn.y = _zoomOut.getRect(this).bottom + 10;
			_zoomIn.addEventListener(MouseEvent.MOUSE_UP, zoomIn_mouseUpHandler);
			addChild(_zoomIn);
		}
		
		private function getMessages():void
		{
			_guestbookModel.getMessages();
			_guestbookModel.addEventListener(Event.COMPLETE, guestbookModel_completeHandler, false, 0, true);
		}
		
		private function guestbookModel_completeHandler(pEvent:Event):void
		{
			trace("Done loading messages");
			Tweener.addTween(_loading, { alpha: 0, time: 0.5, onComplete:function():void
			{
				displayMessages();
				Tweener.addTween(_wall, { alpha: 1, time: 0.5 } );
				
				this.stage.doubleClickEnabled = true;
				this.stage.addEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler, false, 0, true);
				
				this.stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
				this.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, false, 0, true);
			} } );
		}
		
		private function displayMessages():void
		{
			for each (var messageXML:XML in _guestbookModel.messagesXML.message)
			{
				var message:Message = new Message(messageXML.text, messageXML.width, messageXML.height, messageXML.font, messageXML.size, messageXML.color);
				message.x = Number(messageXML.xPos);
				message.y = Number(messageXML.yPos);
				message.rotation = messageXML.rotation;
				_wall.addChild(message);
			}
			
			_wall.opaqueBackground = 0xFFFFFF;
		}
		
		private function doubleClickHandler(pEvent:MouseEvent):void
		{
			trace("Main :: doubleClickHandler() - " + pEvent);
			if (!_messageInput)
			{
				addMessageInput(new Point(mouseX, mouseY));
			}
			else
			{
				trace("do not add message input");
			}
		}
		
		private function addMessageInput(pMouseLocation:Point):void
		{
			trace(_wall.globalToLocal(new Point(pMouseLocation.x, pMouseLocation.y)));
			trace(new Point(_wall.x, _wall.y));
			
			_wall.mouseChildren = true;
			
			_messageInput = new MessageInput();
			_messageInput.scaleX = 0;
			_messageInput.scaleY = 0;
			_messageInput.x = _wall.globalToLocal(new Point(pMouseLocation.x, pMouseLocation.y)).x;
			_messageInput.y = _wall.globalToLocal(new Point(pMouseLocation.x, pMouseLocation.y)).y;
			//_messageInput.x = pMouseLocation.x - _wall.x;
			//_messageInput.y = pMouseLocation.y - _wall.y;
			_messageInput.addEventListener(Event.COMPLETE, messageInput_completeHandler, false, 0, true);
			
			_guestbookModel.messageController = _messageInputController;
			_guestbookModel.messageInputView = _messageInput;
			_messageInputController.view = _messageInput;
			_messageInputController.model = _guestbookModel;
			_messageInput.controller = _messageInputController;
			_messageInput.model = _guestbookModel;
			_messageInput.wall = _wall;
			
			_messageInputController.addEventListener(Event.CLOSE, messageInputController_closeHandler, false, 0, true);
			_wall.addChild(_messageInput);
			
			_messageInput.setFocus();
			
			Tweener.addTween(_messageInput, { scaleX2: 1, scaleY2: 1, _bezier: { scaleX2: 1.3, scaleY2: 1.3 }, time: 0.5, transition: "easeInCubic", onComplete:function():void
			{
				_messageInput.checkBounds();
			} } );
			
			showDropdowns();
			
			_messageInputController.updateStyle("Font", "Serif");
			_messageInputController.updateStyle("Size", "Small");
			_messageInputController.updateStyle("Color", 0x5d6246);
		}
		
		private function showDropdowns():void
		{
			_dropdownContainer.visible = true;
			for (var i:int = 0; i < _dropdowns.length; i++)
			{
				_dropdowns[i].alpha = 0;
				Tweener.addTween(_dropdowns[i], { alpha: 1, time: 1, delay: i * 0.1 } );
			}
		}
		
		private function hideDropdowns():void
		{
			var counter:int = 0;
			for (var i:int = _dropdowns.length - 1; i >= 0; i--)
			{
				Tweener.addTween(_dropdowns[i], { alpha: 0, time: 1, delay: ((_dropdowns.length - 1) - i) * 0.1, onComplete: function():void
				{
					counter++;
					if (counter == _dropdowns.length)
					{
						_dropdownContainer.visible = false;
					}
				} } );
			}
		}
		
		private function messageInputController_closeHandler(pEvent:Event):void
		{
			trace("Main :: messageInputController_closeHandler() - " + pEvent);
			Tweener.addTween(_messageInput, { scaleX2: 0, scaleY2: 0, _bezier: { scaleX2: 1.3, scaleY2: 1.3 }, time: 0.5, transition: "easeInCubic", onComplete: function():void
			{
				this.parent.removeChild(this);
				_messageInput = null;
				_wall.mouseChildren = false;
			} } );
			
			hideDropdowns();
		}
		
		private function messageInput_completeHandler(pEvent:Event):void
		{
			trace(pEvent);
			_messageInput = null;
			_wall.mouseChildren = false;
			hideDropdowns();
		}
		
		private function buildDropdowns():void
		{
			_dropdownContainer = new Sprite();
			
			var fontDropdown:FontDropdown = new FontDropdown();
			_dropdownContainer.addChild(fontDropdown);
			
			var fontsizeDropdown:FontSizeDropdown = new FontSizeDropdown();
			fontsizeDropdown.y = fontDropdown.y + fontDropdown.topBoxHeight + 10;
			_dropdownContainer.addChild(fontsizeDropdown);
			
			var colorDropdown:ColorDropdown = new ColorDropdown();
			colorDropdown.y = fontsizeDropdown.y + fontsizeDropdown.topBoxHeight + 10;
			_dropdownContainer.addChild(colorDropdown);
			
			_dropdowns.push(fontDropdown);
			_dropdowns.push(fontsizeDropdown);
			_dropdowns.push(colorDropdown);
			
			for (var i:int = 0; i < _dropdowns.length; i++)
			{
				_dropdowns[i].addEventListener(MouseEvent.MOUSE_UP, dropdowns_mouseUpHandler, false, 0, true);
				_dropdowns[i].controller = _messageInputController;
			}
			
			_dropdownContainer.x = stage.stageWidth - _dropdownContainer.width - 10;
			_dropdownContainer.y = 10;
			_dropdownContainer.visible = false;
			addChild(_dropdownContainer);
		}
		
		private function dropdowns_mouseUpHandler(pEvent:MouseEvent):void
		{
			if (!pEvent.currentTarget.opened)
			{
				_dropdownContainer.setChildIndex(pEvent.target as DisplayObject, _dropdownContainer.numChildren - 1);
				if (_openDropdown)
				{
					_openDropdown.close(true);
				}
				
				pEvent.target.open();
				_openDropdown = pEvent.currentTarget;
			}
			else
			{
				if (getDefinitionByName(getQualifiedClassName(pEvent.target)) != "[class DropdownItem]")
				{
					pEvent.currentTarget.close(false);
				}
				else
				{
					pEvent.currentTarget.close(false, 0.2);
				}
			}
		}
		
		private function mouseDownHandler(pEvent:MouseEvent):void
		{
			if (getDefinitionByName(getQualifiedClassName(pEvent.target)) == "[class Stage]")
			{
				_wall.startDrag();
			}
		}
		
		private function mouseUpHandler(pEvent:MouseEvent):void
		{
			_wall.stopDrag();
		}
		
		private function wall_mouseDownHandler(pEvent:MouseEvent):void
		{
			if (getDefinitionByName(getQualifiedClassName(pEvent.target.parent.parent)) != "[class MessageInput]")
			{
				_wall.startDrag();
			}
		}
		
		private function wall_mouseUpHandler(pEvent:MouseEvent):void
		{
			_wall.stopDrag();
		}
		
		private function zoomOut_mouseUpHandler(pEvent:MouseEvent):void
		{
			Tweener.addTween(_wall, { scaleX: _wall.scaleX - 0.1, scaleY: _wall.scaleY - 0.1, time: 1 } ); 
		}
		
		private function zoomIn_mouseUpHandler(pEvent:MouseEvent):void
		{
			Tweener.addTween(_wall, { scaleX: _wall.scaleX + 0.1, scaleY: _wall.scaleY + 0.1, time: 1, onUpdate: function():void
			{
				trace(_wall.globalToLocal(new Point(stage.stageWidth / 2, stage.stageHeight / 2)));
			} } );
		}
		
	}
	
}