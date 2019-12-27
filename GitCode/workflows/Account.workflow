<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>EmailSendingForUnauthoriseUpdate</fullName>
        <description>EmailSendingForUnauthoriseUpdate</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Account/AccountUpdate</template>
    </alerts>
    <rules>
        <fullName>AccountUpdation</fullName>
        <actions>
            <name>EmailSendingForUnauthoriseUpdate</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(
AnnualRevenue  &gt; 1000000,
OwnerId &lt;&gt; LastModifiedById )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
