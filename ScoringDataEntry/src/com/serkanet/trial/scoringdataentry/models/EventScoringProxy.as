package com.serkanet.trial.scoringdataentry.models {
	import com.serkanet.trial.scoringdataentry.models.vos.ScoringVo;

	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.PropertyChangeEvent;

	import org.puremvc.as3.patterns.proxy.Proxy;


	public class EventScoringProxy extends Proxy {

		public static const NAME:String = "EventScoring";

		public function EventScoringProxy() {
			super(NAME, new ArrayCollection());
			sortScoringsByOrder();
			scorings.addEventListener(CollectionEvent.COLLECTION_CHANGE, onScoringsCollectionChange);
			initFakeData();
		}


		private function sortScoringsByOrder():void {
			var sort:Sort = new Sort();
			sort.fields = [new SortField("order"), new SortField("id")];
			scorings.sort = sort;
			scorings.refresh()
		}


		public function get scorings():ArrayCollection {
			return data as ArrayCollection;
		}


		private function onScoringsCollectionChange(event:CollectionEvent):void {
			// TODO: This is the wrong place to do these updates because it'll cause a loop
			// Get around the problem for now by filtering by property.
			switch (event.kind) {
				case CollectionEventKind.UPDATE:
					for each (var propertyChangeEvent:PropertyChangeEvent in event.items) {
						if (propertyChangeEvent.newValue != propertyChangeEvent.oldValue) {
							var scoring:ScoringVo = propertyChangeEvent.source as ScoringVo;
							getScoringProxy(scoring.id).onChange(propertyChangeEvent);
						}
					}
					break;
			}
		}


		private function getScoringProxy(id:String):ScoringProxy {
			return facade.retrieveProxy(ScoringProxy.getName(id)) as ScoringProxy;
		}


		private function initFakeData():void {
			addScoring(new ScoringVo("123", 1, "John", 5, 5.5, 3, 4, 5, 50, 0, 0));
			addScoring(new ScoringVo("56", 2, "Jane", 5.5, 5.5, 5, 4, 3, 23, 0, 0));
			addScoring(new ScoringVo("928", 3, "Mark", 6, 5.5, 6, 2, 3, 65, 0, 0));
			addScoring(new ScoringVo("235", 4, "Michelle", 5, 7, 6, 3, 5, 60, 0, 0));
		}


		private function addScoring(vo:ScoringVo):void {
			scorings.addItem(vo);
			facade.registerProxy(new ScoringProxy(vo));
		}


		public function saveScorings():void {
			for each (var scoring:ScoringVo in scorings) {
				saveScoring(scoring);
			}
		}


		public function saveScoring(scoring:ScoringVo):void {
			getScoringProxy(scoring.id).save();
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
				getScoringProxy(scoring.id).computeScore();
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