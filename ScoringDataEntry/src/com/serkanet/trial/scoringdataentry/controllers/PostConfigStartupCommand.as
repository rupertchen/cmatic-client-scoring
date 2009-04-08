package com.serkanet.trial.scoringdataentry.controllers {
	import com.serkanet.trial.scoringdataentry.models.AgeGroupsProxy;
	import com.serkanet.trial.scoringdataentry.models.AppConfigProxy;
	import com.serkanet.trial.scoringdataentry.models.CompetitorsProxy;
	import com.serkanet.trial.scoringdataentry.models.DivisionsProxy;
	import com.serkanet.trial.scoringdataentry.models.EventScoringsProxy;
	import com.serkanet.trial.scoringdataentry.models.EventsProxy;
	import com.serkanet.trial.scoringdataentry.models.FormsProxy;
	import com.serkanet.trial.scoringdataentry.models.GroupsProxy;
	import com.serkanet.trial.scoringdataentry.models.SexesProxy;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.utilities.flex.config.model.ConfigProxy;

	public class PostConfigStartupCommand extends SimpleCommand {

		override public function execute(notification:INotification):void {
			trace("Config received, continue setting up app.");
			var configProxy:AppConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as AppConfigProxy;

			var divisionsProxy:DivisionsProxy = new DivisionsProxy();
			facade.registerProxy(divisionsProxy);
			divisionsProxy.load();

			var formsProxy:FormsProxy = new FormsProxy();
			facade.registerProxy(formsProxy);
			formsProxy.load();

			var sexesProxy:SexesProxy = new SexesProxy();
			facade.registerProxy(sexesProxy);
			sexesProxy.load();

			var ageGroupsProxy:AgeGroupsProxy = new AgeGroupsProxy();
			facade.registerProxy(ageGroupsProxy);
			ageGroupsProxy.load();

			var competitorsProxy:CompetitorsProxy = new CompetitorsProxy();
			facade.registerProxy(competitorsProxy);
			competitorsProxy.load();

			var groupsProxy:GroupsProxy = new GroupsProxy();
			facade.registerProxy(groupsProxy);
			groupsProxy.load();

			var eventsProxy:EventsProxy = new EventsProxy();
			facade.registerProxy(eventsProxy);
			eventsProxy.load("ringId", "1");

			var eventScoringsProxy:EventScoringsProxy = facade.retrieveProxy(EventScoringsProxy.NAME) as EventScoringsProxy;
			eventScoringsProxy.load("eventId", "23");
		}

	}
}
