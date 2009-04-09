package com.serkanet.cmaticscoring.controllers {
	import com.serkanet.cmaticscoring.models.AgeGroupsProxy;
	import com.serkanet.cmaticscoring.models.AppConfigProxy;
	import com.serkanet.cmaticscoring.models.CompetitorsProxy;
	import com.serkanet.cmaticscoring.models.DivisionsProxy;
	import com.serkanet.cmaticscoring.models.EventsProxy;
	import com.serkanet.cmaticscoring.models.FormsProxy;
	import com.serkanet.cmaticscoring.models.GroupsProxy;
	import com.serkanet.cmaticscoring.models.SexesProxy;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class ModelPrepCommand extends SimpleCommand {

		override public function execute(notification:INotification):void {
			facade.registerProxy(new AppConfigProxy());

			facade.registerProxy(new DivisionsProxy());
			facade.registerProxy(new SexesProxy());
			facade.registerProxy(new AgeGroupsProxy());
			facade.registerProxy(new FormsProxy());
			facade.registerProxy(new GroupsProxy());
			facade.registerProxy(new EventsProxy());
			facade.registerProxy(new CompetitorsProxy());
		}

	}
}
