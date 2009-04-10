package com.serkanet.cmaticscoring.models.vos {

	[Bindable]
	public class EventVo {

		// Primary
		public var id:String;
		public var divisionId:String;
		public var sexId:String;
		public var ageGroupId:String;
		public var formId:String;
		public var code:String;
		public var ringId:String;
		public var order:Number;
		public var numCompetitors:Number;
		private var _isFinished:Boolean;

		public function get isFinished():Boolean {
			return _isFinished;
		}
		public function set isFinished(value:Boolean):void {
			_isFinished = value;
			// The point of setting this value is to trigger an update, but what the tabName actually will be is
			// is decided elsewhere.
			tabName = "";
		}

		// Derived
		public var name:String;

		public function get tabName():String {
			if (isFinished) {
				return code + " [Finished]";
			} else {
				return code;
			}
		}

		public function set tabName(value:String):void {
			// This setter exists so others can trigger a refresh.
		}

	}
}
