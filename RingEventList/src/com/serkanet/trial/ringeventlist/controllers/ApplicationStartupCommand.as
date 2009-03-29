package com.serkanet.trial.ringeventlist.controllers {
	import com.serkanet.trial.ringeventlist.models.EventListProxy;
	import com.serkanet.trial.ringeventlist.views.*;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;


	public class ApplicationStartupCommand extends SimpleCommand {

		override public function execute(notification:INotification):void {
			facade.registerProxy(new EventListProxy());

			var app:RingEventListApp = notification.getBody() as RingEventListApp;
			facade.registerMediator(new EventListMediator(app.eventList2));
		}

	}
}