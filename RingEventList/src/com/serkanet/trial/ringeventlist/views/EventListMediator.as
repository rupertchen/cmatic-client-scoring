package com.serkanet.trial.ringeventlist.views {
	import com.serkanet.trial.ringeventlist.ApplicationFacade;
	import com.serkanet.trial.ringeventlist.models.EventListProxy;
	import com.serkanet.trial.ringeventlist.views.components.EventList;

	import flash.events.Event;

	import org.puremvc.as3.patterns.mediator.Mediator;

	public class EventListMediator extends Mediator {

		public static const NAME:String = "EventListMediator";

		private var eventListProxy:EventListProxy;


		public function EventListMediator(viewComponent:EventList) {
			super(NAME, viewComponent);

			eventListProxy = facade.retrieveProxy(EventListProxy.NAME) as EventListProxy;
			eventList.events = eventListProxy.events;

			eventList.addEventListener(EventList.REFRESH, onRefresh);
		}


		public function get eventList():EventList {
			return viewComponent as EventList
		}


		private function onRefresh(event:Event):void {
			sendNotification(ApplicationFacade.REFRESH_EVENT_LIST);
		}

	}
}