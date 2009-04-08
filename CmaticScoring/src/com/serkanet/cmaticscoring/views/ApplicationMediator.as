package com.serkanet.cmaticscoring.views {
	import com.serkanet.cmaticscoring.ApplicationFacade;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;


	public class ApplicationMediator extends Mediator {

		public static const NAME:String = "ApplicationMediator";

		public static const ID_SCREEN:Number = 1;
		public static const MAIN_SCREEN:Number = 2;

		public function ApplicationMediator(viewComponent:CmaticScoring) {
			super(NAME, viewComponent);

			// TODO: register mediators for each of the screens in the view stack.
		}


		override public function listNotificationInterests():Array {
			return [
				ApplicationFacade.VIEW_ID_SCREEN,
				ApplicationFacade.VIEW_MAIN_SCREEN
			];
		}


		override public function handleNotification(notification:INotification):void {
			switch (notification.getName()) {
				case ApplicationFacade.VIEW_ID_SCREEN:
					app.viewStack.selectedIndex = ID_SCREEN;
					break;
				case ApplicationFacade.VIEW_MAIN_SCREEN:
					app.viewStack.selectedIndex = MAIN_SCREEN;
					break;
			}
		}


		private function get app():CmaticScoring {
			return viewComponent as CmaticScoring;
		}

	}
}