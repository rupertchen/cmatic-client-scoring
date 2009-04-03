package com.serkanet.trial.scoringdataentry.views {
	import com.serkanet.trial.scoringdataentry.models.EventScoringProxy;
	import com.serkanet.trial.scoringdataentry.models.vos.ScoringVo;
	import com.serkanet.trial.scoringdataentry.views.components.CommitEntry;
	import com.serkanet.trial.scoringdataentry.views.components.EventScoring;

	import flash.events.Event;

	import org.puremvc.as3.patterns.mediator.Mediator;


	public class EventScoringMediator extends Mediator {

		public static const NAME:String = "EventScoringMediator";

		private var eventScoringProxy:EventScoringProxy;


		public function EventScoringMediator(viewComponent:Object) {
			super(NAME, viewComponent);

			eventScoringProxy = facade.retrieveProxy(EventScoringProxy.NAME) as EventScoringProxy;
			eventScoring.scorings = eventScoringProxy.scorings;

			eventScoring.addEventListener(CommitEntry.COMMIT_SCORING, onCommitScoring);
		}


		private function onCommitScoring(event:Event):void {
			var commitScoring:CommitEntry = event.target as CommitEntry;
			var scoring:ScoringVo = commitScoring.data as ScoringVo;
			var proxy:EventScoringProxy = facade.retrieveProxy(EventScoringProxy.NAME) as EventScoringProxy;
			proxy.saveScoring(scoring);
		}


		public function get eventScoring():EventScoring {
			return viewComponent as EventScoring;
		}

	}
}