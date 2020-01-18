public class OpportunityTriggerHandler 
{
    public static void updateOpportunityList(List<Opportunity> oppList, Map<Id, Opportunity> oldOpportunities)
    {
        String lostValue = 'Closed Lost';
        String wonValue = 'Closed Won';
        List<Id> cntId = new List<Id>();
        EmailTemplate et = [SELECT Id FROM EmailTemplate WHERE Name = 'Opportunity Stage Change'];
        // List of emails
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        // Owner mail Id
        for (Opportunity opp: oppList)
        {
            cntId.add(opp.BillToContact__c);
        }
        Map<Id, Contact> idCntMap = new Map<Id, Contact>([SELECT Accountid FROM Contact WHERE Id IN :cntId]);
        for(Opportunity opp: oppList)
        {
            String oldOppStagename = oldOpportunities.get(opp.Id).StageName;
            if(opp.Manager__c == null && opp.BillToContact__c != null && idCntMap.get(opp.BillToContact__c) != null)
            {
                opp.Manager__c = idCntMap.get(opp.BillToContact__c).Accountid;
            }
            if(opp.StageName == wonValue || opp.StageName == lostValue)
            {
                if(oldOpportunities.containsKey(opp.Id))//Opportunity should exist in map
                {
                    if(oldOpportunities.get(opp.Id).StageName != null)//Opportunity should have a proper stage name
                    {
                        if(oldOppStagename != wonValue && oldOppStagename != lostValue)
                        {
                            opp.CloseDate = System.today();
                        }
                    }
                }
            }
            if( oldOppStagename != opp.StageName)
            {
                Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
                // Set object Id
                singlemail.setTargetObjectId(opp.OwnerId);
                // Set template Id
                singleMail.setTemplateId(et.Id);
                // Slag to false to stop inserting activity history
                singleMail.setSaveAsActivity(false);
                // Add mail
                emails.add(singleMail);
            }
        }
        if(emails.size() > 0)
        {
            Messaging.sendEmail(emails);
        }
    } 
}