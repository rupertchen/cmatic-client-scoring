package com.serkanet.cmaticscoring.models {
	import com.adobe.serialization.json.JSON;
	import com.serkanet.cmaticscoring.models.delegates.SaveCmaticDataDelegate;
	import com.serkanet.cmaticscoring.models.responders.EventScoringsProxySaveResponder;
	import com.serkanet.cmaticscoring.models.vos.CompetitorVo;
	import com.serkanet.cmaticscoring.models.vos.ScoringVo;

	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.PropertyChangeEvent;
	import mx.rpc.Fault;
	import mx.rpc.events.FaultEvent;

	import org.puremvc.as3.utilities.flex.config.model.ConfigProxy;


	public class EventScoringsProxy extends CmaticDataProxyBase {

		public static const LOAD_SUCCESS:String = NAME + "/load/success";
		public static const LOAD_FAILURE:String = NAME + "/load/failure";
		public static const SAVE_SUCCESS:String = NAME + "/save/success";
		public static const SAVE_FAILURE:String = NAME + "/save/failure";

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
							var updated_scoring:ScoringVo = propertyChangeEvent.source as ScoringVo;
							getScoringProxy(updated_scoring).onChange(propertyChangeEvent);
						}
					}
					break;
				case CollectionEventKind.MOVE:
					// ADOBE BUG:
					// When the a property change causes the data grid to reorder itself, a "move" event is received before the
					// "update". When the "update" event is received, the old and new values are both null, appearing as if there
					// was no change.
					for each (var moved_scoring:ScoringVo in event.items) {
						moved_scoring.needsSaving = true;
					}
					break;
			}
		}


		private function getScoringProxy(scoring:ScoringVo):ScoringProxy {
			// TODO It doesn't seem like ScoringProxy is necessary.
			// All of its functionality could be extracted to a set of helper utilities
			// and then we wouldn't have to worry about managing the cached Proxy
			// or possibly having an out of date reference to a VO.
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
			vo.competitorId = record.competitorId;
			vo.groupId = record.groupId;
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
			if (scoringVo.competitorId) {
				var competitorsProxy:CompetitorsProxy = facade.retrieveProxy(CompetitorsProxy.NAME) as CompetitorsProxy;
				var competitorVo:CompetitorVo = competitorsProxy.getVoFromId(scoringVo.competitorId) as CompetitorVo;
				scoringVo.name = competitorVo.firstName + " " + competitorVo.lastName;
			} else if (scoringVo.groupId) {
				var groupsProxy:GroupsProxy = facade.retrieveProxy(GroupsProxy.NAME) as GroupsProxy;
				scoringVo.name = groupsProxy.getFieldFromId(scoringVo.groupId, "name");
			}
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


		public function save():void {
			trace("save scorings");

			// Create save objects
			var records:Array = new Array();
			for each (var scoring:ScoringVo in scorings) {
				records.push(makeSaveEntry(scoring));
			}

			// Save
			var configProxy:AppConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as AppConfigProxy;
			var delegate:SaveCmaticDataDelegate = new SaveCmaticDataDelegate(configProxy.appConfig.setService, TYPE, records);
			delegate.save(new EventScoringsProxySaveResponder(this));
		}


		public function resultSave(resultData:Object):void {
			var result:Object = JSON.decode(resultData.result);
			if (result.success) {
				// It's debatable whether it is better to force a reload so problems are noticed sooner or if it is better
				// to not reload so any temporary corruption does not also corrupt the client's local copy.
				reload();
			} else {
				var faultMessage:Fault = new Fault(SAVE_FAILURE, "Save Failed");
				fault(new FaultEvent(FaultEvent.FAULT, false, false, faultMessage));
			}
		}


		public function faultSave(faultData:Object):void {
			trace("fault saving scorings: " + proxyName);
			sendNotification(SAVE_FAILURE);
		}


		private function makeSaveEntry(scoring:ScoringVo):Object {
			var entry:Object = new Object();
			entry.id = scoring.id;
			entry.order = scoring.order;
			entry.score0 = scoring.score1;
			entry.score1 = scoring.score2;
			entry.score2 = scoring.score3;
			entry.score3 = scoring.score4;
			entry.score4 = scoring.score5;
			entry.time = scoring.time;
			entry.timeDeduction = scoring.timeDeduction;
			entry.otherDeduction = scoring.otherDeduction;
			entry.finalScore = scoring.finalScore;
			entry.tieBreaker0 = scoring.tieBreaker1;
			entry.tieBreaker1 = scoring.tieBreaker2;
			entry.tieBreaker2 = scoring.tieBreaker3;
			entry.placement = scoring.placement;
			return entry;
		}


		public function shuffle():void {
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
		}

		public function computePlacements():void {
			var placementSort:Sort = new Sort();
			placementSort.fields = [
				new SortField("finalScore", false, true, null),
				new SortField("tieBreaker1", false, true, null),
				new SortField("tieBreaker2", false, true, null),
				new SortField("tieBreaker3", false, true, null)
			];

			// Create a separate collection to perform this sorting so that the view is unaffected by the placements
			var scoringsByPlacement:ArrayCollection = new ArrayCollection();
			// addAllItems() isn't avaiable yet?
			//scoringsByPlacement.addAllItems(scorings);
			addAllItems(scorings, scoringsByPlacement);
			scoringsByPlacement.sort = placementSort;
			scoringsByPlacement.refresh();

			var previousScoring:ScoringVo = null;
			var numPlaced:Number = 0;

			for each (var scoring:ScoringVo in scoringsByPlacement) {
				if (areScoresTied(scoring, previousScoring)) {
					scoring.placement = previousScoring.placement;
				} else {
					scoring.placement = numPlaced + 1;
				}

				previousScoring = scoring;
				numPlaced++;
			}
		}


		private function addAllItems(source:ArrayCollection, destination:ArrayCollection):void {
			for each (var item:Object in source) {
				destination.addItem(item);
			}
		}


		private function areScoresTied(x:ScoringVo, y:ScoringVo):Boolean {
			if (x == y) {
				return true;
			}
			if (x == null || y == null) {
				return false;
			}

			return x.finalScore == y.finalScore
				&& x.tieBreaker1 == y.tieBreaker1
				&& x.tieBreaker2 == y.tieBreaker2
				&& x.tieBreaker3 == x.tieBreaker3;
		}

	}
}
