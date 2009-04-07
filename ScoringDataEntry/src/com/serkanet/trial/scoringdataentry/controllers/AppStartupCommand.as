package com.serkanet.trial.scoringdataentry.controllers {

	import com.serkanet.trial.scoringdataentry.models.AppConfigProxy;
	import com.serkanet.trial.scoringdataentry.models.EventScoringsProxy;
	import com.serkanet.trial.scoringdataentry.views.EventScoringsMediator;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;


	public class AppStartupCommand extends SimpleCommand {

		override public function execute(notification:INotification):void {
			var configProxy:AppConfigProxy = new AppConfigProxy();
			facade.registerProxy(configProxy);
			configProxy.retrieveConfig();

			facade.registerProxy(new EventScoringsProxy());

			var app:ScoringDataEntryApp = notification.getBody() as ScoringDataEntryApp;
			facade.registerMediator(new EventScoringsMediator(app.eventScorings));
		}

	}
}