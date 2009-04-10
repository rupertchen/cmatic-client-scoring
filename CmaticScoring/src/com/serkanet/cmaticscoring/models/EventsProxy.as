package com.serkanet.cmaticscoring.models {
	import com.adobe.serialization.json.JSON;
	import com.serkanet.cmaticscoring.models.delegates.SaveCmaticDataDelegate;
	import com.serkanet.cmaticscoring.models.responders.EventsProxySaveResponder;
	import com.serkanet.cmaticscoring.models.vos.EventVo;

	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.rpc.Fault;
	import mx.rpc.events.FaultEvent;

	import org.puremvc.as3.utilities.flex.config.model.ConfigProxy;


	public class EventsProxy extends CmaticDataProxyBase {

		public static const NAME:String = "Events";
		public static const LOAD_SUCCESS:String = NAME + "/load/success";
		public static const LOAD_FAILURE:String = NAME + "/load/failure";
		public static const SAVE_SUCCESS:String = NAME + "/save/success";
		public static const SAVE_FAILURE:String = NAME + "/save/failure";

		private static const TYPE:String = "event";


		public function EventsProxy() {
			trace("create events proxy");
			super(NAME, TYPE, LOAD_SUCCESS, LOAD_FAILURE);
			sortEventsByOrder();
		}


		private function sortEventsByOrder():void {
			var sort:Sort = new Sort();
			sort.fields = [
				new SortField("order"),
				new SortField("id")
			];

			events.sort = sort;
			events.refresh();
		}


		override protected function constructVo(record:Object):Object {
			var vo:EventVo = new EventVo();
			vo.id = record.id;
			vo.divisionId = record.divisionId;
			vo.sexId = record.sexId;
			vo.ageGroupId = record.ageGroupId;
			vo.formId = record.formId;
			vo.code = record.code;
			vo.ringId = record.ringId;
			vo.order = record.order;
			vo.numCompetitors = record.numCompetitors;
			vo.isFinished = record.isFinished;

			populateDerivedFields(vo);

			return vo;
		}


		private function populateDerivedFields(eventVo:EventVo):void {
			var divisionsProxy:DivisionsProxy = facade.retrieveProxy(DivisionsProxy.NAME) as DivisionsProxy;
			var sexesProxy:SexesProxy = facade.retrieveProxy(SexesProxy.NAME) as SexesProxy;
			var ageGroupsProxy:AgeGroupsProxy = facade.retrieveProxy(AgeGroupsProxy.NAME) as AgeGroupsProxy;
			var formsProxy:FormsProxy = facade.retrieveProxy(FormsProxy.NAME) as FormsProxy;

			var division:String = divisionsProxy ? divisionsProxy.getFieldFromId(eventVo.divisionId, "longName") : null;
			var sex:String = sexesProxy ? sexesProxy.getFieldFromId(eventVo.sexId, "longName") : null;
			var ageGroup:String = ageGroupsProxy ? ageGroupsProxy.getFieldFromId(eventVo.ageGroupId, "longName") : null;
			var form:String = formsProxy ? formsProxy.getFieldFromId(eventVo.formId, "longName") : null;

			var eventName:String = division + " " + sex + " " + ageGroup + " " + form;

			// Remove N/A
			eventName = eventName.replace(/n\/a/gi, " ");
			// Compress whitespace
			eventName = eventName.replace(/\s+/g, " ");
			// Trim whitespace
			eventName = eventName.replace(/^\s+/, "").replace(/\s+$/, "");
			eventVo.name = eventName;
		}


		public function get events():ArrayCollection {
			return data as ArrayCollection;
		}


		public function saveEvent(event:EventVo):void {
			// Limiting saves to the isFinished property
			var saveEntry:Object = new Object();
			saveEntry.id = event.id;
			saveEntry.isFinished = event.isFinished;

			var configProxy:AppConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as AppConfigProxy;
			var delegate:SaveCmaticDataDelegate = new SaveCmaticDataDelegate(configProxy.appConfig.setService, TYPE, [saveEntry]);
			delegate.save(new EventsProxySaveResponder(this));
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
			trace("fault saving event: " + proxyName);
			sendNotification(SAVE_FAILURE);
		}

	}
}
