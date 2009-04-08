package com.serkanet.cmaticscoring.views {
	import com.serkanet.cmaticscoring.ApplicationFacade;
	import com.serkanet.cmaticscoring.views.components.MainScreen;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class MainScreenMediator extends Mediator {

		public static const NAME:String = "MainScreenMediator";


		public function MainScreenMediator(viewComponent:MainScreen) {
			super(NAME, viewComponent);
		}


		override public function listNotificationInterests():Array {
			return [ApplicationFacade.VIEW_MAIN_SCREEN];
		}


		override public function handleNotification(notification:INotification):void {
			switch (notification.getName()) {
				case ApplicationFacade.VIEW_MAIN_SCREEN:
					mainScreen.title = "Currently Scoring for Ring " + ApplicationFacade.getConfigProxy().appConfig.ringNumber;
					break;
			}
		}


		private function get mainScreen():MainScreen {
			return viewComponent as MainScreen;
		}

	}
}
