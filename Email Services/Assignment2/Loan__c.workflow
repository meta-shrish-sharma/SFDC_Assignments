<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_Email_On_Loan_Status_Change</fullName>
        <description>Send Email On Loan Status Change</description>
        <protected>false</protected>
        <recipients>
            <field>Applicant_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Loan/Loan_Status_Change</template>
    </alerts>
    <alerts>
        <fullName>Send_Mail_On_Rejection</fullName>
        <description>Send Mail On Rejection</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Loan/Lone_Rejection_Email</template>
    </alerts>
    <alerts>
        <fullName>Send_Mail_on_Approval</fullName>
        <description>Send Mail on Approval</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Loan/Loan_Approval_Email</template>
    </alerts>
    <fieldUpdates>
        <fullName>Approval_Recalled</fullName>
        <field>Loan_Approval__c</field>
        <literalValue>RECALLED</literalValue>
        <name>Approval Recalled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loan_Approved</fullName>
        <field>Loan_Approval__c</field>
        <literalValue>APPROVED</literalValue>
        <name>Loan Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loan_Pending_For_Approval</fullName>
        <field>Loan_Approval__c</field>
        <literalValue>PENDING</literalValue>
        <name>Loan Pending For Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loan_Rejected</fullName>
        <field>Loan_Approval__c</field>
        <literalValue>REJECTED</literalValue>
        <name>Loan Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
