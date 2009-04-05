package com.serkanet.trial.scoringdataentry.models {
	import com.serkanet.trial.scoringdataentry.models.vos.ScoringVo;

	import mx.collections.ArrayCollection;
	import mx.collections.ListCollectionView;
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

			var sort:Sort = new Sort();
			sort.fields = [new SortField("order"), new SortField("id")];
			scorings.sort = sort;


			scorings.addEventListener(CollectionEvent.COLLECTION_CHANGE, onScoringsCollectionChange);

			initFakeData();
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
							getScoringProxy(scoring.id).computeFinalScore();
						}
					}
					break;
			}
		}


		private function getScoringProxy(id:String):ScoringProxy {
			return facade.retrieveProxy(ScoringProxy.getName(id)) as ScoringProxy;
		}


		private function initFakeData():void {
			addScoring(new ScoringVo("123", 1, "John", 5, 5.5, 50, 4));
			addScoring(new ScoringVo("56", 2, "Jane", 5.5, 5.5, 23, 4.5));
			addScoring(new ScoringVo("928", 3, "Mark", 6, 5.5, 65, 4.4));
			addScoring(new ScoringVo("235", 4, "Michelle", 5, 7, 60, 4.3));
		}


		public function saveScorings():void {
			for each (var scoring:ScoringVo in scorings) {
				saveScoring(scoring);
			}
		}


		private function addScoring(vo:ScoringVo):void {
			scorings.addItem(vo);
			facade.registerProxy(new ScoringProxy(vo));
		}


		public function saveScoring(scoring:ScoringVo):void {
			getScoringProxy(scoring.id).save();
		}

	}
}