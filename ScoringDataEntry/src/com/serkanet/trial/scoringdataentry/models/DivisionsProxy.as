package com.serkanet.trial.scoringdataentry.models {
	import com.adobe.serialization.json.JSON;
	import com.serkanet.trial.scoringdataentry.models.delegates.LoadEventParameterDelegate;
	import com.serkanet.trial.scoringdataentry.models.vos.EventParameterVo;

	import mx.collections.ArrayCollection;
	import mx.rpc.Fault;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

	import org.puremvc.as3.patterns.proxy.Proxy;
	import org.puremvc.as3.utilities.flex.config.model.ConfigProxy;

	public class DivisionsProxy extends Proxy implements IResponder {

		public static const NAME:String = "Divisions";
		public static const LOAD_SUCCESS:String = NAME + "/load/success";
		public static const LOAD_FAILURE:String = NAME + "/load/failure";

		private static const TYPE:String = "division";

		private var delegate:LoadEventParameterDelegate;


		public function DivisionsProxy() {
			super(NAME, new ArrayCollection());
		}


		public function get divisions():ArrayCollection {
			return data as ArrayCollection;
		}


		public function load():void {
			var configProxy:AppConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as AppConfigProxy;
			var delegate:LoadEventParameterDelegate = new LoadEventParameterDelegate(configProxy.appConfig.getService, TYPE);
			delegate.retrieve(this);
		}


		public function result(data:Object):void {
			var resultEvent:ResultEvent = data as ResultEvent;
			var rawJson:String = resultEvent.result as String;
			var obj:Object = JSON.decode(rawJson);

			var records:Array = obj.records;
			for each (var record:Object in records) {
				var vo:EventParameterVo = new EventParameterVo();
				vo.id = record.id;
				vo.longName = record.longName;
				vo.shortName = record.shortName;
				divisions.addItem(vo);
			}
			if (isValid()) {
				sendNotification(LOAD_SUCCESS);
			} else {
				var faultMessage:Fault = new Fault(LOAD_FAILURE, "Malformed Response", "Check that the response is not empty");
				fault(new FaultEvent(FaultEvent.FAULT, false, false, faultMessage));
			}
		}


		private function isValid():Boolean {
			return divisions.length > 0;
		}


		public function fault(data:Object):void {
			trace("divisions fault");
			sendNotification(LOAD_FAILURE, data);
		}

	}
}
