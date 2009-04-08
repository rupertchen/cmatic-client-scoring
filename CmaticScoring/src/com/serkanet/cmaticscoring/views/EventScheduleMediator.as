package com.serkanet.cmaticscoring.views {
	import com.serkanet.cmaticscoring.ApplicationFacade;
	import com.serkanet.cmaticscoring.models.EventsProxy;
	import com.serkanet.cmaticscoring.views.components.EventSchedulePanel;

	import org.puremvc.as3.patterns.mediator.Mediator;

	public class EventScheduleMediator extends Mediator {

		public static const NAME:String = "EventSchedule";


		public function EventScheduleMediator(viewComponent:EventSchedulePanel) {
			super(NAME, viewComponent);

			var eventsProxy:EventsProxy = facade.retrieveProxy(EventsProxy.NAME) as EventsProxy;
			eventsProxy.load("ringId", ApplicationFacade.getConfigProxy().appConfig.ringNumber.toString());
			eventSchedulePanel.events = eventsProxy.events;
		}


		private function get eventSchedulePanel():EventSchedulePanel {
			return viewComponent as EventSchedulePanel;
		}

	}
}
