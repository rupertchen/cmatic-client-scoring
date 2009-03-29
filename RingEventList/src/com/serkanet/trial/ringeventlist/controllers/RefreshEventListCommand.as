package com.serkanet.trial.ringeventlist.controllers {
	import com.serkanet.trial.ringeventlist.models.EventListProxy;
	import com.serkanet.trial.ringeventlist.models.vo.EventVO;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;


	public class RefreshEventListCommand extends SimpleCommand {

		override public function execute(notification:INotification):void {
			// Faking a refresh by adding elements until there are 10, then removing the last 5. This violates the Law
			// of Demter by directly accessing the methods of eventListProxy.events.
			var eventListProxy:EventListProxy = facade.retrieveProxy(EventListProxy.NAME) as EventListProxy;
			var maxEvents:Number = 10;
			var truncatedEvents:Number = 5;

			if (eventListProxy.numEvents < maxEvents) {
				eventListProxy.events.addItem(new EventVO("777", Math.floor(Math.random() * 100) + 10, "XXX", "foobar", 13));
				eventListProxy.events.refresh();
			} else {
				while (eventListProxy.numEvents > truncatedEvents) {
					eventListProxy.events.removeItemAt(truncatedEvents);
				}
			}
		}

	}
}