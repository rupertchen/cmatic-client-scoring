package com.serkanet.cmaticscoring.controllers {
	import com.serkanet.cmaticscoring.models.EventScoringsProxy;
	import com.serkanet.cmaticscoring.models.vos.EventVo;
	import com.serkanet.cmaticscoring.views.EventScoringsMediator;
	import com.serkanet.cmaticscoring.views.MainScreenMediator;
	import com.serkanet.cmaticscoring.views.components.EventScoringsPanel;

	import mx.utils.UIDUtil;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class OpenEventCommand extends SimpleCommand {

		override public function execute(notification:INotification):void {
			var eventVo:EventVo = notification.getBody() as EventVo;

			if (!mainScreenMediator.hasTab(eventVo.code)) {
				// Create component
				var panel:EventScoringsPanel = new EventScoringsPanel();
				panel.eventVo = eventVo;
				mainScreenMediator.addTab(panel);

				// Create a pair of proxy and mediator
				var uid:String = UIDUtil.createUID();
				var proxy:EventScoringsProxy = new EventScoringsProxy(uid);
				facade.registerProxy(proxy);
				facade.registerMediator(new EventScoringsMediator(uid, panel));

				// Fetch data
				proxy.load("eventId", eventVo.id);
			}

			mainScreenMediator.bringTabUp(eventVo.code);
		}


		private function get mainScreenMediator(): MainScreenMediator {
			return facade.retrieveMediator(MainScreenMediator.NAME) as MainScreenMediator;
		}

	}
}
