package com.serkanet.trial.scoringdataentry {

	import com.serkanet.trial.scoringdataentry.controllers.ApplicationStartupCommand;

	import org.puremvc.as3.patterns.facade.Facade;


	public class ApplicationFacade extends Facade {

		public static const STARTUP:String = "startup";


		public static function getInstance():ApplicationFacade {
			if (instance == null) {
				instance = new ApplicationFacade();
			}
			return instance as ApplicationFacade;
		}


		override protected function initializeController():void {
			super.initializeController();
			registerCommand(STARTUP, ApplicationStartupCommand);
		}


		public function startup(app:ScoringDataEntryApp):void {
			sendNotification(STARTUP, app);
		}

	}
}