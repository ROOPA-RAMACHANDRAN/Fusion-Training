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
		<xsl:value-of select="substring(PaymentInstructionInfo/InstructionCreationDate,1,19)"/>
  </CreDtTm>
 <NbOfTxs>
  <xsl:value-of select="substring(InstructionTotals/PaymentCount,1,15)" /> 
  </NbOfTxs>
 <CtrlSum>
    <xsl:value-of select="substring(format-number(sum(InstructionTotals/TotalPaymentAmount/Value), '##0.00'),1,18)"/>
  </CtrlSum>
 <InitgPty>
 <Id>
 <OrgId>
 <BICOrBEI>
  <xsl:value-of select="substring(InstructionGrouping/BankAccount/SwiftCode,1,11)"/> 
 </BICOrBEI>
  </OrgId>
  </Id>
  </InitgPty>
  </GrpHdr>
 <xsl:for-each select="OutboundPayment">
  <PmtInf>
  <PmtInfId>
  <xsl:value-of select="$instrid" /> 
  </PmtInfId>
  <PmtMtd>TRF</PmtMtd>
  <PmtTpInf>
  <SvcLvl>
  <Cd>
  <xsl:value-of select="substring(PaymentMethod/PaymentMethodInternalID,1,4)" /> 
  </Cd> 
  </SvcLvl>
  </PmtTpInf>
  <ReqdExctnDt>
  <xsl:value-of select="substring(PaymentDate,1,10)" /> 
  </ReqdExctnDt>
  <Dbtr>
 <Nm>The Ascott Ltd</Nm>
 <PstlAdr>
 <Ctry>
  <xsl:value-of select="substring(BankAccount/BankAddress/Country,1,2)" /> 
  </Ctry>
 </PstlAdr>
 <Id>
 <OrgId>
<Othr>
 <Id>
 <xsl:value-of select="substring(../InstructionGrouping/BankAccount/SwiftCode,1,35)" />
 </Id>
 </Othr>
 </OrgId>
 </Id>
 </Dbtr>
 <DbtrAcct>
 <Id>
  <Othr>
    <Id>
      <xsl:value-of select="substring(BankAccount/BankAccountNumber,1,34)" />
    </Id>
  </Othr>
 </Id>
 <Ccy>
   <xsl:value-of select="substring(BankAccount/BankAccountCurrency/Code,1,3)" /> 
 </Ccy>
 </DbtrAcct>
 <DbtrAgt>
 <FinInstnId>
 <BIC>
  <xsl:value-of select="substring(../InstructionGrouping/BankAccount/SwiftCode,1,11)" /> 
  </BIC>
  <PstlAdr>
  <Ctry>
  <xsl:value-of select="substring(BankAccount/BankAddress/Country,1,2)" /> 
  </Ctry>
  </PstlAdr>
 </FinInstnId>
  </DbtrAgt>
  <CdtTrfTxInf>
 <PmtId>
 <InstrId>
 <xsl:value-of select="substring(PaymentNumber/CheckNumber,1,35)" /> 
 </InstrId>
 <EndToEndId>
  <xsl:value-of select="substring(PaymentNumber/CheckNumber, 1, 35)" />
  </EndToEndId>
  </PmtId>
  <Amt>
 <InstdAmt>
 <xsl:attribute name="Ccy">
  <xsl:value-of select="substring(PaymentAmount/Currency/Code,1,18)" /> 
  </xsl:attribute>
  </InstdAmt>
  </Amt>
  <CdtrAgt>
 <FinInstnId>
  <Nm>
    <xsl:value-of select="substring(PayeeBankAccount/BankName,1,140)" />
  </Nm>
  <PstlAdr>
  <Ctry>
  <xsl:value-of select="substring(PayeeBankAccount/BankAddress/Country,1,2)" /> 
  </Ctry>
  </PstlAdr>
  </FinInstnId>
  </CdtrAgt>
  <Cdtr>
 <Nm>
  <xsl:value-of select="substring(PayeeBankAccount/BankAccountName,1,140) " /> 
  </Nm>
  <PstlAdr>
  <StrtNm>
  <xsl:value-of select="substring(SupplierorParty/Address/AddressLine1,1,70)" /> 
  </StrtNm>
  <PstCd>
  <xsl:value-of select="substring(SupplierorParty/Address/PostalCode, 1, 16)" /> 
  </PstCd>
  <Ctry>
  <xsl:value-of select="substring(SupplierorParty/Address/Country,1,2)" /> 
  </Ctry>
  </PstlAdr>
  </Cdtr>
  <CdtrAcct>
 <Id>
  <Othr>
   <Id>
     <xsl:value-of select="substring(PayeeBankAccount/BankAccountNumber,1,34)" />
   </Id>
  </Othr>
  </Id>
  </CdtrAcct>
   <RltdRmtInf>
   <xsl:if test="not(Payee/RemitAdviceDeliveryMethod = '')">
   <RmtLctnMtd>EMAL</RmtLctnMtd>
    </xsl:if>
   <xsl:if test="not(Payee/RemitAdviceDeliveryMethod = '')">
<RmtLctnElctrncAdr>
<xsl:value-of select="substring(Payee/RemitAdviceDeliveryMethod,1,2048)" />
</RmtLctnElctrncAdr>
 </xsl:if>
<RmtLctnPstlAdr>
<Nm>
<xsl:value-of select="substring(SupplierorParty/Name,1,140)" />
</Nm>
<Adr>
<PstCd>
<xsl:value-of select="substring(SupplierorParty/Address/PostalCode,1,16)" />
</PstCd>
<Ctry>
<xsl:value-of select="substring(SupplierorParty/Address/Country,1,2)" />
</Ctry>
<AdrLine>
<xsl:value-of select="substring(SupplierorParty/Address/AddressLine1,1,70)" />
</AdrLine>
</Adr>
</RmtLctnPstlAdr>
</RltdRmtInf>
<RmtInf>
<xsl:for-each select="DocumentPayable">
<Ustrd>H:
InvoiceNumber InvoiceDate  InvoiceTotalAmount  InvoiceCurrency  PaymentAmount
</Ustrd>
<Ustrd>3:
<xsl:text> </xsl:text>
<xsl:value-of select="substring(DocumentNumber/ReferenceNumber,1,140)" />
<xsl:text> </xsl:text>
<xsl:value-of select="substring(DocumentDate,1,140)" />
<xsl:text> </xsl:text>
<xsl:value-of select="substring(TotalDocumentAmount/Value,1,140)" />
<xsl:text> </xsl:text>
<xsl:value-of select="substring(TotalDocumentAmount/Currency/Code,1,140)" />
<xsl:text> </xsl:text>
<xsl:value-of select="substring(PaymentAmount/Value,1,140)" />
</Ustrd>
</xsl:for-each>
<Strd>
<Invcr>
<Nm>
<xsl:value-of select="substring(SupplierorParty/Name,1,140)" />
</Nm>
</Invcr>
<Invcee>
<Nm>
<xsl:value-of select="substring(../InstructionGrouping/Payer/Name,1,140)" />
</Nm>
</Invcee>
</Strd>
</RmtInf>
 </CdtTrfTxInf>
  </PmtInf>
  </xsl:for-each>
  </Document>
  </xsl:template>
  </xsl:stylesheet>

