package com.serkanet.cmaticscoring.views {
	import com.serkanet.cmaticscoring.views.components.EventScoringsPanel;

	import flash.events.Event;

	import org.puremvc.as3.patterns.mediator.Mediator;

	public class EventScoringsMediator extends Mediator {
		public function EventScoringsMediator(mediatorName:String, viewComponent:EventScoringsPanel) {
			super(mediatorName, viewComponent);

			// TODO
			// Find the matching proxy
			// Set the data provider of the component

			// attach event listeners to the component
			eventScoringsPanel.addEventListener(EventScoringsPanel.CLOSE, onClose);
			eventScoringsPanel.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		}


		private function get eventScoringsPanel(): EventScoringsPanel {
			return viewComponent as EventScoringsPanel;
		}


		private function onClose(event:Event):void {
			// TODO: prevent if there is unsaved data?
			eventScoringsPanel.remove();
		}


		private function onRemoved(event:Event):void {
			trace("do cleanup for mediator/proxy pair");
			facade.removeMediator(uid);
			facade.removeProxy(uid);
		}


		private function get uid():String {
			return getMediatorName();
		}

	}
}
