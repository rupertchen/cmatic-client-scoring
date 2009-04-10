package com.serkanet.cmaticscoring.views {
	import com.serkanet.cmaticscoring.ApplicationFacade;
	import com.serkanet.cmaticscoring.views.components.IdScreen;

	import flash.events.Event;

	import org.puremvc.as3.patterns.mediator.Mediator;


	public class IdScreenMediator extends Mediator {

		public static const NAME:String = "IdScreen";


		public function IdScreenMediator(viewComponent:IdScreen) {
			super(mediatorName, viewComponent);

			screen.addEventListener(IdScreen.START_SCORING, onStartScoring);
		}


		private function get screen():IdScreen {
			return viewComponent as IdScreen;
		}


		private function onStartScoring(event:Event):void {
			if (isNaN(screen.selectedRing)) {
				screen.statusMessage = "Please select a ring.";
			} else {
				ApplicationFacade.getConfigProxy().appConfig.ringNumber = screen.selectedRing;
				sendNotification(ApplicationFacade.LOAD_CONFIG);
			}
		}

	}
}
