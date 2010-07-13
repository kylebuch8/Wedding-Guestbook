package controllers 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import models.GuestbookModel;
	import views.message.MessageInput;
	/**
	 * ...
	 * @author Kyle Buchanan
	 */
	public class MessageInputController extends EventDispatcher
	{
		private var _view:MessageInput;
		private var _model:GuestbookModel;
		
		public function MessageInputController() 
		{
			
		}
		
		public function updateStyle(pDropdown:String, pValue:*):void
		{
			_view.updateStyle(pDropdown, pValue);
		}
		
		public function closeInput():void
		{
			trace("MessageInputController :: closeInput()");
			dispatchEvent(new Event(Event.CLOSE));
		}
		
		public function saveMessage(pMessage:String, pXPos:Number, pYPos:Number, pWidth:Number, pHeight:Number, pRotation:Number, pFont:String, pSize:Number, pColor:uint):void
		{
			_model.saveMessage(pMessage, pXPos, pYPos, pWidth, pHeight, pRotation, pFont, pSize, pColor);
		}
		
		// Getter and Setter Methods
		public function set view(pView:MessageInput):void { _view = pView; }
		public function get view():MessageInput { return _view; }
		public function set model(pModel:GuestbookModel):void { _model = pModel; }
		public function get model():GuestbookModel { return _model; }
		
	}

}