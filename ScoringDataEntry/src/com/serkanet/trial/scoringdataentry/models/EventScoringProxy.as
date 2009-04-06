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
			// I don't think this shuffling is uniformly random, but it's good enough for now
			var max_index:Number = scorings.length - 1 ;
			for (var transpose_index:Number = 0; transpose_index < scorings.length; transpose_index++) {
				var random:Number = Math.round(Math.random() * max_index);
				var scoring1:ScoringVo = scorings[transpose_index] as ScoringVo;
				var scoring2:ScoringVo = scorings[random] as ScoringVo;
				var oldOrder1:Number = scoring1.order;
				var oldOrder2:Number = scoring2.order;
				scoring1.order = oldOrder2;
				scoring2.order = oldOrder1;

				// TODO: Figure out why calling itemUpdate() like this does not cause the panel to update its view
				// Tutorials claim you should use this, but it does not cause the COLLECTION_CHANGE event to fire which
				// appears to be what the DataGrid is listening for. As a work around fire off the COLLECTION_CHANGE
				// explicitly
//				scorings.itemUpdated(scoring1);
//				scorings.itemUpdated(scoring2);
			}
			sendScoringsChangedEvent();
		}


		private function sendScoringsChangedEvent():void {
			scorings.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.UPDATE));
		}
	}
}