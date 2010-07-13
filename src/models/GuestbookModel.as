package models 
{
	import controllers.MessageInputController;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLVariables;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import views.message.MessageInput;
	/**
	 * ...
	 * @author Kyle Buchanan
	 */
	public class GuestbookModel extends EventDispatcher
	{
		private static const MESSAGES_URL:String = "http://www.thedulos.com/guestbook/messages";
		private static const SAVE_URL:String = "http://www.thedulos.com/guestbook/save";
		
		private var _messageController:MessageInputController;
		private var _messageInputView:MessageInput;
		private var _messagesXML:XML;
		
		public function GuestbookModel() 
		{
			
		}
		
		public function getMessages():void
		{
			var urlRequest:URLRequest = new URLRequest(MESSAGES_URL);
			var urlLoader:URLLoader = new URLLoader();
			
			urlLoader.addEventListener(Event.COMPLETE, getMessages_completeHandler, false, 0, true);
			urlLoader.load(urlRequest);
		}
		
		private function getMessages_completeHandler(pEvent:Event):void
		{
			_messagesXML = new XML(pEvent.target.data);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function saveMessage(pMessage:String, pXPos:Number, pYPos:Number, pWidth:Number, pHeight:Number, pRotation:Number, pFont:String, pSize:Number, pColor:uint):void
		{
			var urlRequest:URLRequest = new URLRequest(SAVE_URL);
			var urlLoader:URLLoader = new URLLoader();
			
			var variables:URLVariables = new URLVariables();
			variables.text = pMessage;
			variables.xPos = pXPos;
			variables.yPos = pYPos;
			variables.width = pWidth;
			variables.height = pHeight;
			variables.rotation = pRotation;
			variables.font = pFont;
			variables.size = pSize;
			variables.color = pColor;
			
			urlRequest.data = variables;
			urlRequest.method = URLRequestMethod.POST;
			
			urlLoader.addEventListener(Event.COMPLETE, saveMessage_completeHandler, false, 0, true);
			urlLoader.load(urlRequest);
		}
		
		private function saveMessage_completeHandler(pEvent:Event):void
		{
			trace("message has been saved");
			_messageInputView.removeControls();
		}
		
		// Getter and Setter Methods
		public function get messageController():MessageInputController { return _messageController; }
		public function set messageController(pController:MessageInputController):void { _messageController = pController; }
		public function get messageInputView():MessageInput { return _messageInputView; }
		public function set messageInputView(pView:MessageInput):void { _messageInputView = pView; }
		public function get messagesXML():XML { return _messagesXML; }
		
	}

}