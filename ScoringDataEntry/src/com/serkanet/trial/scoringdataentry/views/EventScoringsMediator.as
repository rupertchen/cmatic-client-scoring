package com.serkanet.trial.scoringdataentry.views {
	import com.serkanet.trial.scoringdataentry.models.EventScoringsProxy;
	import com.serkanet.trial.scoringdataentry.views.components.EventScoringsPanel;

	import flash.events.Event;

	import org.puremvc.as3.patterns.mediator.Mediator;


	public class EventScoringsMediator extends Mediator {

		public static const NAME:String = "EventScoringMediator";

		private var eventScoringsProxy:EventScoringsProxy;


		public function EventScoringsMediator(viewComponent:Object) {
			super(NAME, viewComponent);
		}


		public function get eventScoringsPanel():EventScoringsPanel {
			return viewComponent as EventScoringsPanel;
		}


		override public function onRegister():void {
			eventScoringsProxy = facade.retrieveProxy(EventScoringsProxy.NAME) as EventScoringsProxy;

			// TODO: This is how the fake data is being injected
			eventScoringsPanel.scorings = eventScoringsProxy.scorings;

			eventScoringsPanel.addEventListener(EventScoringsPanel.SAVE_SCORINGS, onSaveScorings);
			eventScoringsPanel.addEventListener(EventScoringsPanel.RANDOMIZE_COMPETITORS, onRandomizeCompetitors);
			eventScoringsPanel.addEventListener(EventScoringsPanel.COMPUTE_PLACEMENTS, onComputePlacements);
		}


		private function onSaveScorings(event:Event):void {
			eventScoringsProxy.saveScorings();
			// TODO: This should wait for the async's real success message
			setStatus("Saved changes");
		}


		private function onRandomizeCompetitors(event:Event):void {
			if (!eventScoringsProxy.areScoringsSaved()) {
				setStatus("Save changes before randomizing");
				return;
			}
			setStatus("Randomizing competitors");
			eventScoringsProxy.randomizeCompetitors();
			eventScoringsProxy.saveScorings();
		}


		private function onComputePlacements(event:Event):void {
			if (!eventScoringsProxy.areScoringsSaved()) {
				setStatus("Save changes before computing placement");
				return;
			}
			setStatus("Computing placements");
			eventScoringsProxy.computePlacements();
			eventScoringsProxy.saveScorings();
		}


		private function setStatus(status:String):void {
			eventScoringsPanel.status = status;
		}
	}
}