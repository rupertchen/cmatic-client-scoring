package com.serkanet.cmaticscoring.views {
	import com.serkanet.cmaticscoring.ApplicationFacade;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import org.puremvc.as3.utilities.flex.config.model.ConfigProxy;


	public class ApplicationMediator extends Mediator {

		public static const NAME:String = "ApplicationMediator";

		public static const ID_SCREEN:Number = 1;
		public static const MAIN_SCREEN:Number = 2;
		public static const ERROR_SCREEN:Number = 3;

		public function ApplicationMediator(viewComponent:CmaticScoring) {
			super(NAME, viewComponent);

			facade.registerMediator(new IdScreenMediator(app.idScreen));
			facade.registerMediator(new MainScreenMediator(app.mainScreen));
		}


		override public function listNotificationInterests():Array {
			return [
				ConfigProxy.SUCCESS,
				ConfigProxy.FAILURE,
				ApplicationFacade.VIEW_ID_SCREEN,
				ApplicationFacade.VIEW_MAIN_SCREEN
			];
		}


		override public function handleNotification(notification:INotification):void {
			switch (notification.getName()) {
				case ConfigProxy.SUCCESS:
					sendNotification(ApplicationFacade.VIEW_MAIN_SCREEN);
					break;
				case ConfigProxy.FAILURE:
					app.viewStack.selectedIndex = ERROR_SCREEN;
					break;
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