/*
1. Two seperate SOQL for Close-won and Close-Lost are not requires
2. Two loops inside loop not required.
3. Loop only those Opportunities that are releted to that particular account in the Account loop
*/
trigger accountTrigger on Account (before delete, before insert, before update) 
{
    List<Account> acctList = [SELECT Id, Name, (SELECT Id, Name, CloseDate, StageName FROM Opportunities WHERE StageName = 'Closed - Won' OR StageName = 'Closed - Lost') FROM Account WHERE Id IN :Trigger.new];
    for(Account a : acctList)
    {
        for(Opportunity o: a.Opportunities)
        {
            if(o.StageName == 'Closed - Won')
                System.debug('Do more logic here...');
            if(o.StageName == 'Closed - Lost')
                System.debug('Do more logic here...');
        }
    }
}