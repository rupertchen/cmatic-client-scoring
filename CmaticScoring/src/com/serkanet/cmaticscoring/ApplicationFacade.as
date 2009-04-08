package com.serkanet.cmaticscoring {
	import com.serkanet.cmaticscoring.controllers.StartupCommand;

	import org.puremvc.as3.patterns.facade.Facade;

	public class ApplicationFacade extends Facade {

		public static const STARTUP:String = "startup";

		// proxy
		// TODO placeholder

		// command
		// TODO placeholder

		// view
		public static const VIEW_ID_SCREEN:String = "viewIdScreen";
		public static const VIEW_MAIN_SCREEN:String = "viewMainScreen";


		public static function getInstance():ApplicationFacade {
			if (instance == null) {
				instance = new ApplicationFacade();
			}
			return instance as ApplicationFacade;
		}


		override protected function initializeController():void {
			super.initializeController();
			registerCommand(STARTUP, StartupCommand);
		}


		public function startup(app:CmaticScoring):void {
			sendNotification(STARTUP, app);
		}

	}
}
