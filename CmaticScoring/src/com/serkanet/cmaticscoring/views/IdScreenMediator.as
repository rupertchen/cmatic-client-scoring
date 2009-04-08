package com.serkanet.cmaticscoring.views {
	import com.serkanet.cmaticscoring.ApplicationFacade;
	import com.serkanet.cmaticscoring.views.components.IdScreen;

	import flash.events.Event;

	import org.puremvc.as3.patterns.mediator.Mediator;


	public class IdScreenMediator extends Mediator {

		public static const NAME:String = "IdScreenMediator";


		public function IdScreenMediator(viewComponent:IdScreen) {
			super(mediatorName, viewComponent);

			idScreen.addEventListener(IdScreen.START_SCORING, onStartScoring);
		}


		private function get idScreen():IdScreen {
			return viewComponent as IdScreen;
		}


		private function onStartScoring(event:Event):void {
			if (isNaN(idScreen.selectedRing)) {
				idScreen.statusMessage = "Please select a ring.";
			} else {
				ApplicationFacade.getConfigProxy().appConfig.ringNumber = idScreen.selectedRing;
				sendNotification(ApplicationFacade.LOAD_CONFIG);
			}
		}

	}
}
