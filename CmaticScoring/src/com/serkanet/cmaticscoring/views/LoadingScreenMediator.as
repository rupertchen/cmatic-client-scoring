package com.serkanet.cmaticscoring.views {
	import com.serkanet.cmaticscoring.ApplicationFacade;
	import com.serkanet.cmaticscoring.views.components.LoadingScreen;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class LoadingScreenMediator extends Mediator {

		public static const NAME:String = "LoadingScreen";


		public function LoadingScreenMediator(viewComponent:Object=null) {
			super(NAME, viewComponent);
		}


		private function get screen():LoadingScreen {
			return viewComponent as LoadingScreen;
		}


		override public function listNotificationInterests():Array {
			return [
				ApplicationFacade.LOADING_STEP
			];
		}


		override public function handleNotification(notification:INotification):void {
			switch (notification.getName()) {
				case ApplicationFacade.LOADING_STEP:
					screen.setProgress(notification.getBody() as Number);
					break;
			}
		}

	}
}
