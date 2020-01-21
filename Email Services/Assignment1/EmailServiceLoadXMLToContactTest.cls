@isTest
public class EmailServiceLoadXMLToContactTest 
{
    @isTest 
    static void testEmailServiceLoadXMLToContact_testEmailService_getDataLoaded() 
    {
        // create a new email and envelope object
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        EmailServiceLoadXMLToContact testInbound = new EmailServiceLoadXMLToContact ();
        List<Contact> ct = [SELECT Id, Name FROM Contact WHERE Name  = 'Test Contact 1'];
        // setup the data for the email
        email.subject = 'Insert Contacts';
        email.fromAddress = 'shrish.sharma@metacube.com';
        email.plainTextBody = ' ';
        // add an Binary attachment
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
        attachment.body = blob.valueOf('<?xml version="1.0" encoding="UTF-8"?><contacts><contact><Name>Test Contact 1</Name><Email>shrish.sharma@metacube.com</Email><Department>Department 1</Department><Phone>9999999991</Phone><Subject>English</Subject></contact></contacts>');
        attachment.fileName = 'ContactData.xml';
        attachment.mimeTypeSubType = 'text/xml';
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
        System.assertEquals(0, ct.size());
        // call the email service class and test it with the data in the testMethod
        testInbound.handleInboundEmail(email, env);
        ct = [SELECT Id, Name FROM Contact WHERE Name  = 'Test Contact 1'];
        System.assertEquals(1, ct.size());
    }
    @isTest 
    static void testEmailServiceLoadXMLToContact_testEmailService_failedDataLoad() 
    {
        // create a new email and envelope object
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        EmailServiceLoadXMLToContact testInbound = new EmailServiceLoadXMLToContact ();
        List<Contact> ct = [SELECT Id, Name FROM Contact WHERE Name  = 'Test Contact 1'];
        // setup the data for the email
        email.subject = 'Insert Contacts';
        email.fromAddress = 'shrish.sharma@metacube.com';
        email.plainTextBody = ' ';
        // add an Binary attachment
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
        attachment.body = blob.valueOf('<?xml version="1.0" encoding="UTF-8"?><contacts><contact><Name>Test Contact 1</Name><Email>shrish.sharma@metacube.com</Email><Department>Department 1</Department><Phone>9999999991</Phone><Subject>English</Subject></contact>');
        attachment.fileName = 'ContactData.xml';
        attachment.mimeTypeSubType = 'text/xml';
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
        System.assertEquals(0, ct.size());
        // call the email service class and test it with the data in the testMethod
        Test.startTest();
        Messaging.InboundEmailResult result = testInbound.handleInboundEmail(email, env);
        Test.stopTest();
        ct = [SELECT Id, Name FROM Contact WHERE Name  = 'Test Contact 1'];
        System.assertEquals(0, ct.size());
        System.assertEquals(false, result.success);
    }
}