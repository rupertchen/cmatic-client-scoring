package com.serkanet.cmaticscoring.views {
	import com.serkanet.cmaticscoring.ApplicationFacade;
	import com.serkanet.cmaticscoring.views.components.MainScreen;

	import flash.display.DisplayObject;

	import org.puremvc.as3.patterns.mediator.Mediator;

	public class MainScreenMediator extends Mediator {

		public static const NAME:String = "MainScreenMediator";


		public function MainScreenMediator(viewComponent:MainScreen) {
			super(NAME, viewComponent);

			mainScreen.title = "Currently Scoring for Ring " + ApplicationFacade.getConfigProxy().appConfig.ringNumber;
			facade.registerMediator(new EventScheduleMediator(mainScreen.eventSchedule));
		}


		private function get mainScreen():MainScreen {
			return viewComponent as MainScreen;
		}


		public function addTab(newTab:DisplayObject):void {
			mainScreen.addTab(newTab);
		}


		public function hasTab(label:String):Boolean {
			return mainScreen.hasTab(label);
		}


		public function bringTabUp(label:String):void {
			mainScreen.bringTabUp(label);
		}

	}
}
