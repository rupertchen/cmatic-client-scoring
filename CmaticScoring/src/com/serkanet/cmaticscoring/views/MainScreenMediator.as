package com.serkanet.cmaticscoring.views {
	import com.serkanet.cmaticscoring.ApplicationFacade;
	import com.serkanet.cmaticscoring.views.components.MainScreen;

	import flash.display.DisplayObject;

	import org.puremvc.as3.patterns.mediator.Mediator;

	public class MainScreenMediator extends Mediator {

		public static const NAME:String = "MainScreen";


		public function MainScreenMediator(viewComponent:MainScreen) {
			super(NAME, viewComponent);

			screen.title = "Currently Scoring for Ring " + ApplicationFacade.getConfigProxy().appConfig.ringNumber;
			facade.registerMediator(new EventScheduleMediator(screen.eventSchedule));
		}


		private function get screen():MainScreen {
			return viewComponent as MainScreen;
		}


		public function addTab(newTab:DisplayObject):void {
			screen.addTab(newTab);
		}


		public function hasTab(label:String):Boolean {
			return screen.hasTab(label);
		}


		public function bringTabUp(label:String):void {
			screen.bringTabUp(label);
		}

	}
}
