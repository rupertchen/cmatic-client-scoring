package com.serkanet.cmaticscoring.models {
	import com.serkanet.cmaticscoring.models.vos.GroupVo;

	import mx.collections.ArrayCollection;


	public class GroupsProxy extends CmaticDataProxyBase {

		public static const NAME:String = "Groups";
		public static const LOAD_SUCCESS:String = NAME + "/load/success";
		public static const LOAD_FAILURE:String = NAME + "/load/failure";

		private static const TYPE:String = "group";


		public function GroupsProxy() {
			super(NAME, TYPE, LOAD_SUCCESS, LOAD_FAILURE);
		}


		override protected function constructVo(record:Object):Object {
			var vo:GroupVo = new GroupVo();
			vo.id = record.id;
			vo.name = record.name;
			vo.eventId = record.eventId;
			return vo;
		}


		public function get groups():ArrayCollection {
			return data as ArrayCollection;
		}

	}
}
