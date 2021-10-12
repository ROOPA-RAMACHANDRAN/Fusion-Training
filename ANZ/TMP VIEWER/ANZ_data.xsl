<?xml version='1.0' encoding='utf-8'?>
 <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output omit-xml-declaration="no" /> 
  <xsl:output method="xml" /> 
  <xsl:key name="contacts-by-LogicalGroupReference" match="OutboundPayment" use="LogicalGrouping/LogicalGroupReference" /> 
 <xsl:template match="OutboundPaymentInstruction">
 <Document xmlns="urn:iso:std:iso:20022:tech:xsd:pain.001.001.03" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <xsl:variable name="instrid" select="PaymentInstructionInfo/InstructionReferenceNumber" /> 
 <GrpHdr>
 <MsgId>
  <xsl:value-of select="$instrid" /> 
  </MsgId>
  <CreDtTm>
  <xsl:value-of select="substring(PaymentInstructionInfo/InstructionCreationDate,1,19)" />
	</CreDtTm>
 <NbOfTxs>
  <xsl:value-of select="substring(InstructionTotals/PaymentCount,1,15)" /> 
  </NbOfTxs>
 <CtrlSum>
    <xsl:value-of select="format-number(sum(OutboundPayment/PaymentAmount/Value), '##0.00')"/>
  </CtrlSum>
 <InitgPty>
 <Nm>
  <xsl:value-of select="InstructionGrouping/Payer/LegalEntityName" /> 
  </Nm>
  </InitgPty>
  </GrpHdr>
  <xsl:for-each select="OutboundPayment">
  <PmtInf>
  <PmtInfId>
    <xsl:value-of select="$instrid" /> 
  </PmtInfId>
 <PmtTpInf>
  <CtgyPurp>
  <Cd>SUPP</Cd> 
  </CtgyPurp>
    </PmtTpInf>
 <Dbtr>
 <Nm>
  <xsl:value-of select="substring(Payer/Name,1,32)" /> 
  </Nm>
  <Id>
  <OrgId>
  <Othr>
 <Id>
    <xsl:value-of select="substring(../InstructionGrouping/Payer/LegalEntityRegistrationNumber,1,6)" /> 
   </Id>
   </Othr>
   </OrgId>
  </Id>
 </Dbtr>
 <DbtrAcct>
 <Id>
    <Othr>
    <Id>
      <xsl:value-of select="substring(BankAccount/BankAccountNumber,1,7)" />
    </Id>
  </Othr>
 </Id>
  </DbtrAcct>
 <DbtrAgt>
 <FinInstnId>
   <ClrSysMmbId>
    <MmbId>
	<xsl:value-of select="BankAccount/BranchNumber" /> 
    </MmbId>
  </ClrSysMmbId>
    </FinInstnId>
  </DbtrAgt>
   <CdtTrfTxInf>
 <PmtId>
  <xsl:value-of select="PaymentNumber/CheckNumber" /> 
   <EndToEndId>
  <xsl:value-of select="substring(PaymentNumber/CheckNumber, 1, 18)" /> 
   </EndToEndId>
  </PmtId>
 <Amt>
 <InstdAmt>
 <xsl:attribute name="Ccy">
  <xsl:value-of select="substring(PaymentAmount/Currency/Code,1,3)" /> 
  </xsl:attribute>
    </InstdAmt>
  </Amt>
   <CdtrAgt>
 <FinInstnId>
   <ClrSysMmbId>
  <MmbId>
  <xsl:value-of select="substring(PayeeBankAccount/BranchNumber,1,7)" /> 
  </MmbId>
  </ClrSysMmbId>
    </FinInstnId>
    </CdtrAgt>
 <Cdtr>
 <Nm>
  <xsl:value-of select="substring(SupplierorParty/Name, 1, 35) " /> 
  </Nm>
   </Cdtr>
 <CdtrAcct>
 <Id>
    <Othr>
   <Id>
     <xsl:value-of select="PayeeBankAccount/BankAccountNumber" />
   </Id>
  </Othr>
  </Id>
    </CdtrAcct>
  </CdtTrfTxInf>
  </PmtInf>
 </xsl:for-each>
  
  </Document>
  </xsl:template>
  </xsl:stylesheet>
