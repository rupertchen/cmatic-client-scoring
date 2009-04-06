package com.serkanet.trial.scoringdataentry.views {
	import com.serkanet.trial.scoringdataentry.models.EventScoringProxy;
	import com.serkanet.trial.scoringdataentry.views.components.EventScoringPanel;

	import flash.events.Event;

	import org.puremvc.as3.patterns.mediator.Mediator;


	public class EventScoringMediator extends Mediator {

		public static const NAME:String = "EventScoringMediator";

		private var eventScoringProxy:EventScoringProxy;


		public function EventScoringMediator(viewComponent:Object) {
			super(NAME, viewComponent);
		}


		public function get eventScoringPanel():EventScoringPanel {
			return viewComponent as EventScoringPanel;
		}


		override public function onRegister():void {
			eventScoringProxy = facade.retrieveProxy(EventScoringProxy.NAME) as EventScoringProxy;

			// TODO: This is how the fake data is being injected
			eventScoringPanel.scorings = eventScoringProxy.scorings;

			eventScoringPanel.addEventListener(EventScoringPanel.SAVE_SCORINGS, onSaveScorings);
			eventScoringPanel.addEventListener(EventScoringPanel.RANDOMIZE_COMPETITORS, onRandomizeCompetitors);
			eventScoringPanel.addEventListener(EventScoringPanel.COMPUTE_PLACEMENTS, onComputePlacements);
		}


		private function onSaveScorings(event:Event):void {
			eventScoringProxy.saveScorings();
			// TODO: This should wait for the async's real success message
			setStatus("Saved changes");
		}


		private function onRandomizeCompetitors(event:Event):void {
			if (!eventScoringProxy.areScoringsSaved()) {
				setStatus("Save changes before randomizing");
				return;
			}
			setStatus("Randomizing competitors");
			eventScoringProxy.randomizeCompetitors();
			eventScoringProxy.saveScorings();
		}


		private function onComputePlacements(event:Event):void {
			if (!eventScoringProxy.areScoringsSaved()) {
				setStatus("Save changes before computing placement");
				return;
			}
			setStatus("Computing placements");
			eventScoringProxy.computePlacements();
			eventScoringProxy.saveScorings();
		}


		private function setStatus(status:String):void {
			eventScoringPanel.status = status;
		}
	}
}