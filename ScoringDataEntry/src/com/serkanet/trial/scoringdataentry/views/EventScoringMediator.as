package com.serkanet.trial.scoringdataentry.views {
	import com.serkanet.trial.scoringdataentry.models.EventScoringProxy;
	import com.serkanet.trial.scoringdataentry.models.vos.ScoringVo;
	import com.serkanet.trial.scoringdataentry.views.components.CommitEntry;
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

			eventScoringPanel.addEventListener(CommitEntry.COMMIT_SCORING, onCommitScoring);
			eventScoringPanel.addEventListener(EventScoringPanel.SAVE_SCORINGS, onSaveScorings);
			eventScoringPanel.addEventListener(EventScoringPanel.RANDOMIZE_COMPETITORS, onRandomizeCompetitors);
		}


		private function onCommitScoring(event:Event):void {
			// TODO: Is there any reason to provide an individual save?
			var commitScoring:CommitEntry = event.target as CommitEntry;
			var scoring:ScoringVo = commitScoring.data as ScoringVo;
			eventScoringProxy.saveScoring(scoring);
		}


		private function onSaveScorings(event:Event):void {
			eventScoringProxy.saveScorings();
		}


		private function onRandomizeCompetitors(event:Event):void {
			eventScoringProxy.randomizeCompetitors();
		}

	}
}