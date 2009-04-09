package com.serkanet.cmaticscoring.views {
	import com.serkanet.cmaticscoring.models.EventScoringsProxy;
	import com.serkanet.cmaticscoring.views.components.EventScoringsPanel;

	import flash.events.Event;

	import mx.controls.Alert;

	import org.puremvc.as3.patterns.mediator.Mediator;

	public class EventScoringsMediator extends Mediator {

		public function EventScoringsMediator(mediatorName:String, viewComponent:EventScoringsPanel) {
			super(mediatorName, viewComponent);

			// Set the data provider of the component
			panel.scorings = proxy.scorings;

			// attach event listeners to the component
			panel.addEventListener(EventScoringsPanel.CLOSE, onClose);
			panel.addEventListener(EventScoringsPanel.RELOAD_SCORINGS, onReloadScorings);
			panel.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		}


		private function get panel(): EventScoringsPanel {
			return viewComponent as EventScoringsPanel;
		}


		private function onClose(event:Event):void {
			if (proxy.isSaveNeeded()) {
				Alert.show("The event has unsaved changes. Please save or cancel the changes before closing", "Warning");
				return;
			}
			panel.remove();
		}


		private function onReloadScorings(event:Event):void {
			proxy.reload();
		}


		private function onRemoved(event:Event):void {
			facade.removeMediator(uid);
			facade.removeProxy(uid);
		}


		private function get uid():String {
			return mediatorName;
		}


		private function get proxy():EventScoringsProxy {
			return facade.retrieveProxy(uid) as EventScoringsProxy;
		}

	}
}
