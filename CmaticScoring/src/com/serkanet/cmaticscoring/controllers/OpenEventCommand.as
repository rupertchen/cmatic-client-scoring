package com.serkanet.cmaticscoring.controllers {
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

			if (mainScreenMediator.hasTab(eventVo.code)) {
				mainScreenMediator.bringTabUp(eventVo.code);
				return;
			}

			// Create component
			var panel:EventScoringsPanel = new EventScoringsPanel();
			panel.eventCode = eventVo.code;
			panel.eventName = eventVo.name;
			mainScreenMediator.addTab(panel);

			// Pair the proxy and mediator
			var uid:String = UIDUtil.createUID();

			// Create proxy
			// TODO: code

			// create mediator
			var mediator:EventScoringsMediator = new EventScoringsMediator(uid, panel);
			facade.registerMediator(mediator);
		}


		private function get mainScreenMediator(): MainScreenMediator {
			return facade.retrieveMediator(MainScreenMediator.NAME) as MainScreenMediator;
		}

	}
}
