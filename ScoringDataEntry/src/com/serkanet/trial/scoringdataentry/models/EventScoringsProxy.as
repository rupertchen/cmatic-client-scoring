package com.serkanet.trial.scoringdataentry.models {
	import com.serkanet.trial.scoringdataentry.models.vos.ScoringVo;

	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.PropertyChangeEvent;


	public class EventScoringsProxy extends CmaticDataProxyBase {

		public static const NAME:String = "EventScorings";
		public static const LOAD_SUCCESS:String = NAME + "/load/success";
		public static const LOAD_FAILURE:String = NAME + "/load/failure";

		private static const TYPE:String = "scoring";


		public function EventScoringsProxy() {
			super(NAME, TYPE, LOAD_SUCCESS, LOAD_FAILURE);
			sortScoringsByOrder();
			scorings.addEventListener(CollectionEvent.COLLECTION_CHANGE, onScoringsCollectionChange);
		}


		private function sortScoringsByOrder():void {
			var sort:Sort = new Sort();
			sort.fields = [new SortField("order"), new SortField("id")];
			scorings.sort = sort;
			scorings.refresh()
		}


		override protected function constructVo(record:Object):Object {
			var vo:ScoringVo = new ScoringVo();
			vo.id = record.id;
			vo.order = record.order;
			vo.name = record.competitorId;
			vo.score1 = record.score0;
			vo.score2 = record.score1;
			vo.score3 = record.score2;
			vo.score4 = record.score3;
			vo.score5 = record.score4;
			vo.time = record.time;
			vo.timeDeduction = record.timeDeduction;
			vo.otherDeduction = record.otherDeduction;
			vo.finalScore = record.finalScore;
			vo.tieBreaker1 = record.tieBreaker0;
			vo.tieBreaker2 = record.tieBreaker1;
			vo.tieBreaker3 = record.tieBreaker2;
			vo.placement = record.placement;
			return vo;
		}


		public function get scorings():ArrayCollection {
			return data as ArrayCollection;
		}


		private function onScoringsCollectionChange(event:CollectionEvent):void {
			switch (event.kind) {
				case CollectionEventKind.UPDATE:
					for each (var propertyChangeEvent:PropertyChangeEvent in event.items) {
						if (propertyChangeEvent.newValue != propertyChangeEvent.oldValue) {
							var scoring:ScoringVo = propertyChangeEvent.source as ScoringVo;
							getScoringProxy(scoring).onChange(propertyChangeEvent);
						}
					}
					break;
			}
		}


		private function getScoringProxy(scoring:ScoringVo):ScoringProxy {
			var proxy:ScoringProxy = facade.retrieveProxy(ScoringProxy.getName(scoring.id)) as ScoringProxy;
			if (!proxy) {
				proxy = new ScoringProxy(scoring);
				facade.registerProxy(proxy);
			}
			return proxy;
		}


		public function saveScorings():void {
			for each (var scoring:ScoringVo in scorings) {
				saveScoring(scoring);
			}
		}


		public function saveScoring(scoring:ScoringVo):void {
			getScoringProxy(scoring).save();
		}


		public function randomizeCompetitors():void {
			// This shuffling is not uniformly random, but it's good enough for now
			var max_index:Number = scorings.length - 1 ;
			for (var transpose_index:Number = 0; transpose_index < scorings.length; transpose_index++) {
				var random:Number = Math.round(Math.random() * max_index);
				var scoring1:ScoringVo = scorings[transpose_index] as ScoringVo;
				var scoring2:ScoringVo = scorings[random] as ScoringVo;
				var oldOrder1:Number = scoring1.order;
				var oldOrder2:Number = scoring2.order;
				scoring1.order = oldOrder2;
				scoring2.order = oldOrder1;
			}
			sortScoringsByOrder()
		}


		public function computePlacements():void {
			computeScores();
			sortScoringsByPlacements();
			assignPlacements();
		}


		private function computeScores():void {
			for each (var scoring:ScoringVo in scorings) {
				getScoringProxy(scoring).computeScore();
			}
		}


		private function sortScoringsByPlacements():void {
			var sort:Sort = new Sort();
			sort.fields = [
				new SortField("finalScore", true, true),
				new SortField("tieBreaker1", true, true),
				new SortField("tieBreaker2", true, true),
				new SortField("tieBreaker3", true, true)
			];

			scorings.sort = sort;
			scorings.refresh();
		}


		private function assignPlacements():void {
			var previousScoring:ScoringVo = null;
			var numPeoplePlaced:Number = 0;

			for each (var scoring:ScoringVo in scorings) {
				if (isTie(scoring, previousScoring)) {
					scoring.placement = previousScoring.placement;
				} else {
					scoring.placement = numPeoplePlaced + 1;
				}

				previousScoring = scoring;
				numPeoplePlaced++;
			}
		}


		private function isTie(scoring1:ScoringVo, scoring2:ScoringVo):Boolean {
			if (scoring1 == scoring2) {
				return true;
			}
			if (!scoring1 || !scoring2) {
				return false;
			}

			return scoring1.finalScore == scoring2.finalScore
				&& scoring1.tieBreaker1 == scoring2.tieBreaker1
				&& scoring1.tieBreaker2 == scoring2.tieBreaker2
				&& scoring1.tieBreaker3 == scoring2.tieBreaker3;
		}


		public function areScoringsSaved():Boolean {
			for each (var scoring:ScoringVo in scorings) {
				if (scoring.needsSaving) {
					return false;
				}
			}
			return true;
		}


		private function sendScoringsChangedEvent():void {
			scorings.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.UPDATE));
		}
	}
}