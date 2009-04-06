package com.serkanet.trial.scoringdataentry.controllers {
	import com.serkanet.trial.scoringdataentry.models.AppConfigProxy;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.utilities.flex.config.model.ConfigProxy;

	public class PostConfigStartupCommand extends SimpleCommand {

		override public function execute(notification:INotification):void {
			trace("Config received, continue setting up app.");
			var configProxy:AppConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as AppConfigProxy;
			trace(configProxy.appConfig.getService);
		}

	}
}
