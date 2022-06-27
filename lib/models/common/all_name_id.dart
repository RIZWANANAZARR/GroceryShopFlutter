class ALL_Name_ID {
  int pkID;
  String Name;
  String Name1;
  String PresentDate;
  String Taxtype;
  String TaxRate;
  bool isChecked;
  double Amount;
  double VatAmount;
  double NetAmount;
  String InvoiceNo;

  ALL_Name_ID(
      {this.pkID,
      this.Name,
      this.Name1,
      this.PresentDate,
      this.isChecked,
      this.Amount,
      this.VatAmount,
      this.NetAmount,
      this.InvoiceNo});
}
