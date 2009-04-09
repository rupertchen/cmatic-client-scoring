package com.serkanet.cmaticscoring.models {
	import com.serkanet.cmaticscoring.models.vos.ScoringVo;

	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.PropertyChangeEvent;


	public class EventScoringsProxy extends CmaticDataProxyBase {

		public static const LOAD_SUCCESS:String = NAME + "/load/success";
		public static const LOAD_FAILURE:String = NAME + "/load/failure";

		private static const NAME:String = "EventScorings";
		private static const TYPE:String = "scoring"


		public function EventScoringsProxy(uid:String) {
			super(uid, TYPE, LOAD_SUCCESS, LOAD_FAILURE);
			sortScoringsByOrder();
			scorings.addEventListener(CollectionEvent.COLLECTION_CHANGE, onScoringsCollectionChange);
		}


		private function sortScoringsByOrder():void {
			var sort:Sort = new Sort();
			sort.fields = [new SortField("order"), new SortField("id")];
			scorings.sort = sort;
			scorings.refresh();
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

			populateDerivedFields(vo);

			return vo;
		}


		private function populateDerivedFields(scoringVo:ScoringVo):void {
			scoringVo.name = "Retrieve real name";
		}


		override public function reload():void {
			for each (var scoring:ScoringVo in scorings) {
				facade.removeProxy(ScoringProxy.getName(scoring.id));
			}
			super.reload();
		}


		public function isSaveNeeded():Boolean {
			for each (var scoring:ScoringVo in scorings) {
				if (scoring.needsSaving) {
					return true;
				}
			}
			return false;
		}

	}
}
