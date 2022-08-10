import 'dart:io';

import 'package:grocery_app/screens/invoice/api/pdf_api.dart';
import 'package:grocery_app/screens/invoice/model/customer.dart';
import 'package:grocery_app/screens/invoice/model/invoice.dart';
import 'package:grocery_app/screens/invoice/model/supplier.dart';
import 'package:grocery_app/screens/invoice/utils.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

class PdfInvoiceApi {
  static Future<File> generate(
      Invoice invoice, String invoceName, String vatamnt) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(invoice),
        SizedBox(height: 1 * PdfPageFormat.cm),
        buildTitle(invoice),
        buildHeaderCustomer(invoice),
        SizedBox(height: 1 * PdfPageFormat.cm),
        buildInvoice(invoice),
        Divider(),
        buildTotal(invoice, vatamnt),
      ],
      footer: (context) => buildFooter(invoice),
    ));

    return PdfApi.saveDocument(name: invoceName, pdf: pdf);
  }

  static Widget buildHeader(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 150,
                width: 150,
                child: pw.Image(
                    pw.MemoryImage(invoice.supplier.filename.readAsBytesSync()),
                    height: 150,
                    width: 150),

                /*BarcodeWidget(
                  barcode: Barcode.qrCode(),
                  data: invoice.info.number,
                ),*/
              ),
              pw.Padding(
                  padding: EdgeInsets.only(right: 3),
                  child: pw.Container(
                      width: 198,
                      child: buildSupplierAddress(invoice.supplier))),
            ],
          ),
          /*SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              pw.Container(
                width: 198,
                child: buildCustomerAddress(invoice.customer),
              ),
              buildInvoiceInfo(invoice.info),
            ],
          ),*/
        ],
      );
  static Widget buildHeaderCustomer(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              pw.Container(
                width: 198,
                child: buildCustomerAddress(invoice.customer),
              ),
              buildInvoiceInfo(invoice.info),
            ],
          ),
        ],
      );

  static Widget buildCustomerAddress(Customer customer) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(customer.name.toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text(customer.address),
          Text("Mo. " + customer.mobileNo),
          Text("Email : " + customer.EmailAddress),
        ],
      );

  static Widget buildInvoiceInfo(InvoiceInfo info) {
    final paymentTerms = '${info.dueDate.difference(info.date).inDays} days';
    final titles = <String>[
      'Invoice Number:',
      'Invoice Date:',
      'Payment Terms:',
      'Due Date:'
    ];
    final data = <String>[
      info.number,
      Utils.formatDate(info.date),
      paymentTerms,
      Utils.formatDate(info.dueDate),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];

        return buildText(title: title, value: value, width: 200);
      }),
    );
  }

  static Widget buildSupplierAddress(Supplier supplier) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(supplier.name.toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text(supplier.address),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text("Mo. " + supplier.mobileNo),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text("Email : " + supplier.EmailAddress),
        ],
      );

  static Widget buildTitle(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          pw.Container(
              alignment: Alignment.center,
              width: double.infinity,
              child: Text(
                'INVOICE',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              decoration: BoxDecoration(color: PdfColors.grey300)),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          /*Text(invoice.info.description),
          SizedBox(height: 0.8 * PdfPageFormat.cm),*/
        ],
      );

  static Widget buildInvoice(Invoice invoice) {
    final headers = [
      'Description',
      'Date',
      'Qty',
      'Unit Price',
      'VAT %',
      'Total'
    ];
    final data = invoice.items.map((item) {
      final total = item.unitPrice * item.quantity * (1 + 0.00); //item.vat);

      return [
        item.description,
        Utils.formatDate(item.date),
        '${item.quantity}',
        '\£ ${item.unitPrice}',
        '${item.vat}',
        '\£${total.toStringAsFixed(2)}',
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      columnWidths: {
        0: FlexColumnWidth(4),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(2),
        4: FlexColumnWidth(2),
        5: FlexColumnWidth(2),
      },
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerLeft,
        2: Alignment.centerLeft,
        3: Alignment.center,
        4: Alignment.centerLeft,
        5: Alignment.centerRight,
      },
    );
  }

  static Widget buildTotal(Invoice invoice, String vatamnt1) {
    final netTotal = invoice.items
        .map((item) => item.unitPrice * item.quantity)
        .reduce((item1, item2) => item1 + item2);
    double vattotal = 0.00;
    double TotolQTY = 0;
    for (int i = 0; i < invoice.items.length; i++) {
      vattotal += invoice.items[i].vat;
      TotolQTY += invoice.items[i].quantity;
    }
    final vatPercent = vattotal;
    final vat = double.parse(vatamnt1); //netTotal * vatPercent / 100;
    final total = netTotal + vat;

    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                  title: 'Total QTY',
                  value: Utils.formatWithoutSignPrice(TotolQTY),
                  unite: true,
                ),
                buildText(
                  title: 'BasicAmount',
                  value: Utils.formatPrice(netTotal),
                  unite: true,
                ),
                buildText(
                  title: 'Vat %',
                  value: Utils.formatPrice(vat),
                  unite: true,
                ),
                Divider(),
                buildText(
                  title: 'NetAmount',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: Utils.formatPrice(total),
                  unite: true,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildFooter(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          pw.Container(
            width: double.infinity,
            child: buildSimpleText(
                title: 'Address', value: invoice.supplier.address),
          ),
          /*   SizedBox(height: 1 * PdfPageFormat.mm),
          buildSimpleText(title: 'Paypal', value: invoice.supplier.paymentInfo),*/
        ],
      );

  static buildSimpleText({
    String title,
    String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Column(
      //mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        Text(title, style: style, textAlign: TextAlign.center),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    String title,
    String value,
    double width = double.infinity,
    TextStyle titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}
