package com.serkanet.cmaticscoring.models.delegates {
	import com.adobe.serialization.json.JSON;

	import mx.rpc.IResponder;
	import mx.rpc.http.HTTPService;


	public class SaveCmaticDataDelegate {

		private var service:HTTPService
		private var parameters:Object;


		public function SaveCmaticDataDelegate(url:String, type:String, records:Array) {
			service = new HTTPService();
			service.url = url;
			service.resultFormat = "text";

			parameters = new Object();
			parameters.type = type;
			// Gimping this delegate to only do updates. No creating or deleting
			parameters.op = "edit";
			parameters.records = JSON.encode(records);

			trace("Created save delegate."
				+ "\n\turl: " + url
				+ "\n\ttype: " + parameters.type
				+ "\n\top: " + parameters.op
				+ "\n\trecords: " + parameters.records);
		}


		public function save(responder:IResponder):void {
			trace("Save delegate sending");
			service.send(parameters).addResponder(responder);
		}

	}
}
