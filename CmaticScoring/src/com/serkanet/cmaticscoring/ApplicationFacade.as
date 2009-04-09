package com.serkanet.cmaticscoring {
	import com.serkanet.cmaticscoring.controllers.LoadConfigCommand;
	import com.serkanet.cmaticscoring.controllers.OpenEventCommand;
	import com.serkanet.cmaticscoring.controllers.PrefetchDataCommand;
	import com.serkanet.cmaticscoring.controllers.StartupCommand;
	import com.serkanet.cmaticscoring.models.AppConfigProxy;

	import org.puremvc.as3.patterns.facade.Facade;
	import org.puremvc.as3.utilities.flex.config.model.ConfigProxy;

	public class ApplicationFacade extends Facade {

		public static const STARTUP:String = "startup";

		// proxy
		// TODO placeholder

		// command
		public static const LOAD_CONFIG:String = "loadConfig";
		public static const PREFETCH_DATA:String = "prefetchData";
		public static const OPEN_EVENT:String = "openEvent";

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
			registerCommand(LOAD_CONFIG, LoadConfigCommand);
			registerCommand(PREFETCH_DATA, PrefetchDataCommand);
			registerCommand(OPEN_EVENT, OpenEventCommand);
		}


		public function startup(app:CmaticScoring):void {
			sendNotification(STARTUP, app);
		}


		public static function getConfigProxy():AppConfigProxy {
			return getInstance().retrieveProxy(ConfigProxy.NAME) as AppConfigProxy;
		}

	}
}
