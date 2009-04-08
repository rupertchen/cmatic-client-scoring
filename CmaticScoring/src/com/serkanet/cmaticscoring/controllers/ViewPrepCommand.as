package com.serkanet.cmaticscoring.controllers {
	import com.serkanet.cmaticscoring.ApplicationFacade;
	import com.serkanet.cmaticscoring.views.ApplicationMediator;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class ViewPrepCommand extends SimpleCommand {

		override public function execute(notification:INotification):void {
			facade.registerMediator(new ApplicationMediator(notification.getBody() as CmaticScoring));

			sendNotification(ApplicationFacade.VIEW_MAIN_SCREEN);
		}

	}
}
