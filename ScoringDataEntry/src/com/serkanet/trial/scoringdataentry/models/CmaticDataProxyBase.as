package com.serkanet.trial.scoringdataentry.models {
	import com.adobe.serialization.json.JSON;
	import com.serkanet.trial.scoringdataentry.models.delegates.LoadEventParameterDelegate;

	import mx.collections.ArrayCollection;
	import mx.rpc.Fault;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;

	import org.puremvc.as3.patterns.proxy.Proxy;
	import org.puremvc.as3.utilities.flex.config.model.ConfigProxy;


	/**
	 * Abstract class
	 */
	public class CmaticDataProxyBase extends Proxy implements IResponder{

		protected var type:String;
		protected var successNotificationName:String;
		protected var failureNotificationName:String;


		public function CmaticDataProxyBase(proxyName:String, proxyType:String, successNotification:String, failureNotification:String) {
			super(proxyName, new ArrayCollection());
			type = proxyType;
			this.successNotificationName = successNotification;
			this.failureNotificationName = failureNotification;
		}


		public function load(filterField:String = null, filterValue:String = null):void {
			var configProxy:AppConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as AppConfigProxy;
			var delegate:LoadEventParameterDelegate = new LoadEventParameterDelegate(configProxy.appConfig.getService, type, filterField, filterValue);
			delegate.retrieve(this);
		}


		public function result(resultData:Object):void {
			var decodedObject:Object = JSON.decode(resultData.result);

			var records:Array = decodedObject.records;
			for each (var record:Object in records) {
				var vo:Object = constructVo(record);
				if (vo) {
					ArrayCollection(this.data).addItem(vo);
				}
			}

			if (isValid()) {
				sendNotification(successNotificationName);
			} else {
				var faultMessage:Fault = new Fault(failureNotificationName, "Malformed Response", "Check that the response is not empty");
				fault(new FaultEvent(FaultEvent.FAULT, false, false, faultMessage));
			}
		}


		/**
		 * Override this method
		 */
		protected function constructVo(record:Object):Object {
			return null;
		}


		private function isValid():Boolean {
			return ArrayCollection(data).length > 0;
		}


		public function fault(data:Object):void {
			trace("fault retrieving event parameter: " + proxyName);
			sendNotification(failureNotificationName);
		}

	}
}