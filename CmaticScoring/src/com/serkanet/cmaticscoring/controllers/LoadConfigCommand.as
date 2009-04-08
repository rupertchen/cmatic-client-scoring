package com.serkanet.cmaticscoring.controllers {
	import com.serkanet.cmaticscoring.ApplicationFacade;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class LoadConfigCommand extends SimpleCommand {

		override public function execute(notification:INotification):void {
			trace("retriev config");
			ApplicationFacade.getConfigProxy().retrieveConfig();
		}

	}
}
