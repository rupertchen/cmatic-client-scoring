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
			panel.addEventListener(EventScoringsPanel.SAVE_SCORINGS, onSaveScorings);
			panel.addEventListener(EventScoringsPanel.SHUFFLE_ORDERS, onShuffleOrders);
			panel.addEventListener(EventScoringsPanel.COMPUTE_PLACEMENTS, onComputePlacements);
			panel.addEventListener(EventScoringsPanel.END_EVENT, onEndEvent);
			panel.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
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


		private function onSaveScorings(event:Event):void {
			proxy.save();
		}


		private function onShuffleOrders(event:Event):void {
			proxy.shuffle();
		}


		private function onComputePlacements(event:Event):void {
			proxy.computePlacements();
		}


		private function onEndEvent(event:Event):void {
			proxy.computePlacements();
			//TODO: mark event as finished
		}


		private function onRemovedFromStage(event:Event):void {
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
