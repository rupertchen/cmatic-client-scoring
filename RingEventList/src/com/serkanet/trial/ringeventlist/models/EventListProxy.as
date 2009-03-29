package com.serkanet.trial.ringeventlist.models {
	import com.serkanet.trial.ringeventlist.models.vo.EventVO;

	import mx.collections.ArrayCollection;

	import org.puremvc.as3.patterns.proxy.Proxy;


	public class EventListProxy extends Proxy {

		public static const NAME:String = "EventListProxy";


		public function EventListProxy() {
			super(NAME, new ArrayCollection());
			events.addItem(new EventVO("42", "AMT32", "Advanced Male Teen Long Fist", 23));
			events.addItem(new EventVO("316", "BFS52", "Beginner Female Senior Other Taiji Weapon", 3));
			events.addItem(new EventVO("419", "NNN60", "Sparring Group Set", 7));
		}


		public function get events():ArrayCollection {
			return data as ArrayCollection;
		}


		public function get numEvents():int {
			return events.length;
		}
	}
}