package com.serkanet.cmaticscoring.views {
	import com.serkanet.cmaticscoring.ApplicationFacade;
	import com.serkanet.cmaticscoring.models.EventsProxy;
	import com.serkanet.cmaticscoring.views.components.EventSchedulePanel;

	import flash.events.Event;

	import org.puremvc.as3.patterns.mediator.Mediator;

	public class EventScheduleMediator extends Mediator {

		public static const NAME:String = "EventSchedule";


		public function EventScheduleMediator(viewComponent:EventSchedulePanel) {
			super(NAME, viewComponent);

			var eventsProxy:EventsProxy = facade.retrieveProxy(EventsProxy.NAME) as EventsProxy;
			eventsProxy.load("ringId", ApplicationFacade.getConfigProxy().appConfig.ringNumber.toString());
			eventSchedulePanel.events = eventsProxy.events;

			eventSchedulePanel.addEventListener(EventSchedulePanel.REFRESH_SCHEDULE, onRefreshSchedule);
			eventSchedulePanel.addEventListener(EventSchedulePanel.SELECT_EVENT, onSelectEvent);
			eventSchedulePanel.addEventListener(EventSchedulePanel.TOGGLE_SHOW_FINISHED, onToggleShowFinished);
		}


		private function get eventSchedulePanel():EventSchedulePanel {
			return viewComponent as EventSchedulePanel;
		}


		private function onRefreshSchedule(event:Event):void {
			// TODO: code
			trace("refresh schedule");
		}


		private function onSelectEvent(event:Event):void {
			trace("select event");
			sendNotification(ApplicationFacade.OPEN_EVENT, eventSchedulePanel.selectedEvent);
		}


		private function onToggleShowFinished(event:Event):void {
			// TODO: code
			trace("toggle show finished");
		}

	}
}
