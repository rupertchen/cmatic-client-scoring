package com.serkanet.cmaticscoring.models {
	import com.serkanet.cmaticscoring.models.vos.EventVo;

	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;


	public class EventsProxy extends CmaticDataProxyBase {

		public static const NAME:String = "Events";
		public static const LOAD_SUCCESS:String = NAME + "/load/success";
		public static const LOAD_FAILURE:String = NAME + "/load/failure";

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

			var division:String = divisionsProxy ? divisionsProxy.getFieldFromid(eventVo.divisionId, "longName") : null;
			var sex:String = sexesProxy ? sexesProxy.getFieldFromid(eventVo.sexId, "longName") : null;
			var ageGroup:String = ageGroupsProxy ? ageGroupsProxy.getFieldFromid(eventVo.ageGroupId, "longName") : null;
			var form:String = formsProxy ? formsProxy.getFieldFromid(eventVo.formId, "longName") : null;

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

	}
}
