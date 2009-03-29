package com.serkanet.trial.ringeventlist.models {
	import com.serkanet.trial.ringeventlist.models.vo.EventVO;

	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;

	import org.puremvc.as3.patterns.proxy.Proxy;


	public class EventListProxy extends Proxy {

		public static const NAME:String = "EventListProxy";


		public function EventListProxy() {
			super(NAME, new ArrayCollection());

			var sort:Sort = new Sort();
			sort.fields = [new SortField("order"), new SortField("id")];
			events.sort = sort;

			events.addItem(new EventVO("42", 3, "AMT32", "Advanced Male Teen Long Fist", 23));
			events.addItem(new EventVO("316", 2, "BFS52", "Beginner Female Senior Other Taiji Weapon", 3));
			events.addItem(new EventVO("419", 1, "NNN60", "Sparring Group Set", 7));

			events.refresh();
		}


		public function get events():ArrayCollection {
			return data as ArrayCollection;
		}


		public function get numEvents():int {
			return events.length;
		}

	}
}