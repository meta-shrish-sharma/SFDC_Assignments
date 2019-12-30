<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Sending_For_Unauthorise_Update</fullName>
        <description>Email Sending For Unauthorise Update</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Account/Account_Update</template>
    </alerts>
    <rules>
        <fullName>Account Updation</fullName>
        <actions>
            <name>Email_Sending_For_Unauthorise_Update</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(
AnnualRevenue  &gt; 1000000,
Owner.Id &lt;&gt; LastModifiedBy.Id )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
