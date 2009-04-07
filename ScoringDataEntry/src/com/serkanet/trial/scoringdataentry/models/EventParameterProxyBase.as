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

	public class EventParameterProxyBase extends Proxy implements IResponder{

		protected var type:String;
		protected var successNotificationName:String;
		protected var failureNotificationName:String;


		public function EventParameterProxyBase(proxyName:String, proxyType:String, successNotification:String, failureNotification:String) {
			super(proxyName, new ArrayCollection());
			type = proxyType;
			this.successNotificationName = successNotification;
			this.failureNotificationName = failureNotification;
		}


		public function load():void {
			var configProxy:AppConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as AppConfigProxy;
			var delegate:LoadEventParameterDelegate = new LoadEventParameterDelegate(configProxy.appConfig.getService, type);
			delegate.retrieve(this);
		}


		public function get parameters():ArrayCollection {
			return data as ArrayCollection;
		}


		public function result(data:Object):void {
			var resultEvent:ResultEvent = data as ResultEvent;
			var rawJson:String = resultEvent.result as String;
			var decodedObject:Object = JSON.decode(rawJson);

			var records:Array = decodedObject.records;
			for each (var record:Object in records) {
				var vo:EventParameterVo = new EventParameterVo();
				vo.id = record.id;
				vo.longName = record.longName;
				vo.shortName = record.shortName;
				parameters.addItem(vo);
			}

			if (isValid()) {
				sendNotification(successNotificationName);
			} else {
				var faultMessage:Fault = new Fault(failureNotificationName, "Malformed Response", "Check that the response is not empty");
				fault(new FaultEvent(FaultEvent.FAULT, false, false, faultMessage));
			}
		}


		private function isValid():Boolean {
			return parameters.length > 0;
		}


		public function fault(data:Object):void {
			trace("fault retrieving event parameter: " + proxyName);
			sendNotification(failureNotificationName);
		}
	}
}