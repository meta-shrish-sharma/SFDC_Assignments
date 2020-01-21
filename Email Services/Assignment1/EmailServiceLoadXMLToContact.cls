public class EmailServiceLoadXMLToContact implements Messaging.InboundEmailHandler 
{
    public Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.Inboundenvelope envelope) 
    {
        String fileXMLString;
        List<Contact> ctList = new List<Contact>();
        // Create an InboundEmailResult object for returning the result of the 
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        for (Messaging.Inboundemail.binaryAttachment bAttachment: email.binaryAttachments)
        {
            if(bAttachment.filename == 'ContactData.xml')
            {
                fileXMLString = bAttachment.body.toString();
            }
        }
        try
        {
            Dom.Document doc=new Dom.Document();
            doc.load(fileXMLString);
            //Retrieve the root element for this document.
            Dom.XMLNode address = doc.getRootElement();
            for(Dom.XMLNode allContacts: address.getChildElements()) 
            {
                Contact ct = new Contact();
                for(Dom.XMLNode contactDetails: allContacts.getChildElements())
                {
                    if(contactDetails.getName() == 'Name')
                        ct.LastName = contactDetails.getText();
                    if(contactDetails.getName() == 'Email')
                        ct.Email = contactDetails.getText();
                    if(contactDetails.getName() == 'Department')
                        ct.Department = contactDetails.getText();
                    if(contactDetails.getName() == 'Phone')
                        ct.Phone = contactDetails.getText();
                    if(contactDetails.getName() == 'Subject')
                        ct.Subject__c = contactDetails.getText();
                }
                ctList.add(ct);
            }
            insert ctList;
            result.success = true;
        }
        catch(Exception e) 
        {
            result.success = false;
        }
        return result;
    }
}