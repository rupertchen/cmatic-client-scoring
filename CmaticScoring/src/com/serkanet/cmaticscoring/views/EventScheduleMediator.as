package com.serkanet.cmaticscoring.views {
	import com.serkanet.cmaticscoring.ApplicationFacade;
	import com.serkanet.cmaticscoring.models.EventsProxy;
	import com.serkanet.cmaticscoring.models.vos.EventVo;
	import com.serkanet.cmaticscoring.views.components.EventSchedulePanel;

	import flash.events.Event;

	import org.puremvc.as3.patterns.mediator.Mediator;

	public class EventScheduleMediator extends Mediator {

		public static const NAME:String = "EventSchedule";


		public function EventScheduleMediator(viewComponent:EventSchedulePanel) {
			super(NAME, viewComponent);

			proxy.load("ringId", ApplicationFacade.getConfigProxy().appConfig.ringNumber.toString());
			proxy.hideFinishedEvents();
			panel.events = proxy.events;

			panel.addEventListener(EventSchedulePanel.REFRESH_SCHEDULE, onRefreshSchedule);
			panel.addEventListener(EventSchedulePanel.SELECT_EVENT, onSelectEvent);
			panel.addEventListener(EventSchedulePanel.TOGGLE_SHOW_FINISHED, onToggleShowFinished);
		}


		private function filterFinishedEvents(item:Object):Boolean {
			var event:EventVo = item as EventVo;
			return !event.isFinished;
		}


		private function get panel():EventSchedulePanel {
			return viewComponent as EventSchedulePanel;
		}


		private function onRefreshSchedule(event:Event):void {
			proxy.reload();
		}


		private function onSelectEvent(event:Event):void {
			sendNotification(ApplicationFacade.OPEN_EVENT, panel.selectedEvent);
		}


		private function onToggleShowFinished(event:Event):void {
			trace("toggle show finished status: " + panel.isShowFinishedSelected());
			if (panel.isShowFinishedSelected()) {
				proxy.showFinishedEvents();
			} else {
				proxy.hideFinishedEvents();
			}
		}


		private function get proxy():EventsProxy {
			return facade.retrieveProxy(EventsProxy.NAME) as EventsProxy;
		}

	}
}
