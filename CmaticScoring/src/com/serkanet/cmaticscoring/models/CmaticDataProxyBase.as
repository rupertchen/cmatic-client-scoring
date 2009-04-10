package com.serkanet.cmaticscoring.models {
	import com.adobe.serialization.json.JSON;
	import com.serkanet.cmaticscoring.models.delegates.LoadCmaticDataDelegate;

	import mx.collections.ArrayCollection;
	import mx.rpc.Fault;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;

	import org.puremvc.as3.patterns.proxy.Proxy;
	import org.puremvc.as3.utilities.flex.config.model.ConfigProxy;


	public class CmaticDataProxyBase extends Proxy implements IResponder{

		protected var type:String;
		protected var successNotificationName:String;
		protected var failureNotificationName:String;
		protected var previousFilterField:String;
		protected var previousFilterValue:String;

		public function CmaticDataProxyBase(proxyName:String, proxyType:String, successNotification:String, failureNotification:String) {
			super(proxyName, new ArrayCollection());
			type = proxyType;
			this.successNotificationName = successNotification;
			this.failureNotificationName = failureNotification;
		}


		public function load(filterField:String = null, filterValue:String = null):void {
			previousFilterField = filterField;
			previousFilterValue = filterValue;
			var configProxy:AppConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as AppConfigProxy;
			var delegate:LoadCmaticDataDelegate = new LoadCmaticDataDelegate(configProxy.appConfig.getService, type, filterField, filterValue);
			delegate.retrieve(this);
		}


		public function reload():void {
			load(previousFilterField, previousFilterValue);
		}


		public function result(resultData:Object):void {
			var decodedObject:Object = JSON.decode(resultData.result);
			var vos:Array = constructVos(decodedObject.records);

			if (isValid(vos)) {
				replaceCurrentData(vos);
				sendNotification(successNotificationName);
			} else {
				var faultMessage:Fault = new Fault(failureNotificationName, "Malformed Response", "Check that the response is not empty");
				fault(new FaultEvent(FaultEvent.FAULT, false, false, faultMessage));
			}
		}


		private function constructVos(records:Array):Array {
			var vos:Array = new Array();
			for each (var record:Object in records) {
				var vo:Object = constructVo(record);
				if (vo) {
					vos.push(vo);
				}
			}
			return vos;
		}


		/**
		 * Override this method
		 */
		protected function constructVo(record:Object):Object {
			return null;
		}


		private function isValid(data:Array):Boolean {
			return data.length > 0;
		}


		private function replaceCurrentData(vos:Array):void {
			// ADOBE BUG:
			// ArrayCollection.removeAll() will only remove things that are shown through the filter. The work around
			// is to remove the filter and refresh before the call and restore the filter and refresh after the call.
			// Throughout this process, the sort remains untouched.
			var savedFilterFunction:Function = ArrayCollection(data).filterFunction;
			ArrayCollection(data).filterFunction = null;
			ArrayCollection(data).refresh();
			ArrayCollection(data).removeAll();
			for each (var vo:Object in vos) {
				ArrayCollection(data).addItem(vo);
			}
			ArrayCollection(data).filterFunction = savedFilterFunction;
			ArrayCollection(data).refresh();
		}


		public function fault(data:Object):void {
			trace("fault retrieving event parameter: " + proxyName);
			sendNotification(failureNotificationName);
		}


		public function getVoFromId(id:String):Object {
			// TODO: Linear search can be slow, consider making this a map.
			var vos:ArrayCollection = data as ArrayCollection;
			for each (var vo:Object in vos) {
				if (vo.id == id) {
					return vo;
				}
			}
			return null;
		}


		public function getFieldFromId(id:String, field:String):String {
			var vo:Object = getVoFromId(id);
			if (vo) {
				return vo[field];
			}
			return null;
		}
	}
}
