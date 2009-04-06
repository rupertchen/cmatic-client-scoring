package com.serkanet.trial.scoringdataentry {

	import com.serkanet.trial.scoringdataentry.controllers.AppStartupCommand;
	import com.serkanet.trial.scoringdataentry.controllers.FailedConfigCommand;
	import com.serkanet.trial.scoringdataentry.controllers.PostConfigStartupCommand;

	import org.puremvc.as3.patterns.facade.Facade;
	import org.puremvc.as3.utilities.flex.config.model.ConfigProxy;


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
			registerCommand(STARTUP, AppStartupCommand);
			registerCommand(ConfigProxy.SUCCESS, PostConfigStartupCommand);
			registerCommand(ConfigProxy.FAILURE, FailedConfigCommand);
		}


		public function startup(app:ScoringDataEntryApp):void {
			sendNotification(STARTUP, app);
		}

	}
}
