package com.serkanet.trial.ringeventlist {
	import com.serkanet.trial.ringeventlist.controllers.ApplicationStartupCommand;
	import com.serkanet.trial.ringeventlist.controllers.RefreshEventListCommand;

	import org.puremvc.as3.patterns.facade.Facade;


	public class ApplicationFacade extends Facade {

		public static const STARTUP:String = "startup";

		public static const REFRESH_EVENT_LIST:String = "refreshEventList";


		public static function getInstance():ApplicationFacade {
			if (instance == null) {
				instance = new ApplicationFacade();
			}
			return instance as ApplicationFacade;
		}


		override protected function initializeController():void {
			super.initializeController();
			registerCommand(STARTUP, ApplicationStartupCommand);
			registerCommand(REFRESH_EVENT_LIST, RefreshEventListCommand);
		}


		public function startup(app:RingEventListApp):void {
			sendNotification(STARTUP, app);
		}

	}
}